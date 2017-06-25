module Minefield exposing (..)

import Matrix exposing (..)
import Tile exposing (..)
import Random.Pcg exposing (..)
import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)
import Html.Attributes exposing (src, href)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json


type alias Minefield =
    Matrix Tile


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
                        Tile Bomb 9 False location False
                    else
                        Tile Number (List.foldr (+) 0 (List.map (\x -> x positions) (List.map isMine (getNeighbors location)))) False location False
                )
    in
        ( matrix, seed )


isMine : Location -> List Location -> Int
isMine ( x, y ) positions =
    if List.member ( x, y ) positions then
        1
    else
        0


getNeighbors : Location -> List Location
getNeighbors ( x, y ) =
    [ ( x - 1, y + 1 ), ( x, y + 1 ), ( x + 1, y + 1 ), ( x - 1, y ), ( x + 1, y ), ( x - 1, y - 1 ), ( x, y - 1 ), ( x + 1, y - 1 ) ]


getHTMLMinefield : Minefield -> Html Msg
getHTMLMinefield minefield =
    div [ Style.minefield ]
        [ table []
            (List.map
                (\row ->
                    tr []
                        (List.map
                            (\column ->
                                td [ (Style.tile column), onClick (Msgs.OpenTile column), onRightClick (Msgs.MarkTile column) ] (getColumnTile column)
                            )
                            row
                        )
                )
                (Matrix.toList minefield)
            )
        ]


getItem : Int -> Html Msg
getItem n =
    case n of
        9 ->
            img [ Style.bombImage, src "src/resources/bomb.png" ] []

        0 ->
            text ""

        _ ->
            text (toString (n))


getColumnTile : Tile -> List (Html Msg)
getColumnTile tile =
    case tile.opened of
        True ->
            [ b [] [ p [ Style.number tile.value ] [ getItem tile.value ] ] ]

        False ->
            case tile.marked of
                True ->
                    [ b [] [ p [ Style.tileImage ] [ img [ Style.flagImage, src "src/resources/flag.png" ] [] ] ] ]

                False ->
                    []


checkAndOpenNeighbors : Minefield -> Tile -> ( Minefield, Bool )
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
                                    if tile.marked then
                                        1
                                    else
                                        0

                                Nothing ->
                                    0
                    )
                    neighbors
                )
    in
        case markedNeighbors == tile.value of
            True ->
                openNeighbors minefield neighbors

            False ->
                ( minefield, False )


openNeighbors : Minefield -> List Location -> ( Minefield, Bool )
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
                        case tile.marked of
                            True ->
                                openNeighbors field rest

                            False ->
                                case tile.tp of
                                    Bomb ->
                                        ( Matrix.map (\tile -> { tile | opened = True }) field, True )

                                    _ ->
                                        let
                                            openTile =
                                                { tile | opened = True, marked = False }

                                            newField =
                                                Matrix.set tile.location openTile field
                                        in
                                            openNeighbors newField rest

                    Nothing ->
                        ( field, False )


clearNeighbors : Minefield -> List Location -> Minefield
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
                        case tile.opened || tile.marked of
                            True ->
                                clearNeighbors field rest

                            False ->
                                let
                                    openedTile =
                                        { tile | opened = True, marked = False }

                                    newField =
                                        Matrix.set loc openedTile field
                                in
                                    case tile.value of
                                        0 ->
                                            clearNeighbors newField (List.append rest (getNeighbors loc))

                                        _ ->
                                            clearNeighbors newField rest
