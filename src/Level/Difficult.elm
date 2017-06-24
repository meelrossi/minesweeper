module Level.Difficult exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Minefield exposing (..)
import Models exposing (..)


view : Model -> Html Msg
view model =
    div [ Style.levelTitle ]
        [ text "Difficult"
        , Minefield.getHTMLMinefield model.minefield
        ]
