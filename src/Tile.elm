module Tile exposing (..)

import Matrix exposing (..)


type TileType
    = Number
    | Bomb


type alias Tile =
    { tp : TileType
    , value : Int
    , opened : Bool
    , location : Location
    , marked : Bool
    }
