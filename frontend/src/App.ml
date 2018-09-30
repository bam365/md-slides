[%%bs.raw "require('css/main.css')"]

open App_type

let component = ReasonReact.reducerComponent("App")

module Route = struct
    let watch (self: t) = ReasonReact.Router.watchUrl begin fun url ->
        match url.path with
        | [ "slide"; param] ->
            let number = int_of_string param in
            self.send(SetSlide(number))
        | [ ] -> ()
        | _ -> (* TODO: error  page *) ()
    end
end

module Reducer = struct
    let root action _state = 
        match action with
        | SetSlide(slideNum) -> 
            ReasonReact.Update({ currentSlide = slideNum })
end

let initialState () = 
    let currentUrl = ReasonReact.Router.dangerouslyGetInitialUrl () in
    let currentSlide = 
        match currentUrl.path with
        | [ "slide"; param] -> int_of_string param
        | _ -> 0
    in { currentSlide }

let make _children =
    { component with 
      initialState
    ; reducer = Reducer.root
    ; render = App_view.root
    ; didMount = begin fun (self: t) ->
        let watcherId = Route.watch self in
        self.onUnmount (fun () -> ReasonReact.Router.unwatchUrl watcherId)
    end
    }
