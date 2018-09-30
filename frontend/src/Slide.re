open View

let component = ReasonReact.statelessComponent("Slide");

let make = (~html: string, _children) => {
    ...component,

    render: _self => {
        <div className="slide">
            <div 
                className="slide-inner"
                dangerouslySetInnerHTML=({ "__html": html })>
            </div>
        </div>
    },
};
