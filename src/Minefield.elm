module Minefield exposing (..)

import Matrix exposing (..)
import Tile exposing (..)
import Random.Pcg exposing (..)
import Msgs exposing (..)
import Html exposing (..)
import Style exposing (..)


type alias Minefield =
    Matrix Tile


getRandomPositions : Int -> Int -> Int -> Seed -> List Location -> ( List Location, Seed )
getRandomPositions width height bombs seed positions =
    if List.length positions == bombs then
        Debug.log "meme" ( positions, seed )
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
                    if List.member (Debug.log "location" location) positions then
                        Tile Bomb 9 False
                    else
                        Tile Number (List.foldr (+) 0 (List.map (\x -> x positions) (List.map isMine (getNeighbors location)))) False
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
                                td [ Style.tile ] [ b [] [ p [ Style.number column.value ] [ text (toString (column.value)) ] ] ]
                            )
                            row
                        )
                )
                (Matrix.toList minefield)
            )
        ]
