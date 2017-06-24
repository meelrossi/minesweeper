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
            [ h1 [ Style.menuTitle ] [ text "MINESWEEPER" ]
            , img [ src "https://lh5.ggpht.com/Z38RGi9W_pEdZDmEYafzHviPk2GXQ2_RmQ0xbGEZbjp7H6LgPOoq-j0Di65MgSmhjxD_=w300" ] []
            , a [ Style.menuButton, href easyPath ] [ text "Easy Level" ]
            , a [ Style.menuButton, href mediumPath ] [ text "Medium Level" ]
            , a [ Style.menuButton, href difficultPath ] [ text "Difficult Level" ]
            ]
        ]
