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
        , p [ Style.state ] []
        , Minefield.getHTMLMinefield model
        , div []
            [ a [ Style.levelLink, href menuPath ]
                [ text "Go to Menu" ]
            , a
                [ Style.levelLink, onClick (Msgs.Refresh) ]
                [ text "Refresh" ]
            ]
        ]


getText : Model -> Html Msg
getText model =
    case model.current of
        Game _ Win ->
            text "Felicitaciones! Has Ganado. :)"

        Game _ Lose ->
            text "Oops has perdido :("

        _ ->
            text ""
