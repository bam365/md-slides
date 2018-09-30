open Util.Fun

module JsonDecode = struct
    open Json.Decode

    let slides = field "slides" (list string) 
end

let fetchSlides () = 
    let open Js.Promise in
    Fetch.fetch("/api/slides")
    |> then_ Fetch.Response.json
    |> then_ (JsonDecode.slides %> resolve)
