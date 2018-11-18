open CCFun

module P : sig
    val split_fragments : string -> string list
    val fragment_to_html : string -> string
end = struct
    let split_fragments = CCString.split ~by:"\n---\n"

    let fragment_to_html = Omd.of_string %> Omd.to_html
end

open P

let load_slides file = CCIO.with_in file begin fun channel ->
    channel
    |> CCIO.read_all
    |> split_fragments
    |> List.map Mdslides_models.Types.(fun frag -> 
        { slide_body_html = fragment_to_html frag 
        ; config = None (* TODO: load this *)
        })
end
