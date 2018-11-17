open Mdslides
open Mdslides_models
open Opium.Std

let slides_filename = "slides.md"
let index_file = "../frontend/src/index.html"
let config_file = "slides.yaml"

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
        
let serve_index _ = 
    CCIO.with_in index_file begin fun channel ->
        let contents = CCIO.read_all channel in
        `Html contents |> respond'
    end

let main = get "/" serve_index

let slide = get "/slide/:slidenum" serve_index

let build = Middleware.static ~local_path:"../frontend/build" ~uri_prefix:"/build"

let css = Middleware.static ~local_path:"../frontend/src/css" ~uri_prefix:"/css"

let json_response s =
    `Json (Ezjsonm.from_string s) |> respond' 
    

let api_slides = get "/api/slides" begin fun _ -> 
    let  slides = Json_models_t.(
        { slides = SlideFile.load_slides slides_filename }
    ) in
    Json.string_of_slides slides
    |> json_response
end

let api_presentation_config conf = get "/api/presentation-config" begin fun _ ->
    Json.string_of_presentation_config conf
    |> json_response
end

let run_server config = 
    App.empty
    |> api_slides
    |> api_presentation_config config
    |> middleware build
    |> middleware css
    |> slide
    |> main
    |> App.run_command
    |> ignore

let run () = 
    match load_config_file "md-slides.toml" with
    | Error(str) -> print_endline ("Could not load config: " ^ str)
    | Ok(conf) -> run_server conf
    
let () = run ()
