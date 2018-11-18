module S = struct
    type state = 
        | NoSlides
        | LoadingSlides
        | Slides of Json_models_t.slides 

    type action = 
        | FetchSlides 
        | SlidesFetched of Json_models_t.slides
end

include S
include Component.Stateful.Make(S)
