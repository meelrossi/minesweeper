module Minefield exposing (..)

import Matrix exposing (..)
import Models exposing (..)
import Random.Pcg exposing (..)
import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Html.Attributes exposing (src, href)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json


checkSuccess : List (List Tile) -> Bool
checkSuccess tiles =
    case tiles of
        [] ->
            True

        xs :: rest ->
            case checkRowSuccess xs of
                True ->
                    checkSuccess rest

                False ->
                    False


checkRowSuccess : List Tile -> Bool
checkRowSuccess rows =
    case rows of
        [] ->
            True

        xs :: rest ->
            case xs.tp of
                Number n ->
                    case xs.state of
                        Opened ->
                            checkRowSuccess rest

                        _ ->
                            False

                Bomb ->
                    checkRowSuccess rest


getMinefield : Route -> ( Minefield, Seed )
getMinefield route =
    case route of
        EasyRoute ->
            new 8 8 10 (initialSeed 324234)

        MediumRoute ->
            new 16 16 40 (initialSeed 324234)

        DifficultRoute ->
            new 16 30 99 (initialSeed 324234)

        _ ->
            new 0 0 0 (initialSeed 0)


new : Int -> Int -> Int -> Seed -> ( Minefield, Seed )
new width height bombs seed0 =
    let
        ( positions, seed ) =
            getRandomPositions width height bombs seed0 []

        matrix =
            Matrix.matrix height
                width
                (\location ->
                    if List.member location positions then
                        Tile Bomb Closed location
                    else
                        Tile (Number (List.foldr (+) 0 (List.map (\x -> x positions) (List.map isMine (getNeighbors location))))) Closed location
                )
    in
        ( { field = matrix, bombs = bombs, marks = 0, width = width, height = height }, seed )


onRightClick : a -> Attribute a
onRightClick message =
    onWithOptions
        "contextmenu"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.succeed message)


getRandomPositions : Int -> Int -> Int -> Seed -> List Location -> ( List Location, Seed )
getRandomPositions width height bombs seed positions =
    if List.length positions == bombs then
        ( positions, seed )
    else
        let
            ( loc, seed1 ) =
                step (pair (int 0 (height - 1)) (int 0 (width - 1))) seed
        in
            if List.member loc positions then
                getRandomPositions width height bombs seed1 positions
            else
                getRandomPositions width height bombs seed1 (loc :: positions)


isMine : Location -> List Location -> Int
isMine ( x, y ) positions =
    if List.member ( x, y ) positions then
        1
    else
        0


getHTMLMinefield : Model -> Html Msg
getHTMLMinefield model =
    case model.current of
        Game minefield _ ->
            let
                success =
                    case model.current of
                        Game _ Win ->
                            True

                        _ ->
                            False
            in
                div [ Style.minefield ]
                    [ p [ Style.bombsText ] [ text (String.concat [ toString (minefield.marks), "/", toString (minefield.bombs) ]), img [ Style.bombImage, src "src/resources/bomb.png" ] [] ]
                    , div []
                        [ table []
                            (List.map
                                (\row ->
                                    tr []
                                        (List.map
                                            (\column ->
                                                td [ (Style.tile column), onClick (Msgs.OpenTile column), onRightClick (Msgs.MarkTile column) ] (getColumnTile column success)
                                            )
                                            row
                                        )
                                )
                                (Matrix.toList minefield.field)
                            )
                        ]
                    ]

        Menu ->
            div [] []


getItem : Int -> Bool -> Html Msg
getItem n success =
    case n of
        9 ->
            case success of
                True ->
                    img [ Style.flagImage, src "src/resources/flag.png" ] []

                False ->
                    img [ Style.bombImage, src "src/resources/bomb.png" ] []

        0 ->
            text ""

        _ ->
            text (toString (n))


getColumnTile : Tile -> Bool -> List (Html Msg)
getColumnTile tile success =
    case tile.state of
        Opened ->
            let
                value =
                    case tile.tp of
                        Number n ->
                            n

                        Bomb ->
                            9
            in
                [ b [] [ p [ Style.number value ] [ getItem value success ] ] ]

        Marked ->
            [ b [] [ p [ Style.tileImage ] [ img [ Style.flagImage, src "src/resources/flag.png" ] [] ] ] ]

        Closed ->
            []


getNeighbors : Location -> List Location
getNeighbors ( x, y ) =
    [ ( x - 1, y + 1 ), ( x, y + 1 ), ( x + 1, y + 1 ), ( x - 1, y ), ( x + 1, y ), ( x - 1, y - 1 ), ( x, y - 1 ), ( x + 1, y - 1 ) ]


checkAndOpenNeighbors : Matrix Tile -> Tile -> ( Matrix Tile, Bool )
checkAndOpenNeighbors minefield tile =
    let
        neighbors =
            getNeighbors tile.location

        markedNeighbors =
            List.foldr (+)
                0
                (List.map
                    (\loc ->
                        let
                            tile =
                                Matrix.get loc minefield
                        in
                            case tile of
                                Just tile ->
                                    case tile.state of
                                        Marked ->
                                            1

                                        _ ->
                                            0

                                Nothing ->
                                    0
                    )
                    neighbors
                )

        tileValue =
            case tile.tp of
                Number n ->
                    n

                Bomb ->
                    0
    in
        case markedNeighbors == tileValue of
            True ->
                openNeighbors minefield neighbors

            False ->
                ( minefield, False )


openNeighbors : Matrix Tile -> List Location -> ( Matrix Tile, Bool )
openNeighbors field neig =
    case neig of
        [] ->
            ( field, False )

        loc :: rest ->
            let
                tile =
                    Matrix.get loc field
            in
                case tile of
                    Just tile ->
                        case tile.state of
                            Closed ->
                                case tile.tp of
                                    Bomb ->
                                        ( Matrix.map (\tile -> { tile | state = Opened }) field, True )

                                    Number 0 ->
                                        let
                                            openTile =
                                                { tile | state = Opened }

                                            newField =
                                                Matrix.set tile.location openTile field
                                        in
                                            openNeighbors newField (List.append rest (getNeighbors tile.location))

                                    Number _ ->
                                        let
                                            openTile =
                                                { tile | state = Opened }

                                            newField =
                                                Matrix.set tile.location openTile field
                                        in
                                            openNeighbors newField rest

                            _ ->
                                openNeighbors field rest

                    Nothing ->
                        openNeighbors field rest


clearNeighbors : Matrix Tile -> List Location -> Matrix Tile
clearNeighbors field tiles =
    case tiles of
        [] ->
            field

        loc :: rest ->
            let
                tile =
                    Matrix.get loc field
            in
                case tile of
                    Nothing ->
                        clearNeighbors field rest

                    Just tile ->
                        case tile.state of
                            Closed ->
                                let
                                    openedTile =
                                        { tile | state = Opened }

                                    newField =
                                        Matrix.set loc openedTile field
                                in
                                    case tile.tp of
                                        Number 0 ->
                                            clearNeighbors newField (List.append rest (getNeighbors loc))

                                        _ ->
                                            clearNeighbors newField rest

                            _ ->
                                clearNeighbors field rest
