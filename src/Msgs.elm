module Msgs exposing (..)

import Navigation exposing (Location)
import Tile exposing (..)
import Time exposing (..)


type Msg
    = OnLocationChange Location
    | OpenTile Tile
    | MarkTile Tile
    | NewTime Time
    | Refresh
