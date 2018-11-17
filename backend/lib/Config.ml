(*
module TomlUtil = struct
    let require_field data fieldname lens = 
        let open TomlLenses in
        match get data (key fieldname |-- lens) with
        | Some(v) -> CCResult.Ok(v)
        | None -> CCResult.Error("required field missing: " ^ fieldname)
end
*)
open Mdslides_models.Json_models_t

module type S = sig
    type t
    val default : t
    val from_toml : TomlTypes.table -> t MResult.t
end

module Let_syntax = MResult.Let

module Slide = struct
    type t = slide_config

    let default = 
        { title = None
        ; slide_classes = []
        ; classes = []
        }

    let from_toml toml = 
        let open TomlLenses in
        let title = get toml (key "title" |-- string) in
        let slide_classes = 
            get toml (key "slide_classes" |-- array |-- strings) 
            |> CCOpt.get_or ~default:[]
        in
        let text_classes = 
            get toml (key "classes" |-- array |-- strings)
            |> CCOpt.get_or ~default:[]
        in
        CCResult.Ok({ title; slide_classes; classes = text_classes })
end


module Presentation = struct
    type t = presentation_config

    let default =
        { title = None
        ; slide = Slide.default
        }

    let from_toml toml =
        let open TomlLenses in
        let title = get toml (key "title" |-- string) in
        let slide_toml = get toml (key "slide" |-- table) in
        let%bind slide = 
            match slide_toml with
            | Some(s) -> Slide.from_toml s
            | None -> CCResult.Ok(Slide.default)
        in
        CCResult.Ok({ title; slide })

end
