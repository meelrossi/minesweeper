module Menu exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Routing exposing (..)
import Html.Attributes exposing (src, href)
import Style exposing (..)


view : Html Msg
view =
    div
        [ Style.container ]
        [ div [ Style.mainMenu ]
            [ div [ Style.menuTitle ]
                [ h1 [ Style.titleText ] [ text "MINESWEEPER" ]
                , img [ Style.mineImage, src "src/resources/bomb.png" ] []
                ]
            , a [ Style.menuButton, href easyPath ] [ text "Easy Level" ]
            , a [ Style.menuButton, href mediumPath ] [ text "Medium Level" ]
            , a [ Style.menuButton, href difficultPath ] [ text "Difficult Level" ]
            , a [ Style.helpButton, href helpPath ] [ text "Help" ]
            ]
        ]
