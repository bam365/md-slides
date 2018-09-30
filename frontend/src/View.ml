let s_ = ReasonReact.string

let a_ = ReasonReact.array

let when_ cond element =
    if cond then element else ReasonReact.null
