module Level.Easy exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Minefield exposing (..)
import Models exposing (..)


view : Model -> Html Msg
view model =
    div [ Style.levelTitle ]
        [ text "Easy"
        , p [ Style.lost model.exploded ] [ text "PERDISTE PERDISTE NO HAY NADIE PEOR QUE VOS" ]
        , Minefield.getHTMLMinefield model.minefield
        ]
