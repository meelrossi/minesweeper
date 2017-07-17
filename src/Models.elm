module Models exposing (..)

import Matrix exposing (..)
import Random.Pcg exposing (Seed)


type alias Model =
    { route : Route
    , current : CurrentState
    , seed : Seed
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
    , state : TileState
    , location : Location
    }


type CurrentState
    = Game Minefield GameState
    | Menu


type GameState
    = Win
    | Lose
    | Playing


type TileType
    = Number Int
    | Bomb


type TileState
    = Opened
    | Closed
    | Marked


type Route
    = MenuRoute
    | EasyRoute
    | MediumRoute
    | DifficultRoute
    | HelpRoute
    | NotFoundRoute
