module S = struct
    type state = 
        { currentSlide: int
        }

    type action = 
        | SetSlide of int
end

include S
include Component.Stateful.Make(S)

module Actions = struct
    let setSlideViaUri number =
        Printf.sprintf "/slide/%d" number
        |> ReasonReact.Router.push
end
