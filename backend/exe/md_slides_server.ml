open CCFun
open Mdslides
open Mdslides_models
open Opium.Std

let slides_filename = "slides.md"
let config_file = "slides.yaml"

let fe_path_env = "MD_SLIDES_FE_PATH"

let load_config_file conf_file = 
    CCIO.with_in conf_file begin fun channel ->
        let contents = CCIO.read_all channel in
        match Toml.Parser.from_string contents with
        | `Ok(toml) -> 
            let open Config in
            Presentation.from_toml toml
        | `Error(str, _) -> CCResult.Error(str)
    end

module Frontend = struct
    let get_base_path () =
        Sys.getenv_opt fe_path_env
        |> CCOpt.get_or ~default:"fe"

    let handlers fe_base = 
        let path s = fe_base ^ "/" ^ s in
        let serve_index _ = 
            CCIO.with_in (path "src/index.html") begin fun channel ->
                let contents = CCIO.read_all channel in
                `Html contents |> respond'
            end
        in
        let build = 
            Middleware.static ~local_path:(path "build") ~uri_prefix:"/build" 
        in
        let css = 
            Middleware.static ~local_path:(path "src/css") ~uri_prefix:"/css"
        in
        middleware build 
        %> middleware css 
        %> get "/" serve_index
        %> get "/slide/:slidenum" serve_index 
end

module Api = struct
    let json_response s =
        `Json (Ezjsonm.from_string s) |> respond' 
    

    let slides = get "/api/slides" begin fun _ -> 
        let  slides = Types.(
            { slides = SlideFile.load_slides slides_filename }
        ) in
        Json.string_of_slides slides
        |> json_response
    end

    let presentation_config conf = get "/api/presentation-config" begin fun _ ->
        Json.string_of_presentation_config conf
        |> json_response
    end

    let handlers conf =
        slides
        %> presentation_config conf
end

let run_server config fe_base = 
    App.empty
    |> Api.handlers config
    |> Frontend.handlers fe_base
    |> App.run_command
    |> ignore

let run () = 
    let fe_base = Frontend.get_base_path () in
    match load_config_file "md-slides.toml" with
    | Error(str) -> print_endline ("Could not load config: " ^ str)
    | Ok(conf) -> run_server conf fe_base
    
let () = run ()
