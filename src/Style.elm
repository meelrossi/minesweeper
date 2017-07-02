module Style exposing (..)

import CustomColors exposing (..)
import Html.Attributes exposing (..)
import Html exposing (..)
import Models exposing (..)


tile : Tile -> Html.Attribute msg
tile t =
    style
        [ ( "width", "40px" )
        , ( "height", "40px" )
        , ( "background-color", (getTileColor t) )
        , ( "text-align", "center" )
        ]


getTileColor : Tile -> String
getTileColor t =
    case t.opened of
        True ->
            CustomColors.lightgrey

        False ->
            CustomColors.grey


getColor : Int -> String
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


number : Int -> Html.Attribute msg
number n =
    style
        [ ( "font-size", "18px" )
        , ( "color", getColor n )
        , ( "margin", "0" )
        , ( "text-align", "center" )
        , ( "font-weight", "10" )
        ]


tileImage : Html.Attribute msg
tileImage =
    style
        [ ( "font-size", "18px" )
        , ( "margin", "0" )
        , ( "text-align", "center" )
        ]


minefield : Html.Attribute msg
minefield =
    style
        [ ( "display", "inline-block" )
        , ( "justify-content", "center" )
        ]


container : Html.Attribute msg
container =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "center" )
        , ( "align-items", "center" )
        , ( "height", "100vh" )
        ]


mainMenu : Html.Attribute msg
mainMenu =
    style
        [ ( "padding", "10px" )
        , ( "width", "600px" )
        , ( "text-align", "center" )
        , ( "font-family", "'Dosis', sans-serif" )
        , ( "background-color", CustomColors.brown )
        , ( "border-radius", "20px" )
        ]


menuButton : Html.Attribute msg
menuButton =
    style
        [ ( "margin", "0 auto 30px auto" )
        , ( "width", "300px" )
        , ( "padding", "15px" )
        , ( "border-radius", "10px" )
        , ( "background", CustomColors.pink )
        , ( "font-size", "20px" )
        , ( "display", "block" )
        , ( "text-decoration", "none" )
        , ( "color", "black" )
        ]


menuTitle : Html.Attribute msg
menuTitle =
    style
        [ ( "display", "flex" )
        , ( "color", "white" )
        , ( "margin", "0 auto" )
        , ( "align-items", "center" )
        , ( "justify-content", "center" )
        , ( "padding", "20px" )
        ]


titleText : Html.Attribute msg
titleText =
    style
        [ ( "font-size", "50px" )
        , ( "margin", "0" )
        ]


levelTitle : Html.Attribute msg
levelTitle =
    style
        [ ( "font-size", "60px" )
        , ( "color", CustomColors.pink )
        , ( "margin", "20px" )
        , ( "text-align", "center" )
        ]


mineImage : Html.Attribute msg
mineImage =
    style
        [ ( "width", "70px" )
        , ( "height", "70px" )
        , ( "margin-left", "10px" )
        ]


bombImage : Html.Attribute msg
bombImage =
    style
        [ ( "width", "30px" )
        , ( "height", "30px" )
        ]


flagImage : Html.Attribute msg
flagImage =
    style
        [ ( "width", "20px" )
        , ( "height", "20px" )
        ]


levelLink : Html.Attribute msg
levelLink =
    style
        [ ( "font-size", "16px" )
        , ( "margin", "10px" )
        ]


bombsText : Html.Attribute msg
bombsText =
    style
        [ ( "font-size", "25px" )
        , ( "text-align", "right" )
        , ( "display", "block" )
        ]


lost : Bool -> Html.Attribute msg
lost exploded =
    case exploded of
        False ->
            style
                [ ( "font-size", "20px" )
                , ( "text-align", "center" )
                , ( "color", CustomColors.brown )
                , ( "visibility", "hidden" )
                ]

        True ->
            style
                [ ( "font-size", "20px" )
                , ( "text-align", "center" )
                , ( "color", CustomColors.brown )
                ]
