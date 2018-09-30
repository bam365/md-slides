module S = struct
    type state = 
        | NoSlides
        | LoadingSlides
        | Slides of Model.slides 

    type action = 
        | FetchSlides 
        | SlidesFetched of Model.slides
end

include S
include Component.Stateful.Make(S)
