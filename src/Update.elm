module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (parseLocation)
import Minefield exposing (..)
import Matrix exposing (..)
import Models exposing (Tile)
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
                    Minefield.getMinefield newRoute
            in
                ( { model | current = Game newModel Playing, seed = newSeed, route = newRoute }, Cmd.none )

        OpenTile tile ->
            case model.current of
                Game minefield Playing ->
                    let
                        ( aMinefield, exp ) =
                            case tile.state of
                                Opened ->
                                    let
                                        ( newField, exp ) =
                                            checkAndOpenNeighbors minefield.field tile

                                        newMinefield =
                                            { minefield | field = newField }
                                    in
                                        ( newMinefield, exp )

                                _ ->
                                    let
                                        openTile =
                                            { tile | state = Opened }

                                        ( newField, exp ) =
                                            case openTile.tp of
                                                Bomb ->
                                                    ( Matrix.map (\tile -> { tile | state = Opened }) minefield.field, True )

                                                Number 0 ->
                                                    ( Minefield.clearNeighbors (Matrix.set tile.location openTile minefield.field) (getNeighbors openTile.location), False )

                                                Number _ ->
                                                    ( Matrix.set tile.location openTile minefield.field, False )

                                        newMinefield =
                                            { minefield | field = newField }
                                    in
                                        ( newMinefield, exp )

                        state =
                            case exp of
                                True ->
                                    Lose

                                False ->
                                    case (Minefield.checkSuccess (Matrix.toList aMinefield.field)) of
                                        True ->
                                            Win

                                        False ->
                                            Playing

                        successField =
                            case state of
                                Win ->
                                    Matrix.map (\tile -> { tile | state = Opened }) aMinefield.field

                                _ ->
                                    aMinefield.field

                        newMinefield =
                            { minefield | field = successField }
                    in
                        ( { model | current = Game newMinefield state }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        MarkTile tile ->
            case model.current of
                Game minefield _ ->
                    let
                        prevMinefield =
                            minefield

                        markTile =
                            case tile.state of
                                Marked ->
                                    { tile | state = Closed }

                                Closed ->
                                    { tile | state = Marked }

                                Opened ->
                                    tile

                        newField =
                            Matrix.set tile.location markTile prevMinefield.field

                        marks =
                            case markTile.state of
                                Opened ->
                                    prevMinefield.marks

                                Closed ->
                                    prevMinefield.marks - 1

                                Marked ->
                                    prevMinefield.marks + 1

                        newMinefield =
                            { prevMinefield | field = newField, marks = marks }
                    in
                        ( { model | current = Game newMinefield Playing }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewTime time ->
            case model.current of
                Game minefield _ ->
                    let
                        prevMinefield =
                            minefield

                        ns =
                            initialSeed (round time)

                        ( newMinefield, newSeed ) =
                            Minefield.new prevMinefield.width prevMinefield.height prevMinefield.bombs ns
                    in
                        ( { model | seed = newSeed, current = Game newMinefield Playing }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Refresh ->
            ( model, Task.perform NewTime Time.now )
