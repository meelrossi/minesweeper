module Main exposing (..)

import View exposing (..)
import Msgs exposing (..)
import Navigation exposing (Location)
import Routing
import Update exposing (update)
import Models exposing (..)
import Time exposing (..)
import Task exposing (..)
import Minefield exposing (getMinefield)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Task.perform NewTime Time.now )


initialModel : Route -> Model
initialModel route =
    let
        ( minefield, seed ) =
            getMinefield route
    in
        { route = route
        , minefield = minefield
        , seed = seed
        , exploded = False
        , success = False
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
