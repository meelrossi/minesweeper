module Menu exposing (..)

import Msgs exposing (..)
import Html exposing (..)
import Routing exposing (..)
import Html.Attributes exposing (src, href)
import Style exposing (..)


view : Html Msg
view =
    div [ Style.mainMenu ]
        [ h1 [ Style.menuTitle ] [ text "MINESWEEPER" ]
        , img [ src "https://lh4.ggpht.com/fxsJt9QQyQAxHIFGAKK_ZgIkknZeOjCbK1ULw9F1vvMkr_mGp1z0NgzwYXvVNVO1KA=w300" ] []
        , a [ Style.menuButton, href easyPath ] [ text "Easy Level" ]
        , a [ Style.menuButton, href mediumPath ] [ text "Medium Level" ]
        , a [ Style.menuButton, href difficultPath ] [ text "Difficult Level" ]
        ]
