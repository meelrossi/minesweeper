module Help exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Models exposing (..)


view : Model -> Html Msg
view model =
    div [ Style.helpTitle ]
        [ p [] [ text "HELP" ]
        , div []
            [ p [ Style.helpText ] [ text "right click: mark tile as bomb" ]
            , p [ Style.helpText ] [ text "left click on unopened tile: open tile" ]
            , p [ Style.helpText ] [ text "left click on opened tile: open neighbors" ]
            , p [ Style.helpText ] [ text "refresh button: create new play" ]
            ]
        ]
