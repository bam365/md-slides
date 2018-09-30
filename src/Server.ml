open Opium.Std

let slides_filename = "slides.md"
let index_file = "../frontend/src/index.html"

module Model = struct
    type slides = 
        { slides: string list
        }

    let json_of_slides slides = 
        let open Ezjsonm in
        dict [ "slides", list string slides.slides ]
end

let serve_index req = 
    CCIO.with_in index_file begin fun channel ->
        let contents = CCIO.read_all channel in
        `Html contents |> respond'
    end

let main = get "/" serve_index

let slide = get "/slide/:slidenum" serve_index

let build = Middleware.static ~local_path:"../frontend/build" ~uri_prefix:"/build"

let css = Middleware.static ~local_path:"../frontend/src/css" ~uri_prefix:"/css"

let api_slides = get "/api/slides" begin fun req -> 
    let  slides = Model.(
        { slides = SlideFile.load_slides slides_filename }
    ) in
    `Json (Model.json_of_slides slides) |> respond'
end
    
let () = 
    App.empty
    |> api_slides
    |> middleware build
    |> middleware css
    |> slide
    |> main
    |> App.run_command
    |> ignore
