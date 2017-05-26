module Style exposing (..)

import Html.Attributes exposing (..)


mainMenu =
    style
        [ ( "margin", "0" )
        , ( "padding", "0" )
        , ( "background-color", "#FFFAF0" )
        , ( "height", "100vh" )
        , ( "text-align", "center" )
        , ( "font-family", "'Dosis', sans-serif" )
        ]


menuButton =
    style
        [ ( "border", "3px solid #C60" )
        , ( "margin", "0 auto 30px auto" )
        , ( "width", "500px" )
        , ( "padding", "15px" )
        , ( "border-radius", "10px" )
        , ( "background", "white" )
        , ( "font-size", "20px" )
        , ( "display", "block" )
        , ( "text-decoration", "none" )
        , ( "color", "black" )
        ]


menuTitle =
    style
        [ ( "font-size", "120px" )
        , ( "display", "block" )
        , ( "margin", "0 auto" )
        , ( "padding", "60px" )
        ]
