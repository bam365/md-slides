open Mdslides
open Mdslides_models
open Opium.Std

let slides_filename = "slides.md"
let config_file = "slides.yaml"

let fe_path_env = "MD_SLIDES_FE_PATH"

module FEPath = struct
    let get () =
        Sys.getenv_opt fe_path_env
        |> CCOpt.get_or ~default:"fe"

    let path s fe_base = fe_base ^ "/" ^ s

    let index_file  = path "src/index.html"
let build = path "build"

    let css = path "src/build"
end

module Let_syntax = Mdslides.MResult.Let

let load_config_file conf_file = 
    CCIO.with_in conf_file begin fun channel ->
        let contents = CCIO.read_all channel in
        match Toml.Parser.from_string contents with
        | `Ok(toml) -> 
            let open Config in
            Presentation.from_toml toml
        | `Error(str, _) -> CCResult.Error(str)
    end
        
let serve_index fe_base _ = 
    CCIO.with_in (FEPath.index_file fe_base) begin fun channel ->
        let contents = CCIO.read_all channel in
        `Html contents |> respond'
    end

let main fe_base = get "/" (serve_index fe_base)

let slide fe_base = get "/slide/:slidenum" (serve_index fe_base)

let build fe_base = Middleware.static ~local_path:(FEPath.build fe_base) ~uri_prefix:"/build"

let css fe_base = Middleware.static ~local_path:(FEPath.css fe_base) ~uri_prefix:"/css"

let json_response s =
    `Json (Ezjsonm.from_string s) |> respond' 
    

let api_slides = get "/api/slides" begin fun _ -> 
    let  slides = Types.(
        { slides = SlideFile.load_slides slides_filename }
    ) in
    Json.string_of_slides slides
    |> json_response
end

let api_presentation_config conf = get "/api/presentation-config" begin fun _ ->
    Json.string_of_presentation_config conf
    |> json_response
end

let run_server config fe_base = 
    App.empty
    |> api_slides
    |> api_presentation_config config
    |> middleware (build fe_base)
    |> middleware (css fe_base)
    |> slide fe_base
    |> main fe_base
    |> App.run_command
    |> ignore

let run () = 
    let fe_base = FEPath.get () in
    match load_config_file "md-slides.toml" with
    | Error(str) -> print_endline ("Could not load config: " ^ str)
    | Ok(conf) -> run_server conf fe_base
    
let () = run ()
