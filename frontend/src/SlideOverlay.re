open View

let component = ReasonReact.statelessComponent("SlideOverlay");

let make = 
    (~slides: list(Json_models_t.slide),
     ~currentSlide: int,
     ~requestSlide: (int) => unit,
     children: array(ReasonReact.reactElement)) 
    => {

    let prevSlide = () => {
        requestSlide(currentSlide - 1);
    };
    let nextSlide = () => {
        requestSlide(currentSlide + 1);
    };
    let havePrevSlide = currentSlide > 0;
    let haveNextSlide =  
        currentSlide < List.length(slides) - 1;
    
    let prevButton = (
        <button onClick={_ => prevSlide()} >
            (s_("Previous"))
        </button>
    );

    let nextButton = (
        <button onClick={_ => nextSlide()}>
            (s_("Next"))
        </button>
    );


    {
        ...component,
        render: _self => {
            <div>
                <div>
                    (a_(children))
                </div>
                <div className="slide-controls">
                    (when_(havePrevSlide, prevButton))
                    (when_(haveNextSlide, nextButton))
                </div>
            </div>
        },
    }
};
