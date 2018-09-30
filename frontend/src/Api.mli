module JsonDecode : sig
    val slides : Js.Json.t -> Model.slides
end

val fetchSlides : unit -> Model.slides Js.Promise.t
