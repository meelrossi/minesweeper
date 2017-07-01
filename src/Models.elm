module Models exposing (..)

import Minefield exposing (..)
import Random.Pcg exposing (..)


type alias Model =
    { route : Route
    , minefield : Minefield
    , seed : Seed
    , exploded : Bool
    }


initialModel : Route -> Model
initialModel route =
    let
        ( minefield, seed ) =
            Minefield.new 0 0 0 (initialSeed 324234)
    in
        { route = route
        , minefield = minefield
        , seed = seed
        , exploded = False
        }


type Route
    = MenuRoute
    | EasyRoute
    | MediumRoute
    | DifficultRoute
    | NotFoundRoute
