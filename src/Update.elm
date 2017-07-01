module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (parseLocation)
import Minefield exposing (..)
import Matrix exposing (..)
import Tile exposing (..)
import Time exposing (..)
import Task exposing (..)
import Random.Pcg exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                ( newModel, newSeed ) =
                    case newRoute of
                        EasyRoute ->
                            Minefield.new 10 10 20 model.seed

                        MediumRoute ->
                            Minefield.new 25 25 30 model.seed

                        DifficultRoute ->
                            Minefield.new 40 40 70 model.seed

                        _ ->
                            Minefield.new 0 0 0 model.seed
            in
                ( { model | minefield = newModel, seed = newSeed, route = newRoute }, Cmd.none )

        OpenTile tile ->
            case tile.opened of
                True ->
                    let
                        ( newMinefield, exp ) =
                            checkAndOpenNeighbors model.minefield tile
                    in
                        ( { model | minefield = newMinefield, exploded = exp }, Cmd.none )

                False ->
                    let
                        openTile =
                            { tile | opened = True, marked = False }

                        ( newMinefield, exp ) =
                            case openTile.tp of
                                Bomb ->
                                    ( Matrix.map (\tile -> { tile | opened = True }) model.minefield, True )

                                Number ->
                                    case openTile.value of
                                        0 ->
                                            ( Minefield.clearNeighbors (Matrix.set tile.location openTile model.minefield) (getNeighbors openTile.location), False || model.exploded )

                                        _ ->
                                            ( Matrix.set tile.location openTile model.minefield, False || model.exploded )
                    in
                        ( { model | minefield = newMinefield, exploded = exp }, Cmd.none )

        MarkTile tile ->
            let
                markTile =
                    { tile | marked = not tile.marked }

                newMinefield =
                    Matrix.set tile.location markTile model.minefield
            in
                ( { model | minefield = newMinefield }, Cmd.none )

        NewTime time ->
            let
                ns =
                    initialSeed (round time)

                ( newMinefield, newSeed ) =
                    case model.route of
                        EasyRoute ->
                            Minefield.new 10 10 20 ns

                        MediumRoute ->
                            Minefield.new 25 25 30 ns

                        DifficultRoute ->
                            Minefield.new 40 40 70 ns

                        _ ->
                            Minefield.new 0 0 0 ns
            in
                ( { model | seed = newSeed, minefield = newMinefield }, Cmd.none )

        Refresh ->
            ( model, Task.perform NewTime Time.now )
