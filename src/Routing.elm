module Routing exposing (..)

import Models exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map MenuRoute top
        , map MenuRoute (s "menu")
        , map EasyRoute (s "easy")
        , map MediumRoute (s "medium")
        , map DifficultRoute (s "difficult")
        , map HelpRoute (s "help")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


menuPath : String
menuPath =
    "#menu"


easyPath : String
easyPath =
    "#easy"


mediumPath : String
mediumPath =
    "#medium"


difficultPath : String
difficultPath =
    "#difficult"


helpPath : String
helpPath =
    "#help"
