module Main exposing (main)

import Browser
import Html exposing (Html, div, figcaption, figure, img, text)
import Html.Attributes exposing (alt, src, style)


-- DATA

type alias Image =
    { url : String
    , title : String
    }

images : List Image
images =
    -- Bruk relative stier (filer i dist/) eller absolute URLs (f.eks. fra backend)
    [ { url = "bilde1.webp", title = "Bilde 1" }
    , { url = "bilde2.jpg", title = "Bilde 2" }
    , { url = "bilde3.png", title = "Bilde 3" }
    , { url = "bilde1.webp", title = "Bilde 4" }
    , { url = "bilde2.jpg", title = "Bilde 5" }
    ]


-- APP

main : Program () () msg
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = \_ -> viewGrid images
        }


-- VIEW

viewGrid : List Image -> Html msg
viewGrid items =
    div
        [ style "font-family" "system-ui, sans-serif"
        , style "max-width" "1200px"
        , style "margin" "2rem auto"
        , style "padding" "0 1rem"
        ]
        [ div
            [ style "display" "grid"
            , style "grid-template-columns" "repeat(auto-fill, minmax(220px, 1fr))"
            , style "gap" "16px"
            , style "align-items" "start"
            ]
            (List.map viewCard items)
        ]


viewCard : Image -> Html msg
viewCard imgData =
    figure
        [ style "border" "1px solid #e5e7eb"
        , style "border-radius" "12px"
        , style "padding" "8px"
        , style "box-shadow" "0 1px 2px rgba(0,0,0,.08)"
        , style "background" "white"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ img
            [ src imgData.url
            , alt imgData.title
            , style "max-width" "100%"
            , style "height" "auto"
            , style "border-radius" "8px"
            , style "display" "block"
            ]
            []
        , figcaption
            [ style "margin-top" "8px"
            , style "font-size" ".9rem"
            , style "color" "#374151"
            , style "text-align" "center"
            ]
            [ text imgData.title ]
        ]