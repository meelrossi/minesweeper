module Style exposing (..)

import CustomColors exposing (..)
import Html.Attributes exposing (..)


tile =
    style
        [ ( "width", "30px" )
        , ( "height", "30px" )
        , ( "background-color", CustomColors.brown )
        ]


getColor n =
    case n of
        1 ->
            CustomColors.violet

        2 ->
            CustomColors.blue

        3 ->
            CustomColors.green

        4 ->
            CustomColors.pink

        5 ->
            CustomColors.purple

        6 ->
            CustomColors.lightblue

        7 ->
            CustomColors.orange

        8 ->
            CustomColors.violet

        9 ->
            CustomColors.red

        _ ->
            CustomColors.white


number n =
    style
        [ ( "font-size", "18px" )
        , ( "color", getColor n )
        , ( "margin", "0" )
        , ( "text-align", "center" )
        , ( "font-weight", "10" )
        ]


minefield =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "center" )
        ]


container =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "center" )
        , ( "align-items", "center" )
        , ( "height", "100vh" )
        ]


mainMenu =
    style
        [ ( "padding", "10px" )
        , ( "width", "1000px" )
        , ( "text-align", "center" )
        , ( "font-family", "'Dosis', sans-serif" )
        , ( "background-color", CustomColors.brown )
        , ( "border-radius", "20px" )
        ]


menuButton =
    style
        [ ( "margin", "0 auto 30px auto" )
        , ( "width", "500px" )
        , ( "padding", "15px" )
        , ( "border-radius", "10px" )
        , ( "background", CustomColors.pink )
        , ( "font-size", "20px" )
        , ( "display", "block" )
        , ( "text-decoration", "none" )
        , ( "color", "black" )
        ]


menuTitle =
    style
        [ ( "font-size", "120px" )
        , ( "display", "block" )
        , ( "color", "white" )
        , ( "margin", "0 auto" )
        , ( "padding-bottom", "30px" )
        ]


levelTitle =
    style
        [ ( "font-size", "60px" )
        , ( "color", CustomColors.pink )
        , ( "margin", "20px" )
        ]
