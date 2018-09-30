open SlideLoader_type

let component = ReasonReact.reducerComponent("SlideLoader")

module Reducer = struct
    let fetchSlides () = 
        let doFetch (self: t) = Js.Promise.(
            Api.fetchSlides ()
            |> then_ (fun slides -> self.send (SlidesFetched(slides)) |> resolve)
            |> ignore
        ) in
        ReasonReact.UpdateWithSideEffects(LoadingSlides, doFetch)


    let root action state = 
        match action with
        | FetchSlides -> fetchSlides ()
        | SlidesFetched(slides) -> 
            ReasonReact.Update (Slides(slides))
end

let initialState () = NoSlides

let make ~render _children =
    { component with 
      initialState
    ; reducer = Reducer.root
    ; render = SlideLoader_view.root render
    ; didMount = begin fun (self: t) ->
        self.send(FetchSlides);
    end
    }
