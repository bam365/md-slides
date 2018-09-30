SOURCES:=SlideFile.mli SlideFile.ml Server.ml

all: $(SOURCES)
	ocamlfind ocamlc -package omd -package containers -package opium -linkpkg -thread $(SOURCES) 
