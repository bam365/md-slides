(* Auto-generated from "json_models.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type slides = { slides: string list }

type slide_config = {
  title: string option;
  classes: string list;
  slide_classes: string list
}

type presentation_config = { title: string option; slide: slide_config }
