open SlideLoader_type;
open View;

let root = (render, self: t) => {
    switch(self.state) {
    | NoSlides => <div>(s_("No slides"))</div>
    | LoadingSlides => <div>(s_("Loading slides..."))</div>
    | Slides(slides) => render(slides)
    }
};
