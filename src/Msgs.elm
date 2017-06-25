module Msgs exposing (..)

import Navigation exposing (Location)
import Tile exposing (..)


type Msg
    = OnLocationChange Location
    | OpenTile Tile
    | MarkTile Tile
