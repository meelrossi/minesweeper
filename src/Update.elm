module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (parseLocation)
import Minefield exposing (..)
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
                        MenuRoute ->
                            Minefield.new 0 0 0 model.seed

                        EasyRoute ->
                            Minefield.new 10 10 20 model.seed

                        MediumRoute ->
                            Minefield.new 25 25 30 model.seed

                        DifficultRoute ->
                            Minefield.new 40 40 70 model.seed

                        NotFoundRoute ->
                            Minefield.new 0 0 0 model.seed
            in
                ( { model | minefield = newModel, seed = newSeed, route = newRoute }, Cmd.none )
