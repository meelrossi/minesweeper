module Level.Difficult exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Minefield exposing (..)
import Models exposing (..)
import Routing exposing (..)
import Html.Attributes exposing (src, href)
import Html.Events exposing (onClick)


view : Model -> Html Msg
view model =
    div [ Style.levelTitle ]
        [ text "Difficult"
        , p [ Style.lost model.exploded ] [ text "PERDISTE :(" ]
        , p [ Style.lost model.success ] [ text "HAS GANADO" ]
        , Minefield.getHTMLMinefield model.minefield
        , div []
            [ a [ Style.levelLink, href menuPath ]
                [ text "Go to Menu" ]
            , a
                [ Style.levelLink, onClick (Msgs.Refresh) ]
                [ text "Refresh" ]
            ]
        ]
