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
                        prevMinefield =
                            model.minefield

                        ( newField, exp ) =
                            checkAndOpenNeighbors prevMinefield.field tile

                        newMinefield =
                            { prevMinefield | field = newField }
                    in
                        ( { model | minefield = newMinefield, exploded = exp }, Cmd.none )

                False ->
                    let
                        prevMinefield =
                            model.minefield

                        openTile =
                            { tile | opened = True, marked = False }

                        ( newField, exp ) =
                            case openTile.tp of
                                Bomb ->
                                    ( Matrix.map (\tile -> { tile | opened = True }) prevMinefield.field, True )

                                Number ->
                                    case openTile.value of
                                        0 ->
                                            ( Minefield.clearNeighbors (Matrix.set tile.location openTile prevMinefield.field) (getNeighbors openTile.location), False || model.exploded )

                                        _ ->
                                            ( Matrix.set tile.location openTile prevMinefield.field, False || model.exploded )

                        newMinefield =
                            { prevMinefield | field = newField }
                    in
                        ( { model | minefield = newMinefield, exploded = exp }, Cmd.none )

        MarkTile tile ->
            let
                prevMinefield =
                    model.minefield

                markTile =
                    { tile | marked = not tile.marked }

                newField =
                    Matrix.set tile.location markTile prevMinefield.field

                marks =
                    case markTile.marked of
                        True ->
                            prevMinefield.marks + 1

                        False ->
                            prevMinefield.marks - 1

                newMinefield =
                    { prevMinefield | field = newField, marks = marks }
            in
                ( { model | minefield = newMinefield }, Cmd.none )

        NewTime time ->
            let
                prevMinefield =
                    model.minefield

                ns =
                    initialSeed (round time)

                ( newMinefield, newSeed ) =
                    Minefield.new prevMinefield.width prevMinefield.height prevMinefield.bombs ns
            in
                ( { model | seed = newSeed, minefield = newMinefield }, Cmd.none )

        Refresh ->
            ( model, Task.perform NewTime Time.now )
