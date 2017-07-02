module Models exposing (..)

import Matrix exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { route : Route
    , minefield : Minefield
    , seed : Seed
    , exploded : Bool
    , success : Bool
    }


type alias Minefield =
    { field : Matrix Tile
    , bombs : Int
    , marks : Int
    , width : Int
    , height : Int
    }


type alias Tile =
    { tp : TileType
    , value : Int
    , opened : Bool
    , location : Location
    , marked : Bool
    }


type TileType
    = Number
    | Bomb


type Route
    = MenuRoute
    | EasyRoute
    | MediumRoute
    | DifficultRoute
    | NotFoundRoute
