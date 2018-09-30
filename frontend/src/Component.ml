module type COMPONENT = sig
    type state
    type action
end

module Stateful = struct
    module Make(M: COMPONENT) = struct
        type t = (M.state, ReasonReact.noRetainedProps, M.action) ReasonReact.self
    end
end
