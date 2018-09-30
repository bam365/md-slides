open App_type;
open View;

let root = (self: t) => (
    <SlideLoader
        render=(slides => 
            <Slideshow 
                slides=slides 
                currentSlide=(self.state.currentSlide)
                requestSlide=(Actions.setSlideViaUri)
            />
        )
    />
);
