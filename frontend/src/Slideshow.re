open View

let component = ReasonReact.statelessComponent("Slideshow");

let make = 
    (~slides: Model.slides,
     ~currentSlide: int,
     ~requestSlide: (int) => unit,
     _children) 
    => {
    ...component,

    render: _self => {
        let renderSlide = slide => (
            <SlideOverlay 
                slides=(slides) 
                currentSlide=(currentSlide)
                requestSlide=(requestSlide) 
            >
                <Slide html=slide></Slide>
            </SlideOverlay>
        );

        let renderBody = 
            switch (Belt.List.get(slides, currentSlide)) {
            | Some(slide) => renderSlide(slide)
            | None => <div className="error">(s_("Invalid slide"))</div>
            };
            
        <div className="slideshow">(renderBody)</div>
    },
};
