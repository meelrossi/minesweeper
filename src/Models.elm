module Models exposing (..)

import Minefield exposing (..)
import Random.Pcg exposing (..)


type alias Model =
    { route : Route
    , minefield : Minefield
    , seed : Seed
    }


initialModel : Route -> Model
initialModel route =
    let
        ( minefield, seed ) =
            Minefield.new 10 10 20 (initialSeed 324234)
    in
        { route = route
        , minefield = minefield
        , seed = seed
        }


type Route
    = MenuRoute
    | EasyRoute
    | MediumRoute
    | DifficultRoute
    | NotFoundRoute
