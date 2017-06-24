module Tile exposing (..)


type TileType
    = Number
    | Bomb
    | Blanks


type alias Tile =
    { tp : TileType
    , value : Int
    , opened : Bool
    }
