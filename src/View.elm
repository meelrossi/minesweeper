module View exposing (..)

import Models exposing (..)
import Html exposing (..)
import Msgs exposing (..)
import Menu
import Help
import Level.Easy
import Level.Medium
import Level.Difficult


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        MenuRoute ->
            Menu.view

        EasyRoute ->
            Level.Easy.view model

        MediumRoute ->
            Level.Medium.view model

        DifficultRoute ->
            Level.Difficult.view model

        HelpRoute ->
            Help.view model

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]
