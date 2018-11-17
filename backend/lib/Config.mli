module type S = sig
    type t
    val default : t
    val from_toml : TomlTypes.table -> t MResult.t
end

module Slide : S 
    with type t = Mdslides_models.Json_models_t.slide_config
 
module Presentation : S 
    with type t = Mdslides_models.Json_models_t.presentation_config
