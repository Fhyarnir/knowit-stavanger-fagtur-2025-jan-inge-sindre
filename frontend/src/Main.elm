module Main exposing (main)

import Html exposing (Html, div, img)
import Html.Attributes exposing (alt, src, style)

main : Html msg
main =
    div []
        [ img
            [ src "bilde1.webp"
            , alt "App logo"
            , style "width" "150px"
            ]
            []
        ]