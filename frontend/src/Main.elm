module Main exposing (main)

import Browser
import Html exposing (Html, button, div, figcaption, figure, img, text)
import Html.Attributes exposing (alt, src, style)
import Html.Events exposing (onClick)


-- MODEL

type alias Image =
    { url : String
    , title : String
    }

type User
    = JanInge
    | Sindre
    | Ghost
    | None


type alias Model =
    { user : User
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { user = None }, Cmd.none )


-- MESSAGES

type Msg
    = LoginAs User
    | Logout


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginAs user ->
            ( { model | user = user }, Cmd.none )

        Logout ->
            ( { model | user = None }, Cmd.none )


-- VIEW

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html Msg
view model =
    let
        bgColor =
            case model.user of
                JanInge ->
                    "#ffdddd" -- rød bakgrunn

                Sindre ->
                    "#dde6ff" -- blå bakgrunn

                Ghost ->
                    "#e0e0e0" -- grå bakgrunn

                None ->
                    "white"

        titleText =
            case model.user of
                JanInge ->
                    "Innlogget som Jan Inge"

                Sindre ->
                    "Innlogget som Sindre"

                Ghost ->
                    "Innlogget som Ghost"

                None ->
                    "Ikke innlogget"
    in
    div
        [ style "font-family" "system-ui, sans-serif"
        , style "background" bgColor
        , style "min-height" "100vh"
        , style "padding" "2rem"
        , style "transition" "background 0.3s ease"
        ]
        [ div [ style "text-align" "center", style "margin-bottom" "1rem" ]
            [ text titleText
            ]
        , viewLoginButtons model.user
        , viewGrid images
        ]


viewLoginButtons : User -> Html Msg
viewLoginButtons currentUser =
    let
        btn user label color =
            button
                [ onClick (LoginAs user)
                , style "margin" "0 8px"
                , style "padding" "8px 16px"
                , style "border" "none"
                , style "border-radius" "6px"
                , style "cursor" "pointer"
                , style "background" color
                , style "color" "white"
                , style "font-weight" "600"
                ]
                [ text label ]
    in
    div [ style "text-align" "center", style "margin-bottom" "2rem" ]
        (case currentUser of
            None ->
                [ btn JanInge "Logg inn som Jan Inge" "#e74c3c"
                , btn Sindre "Logg inn som Sindre" "#3498db"
                , btn Ghost "Logg inn som Ghost" "#7f8c8d"
                ]

            _ ->
                [ button
                    [ onClick Logout
                    , style "padding" "8px 16px"
                    , style "border" "none"
                    , style "border-radius" "6px"
                    , style "cursor" "pointer"
                    , style "background" "#555"
                    , style "color" "white"
                    , style "font-weight" "600"
                    ]
                    [ text "Logg ut" ]
                ]
        )


-- GRID VIEW

images : List Image
images =
    [ { url = "bilde1.webp", title = "Bilde 1" }
    , { url = "bilde2.jpg", title = "Bilde 2" }
    , { url = "bilde3.png", title = "Bilde 3" }
    , { url = "bilde1.webp", title = "Bilde 4" }
    , { url = "bilde2.jpg", title = "Bilde 5" }
    ]


viewGrid : List Image -> Html Msg
viewGrid items =
    div
        [ style "max-width" "1200px"
        , style "margin" "0 auto"
        , style "display" "grid"
        , style "grid-template-columns" "repeat(auto-fill, minmax(220px, 1fr))"
        , style "gap" "16px"
        ]
        (List.map viewCard items)


viewCard : Image -> Html Msg
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