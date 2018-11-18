open Util.Fun

let get url decode =
    let open Js.Promise in
    Fetch.fetchWithInit
      url
      (Fetch.RequestInit.make ~method_:Get ())
    |> then_ Fetch.Response.json 
    |> then_ (fun json -> json |> decode |> resolve)

open Json_models_bs

let fetchSlides () = get "/api/slides" read_slides
