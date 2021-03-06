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
import Random.Pcg exposing (..)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Task.perform NewTime Time.now )


initialModel : Route -> Model
initialModel route =
    case route of
        MenuRoute ->
            { route = route
            , current = Menu
            , seed = (initialSeed 0)
            }

        _ ->
            let
                ( minefield, seed ) =
                    getMinefield route
            in
                { route = route
                , current = Game minefield Playing
                , seed = seed
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
