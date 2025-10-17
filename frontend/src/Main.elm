module Main exposing (main)

import Browser
import Html exposing (Html, button, div, figcaption, figure, img, text)
import Html.Attributes exposing (alt, src, style)
import Html.Events exposing (onClick)


-- MODEL

type alias Image =
    { url : String
    , title : String
    , idTag : String
    , allowedUserTags : List String
    }

type User
    = JanInge
    | Sindre
    | Ghost
    | None


type alias Model =
    { user : User }


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


-- APP

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


-- VIEW

view : Model -> Html Msg
view model =
    let
        ( bgColor, currentTag, titleText ) =
            case model.user of
                JanInge ->
                    ( "#ffdddd", "001", "Innlogget som Jan Inge" )

                Sindre ->
                    ( "#dde6ff", "002", "Innlogget som Sindre" )

                Ghost ->
                    ( "#e0e0e0", "003", "Innlogget som Ghost" )

                None ->
                    ( "white", "--", "Ikke innlogget" )

        visible =
            visibleImages model.user images
    in
    div
        [ style "font-family" "system-ui, sans-serif"
        , style "background" bgColor
        , style "min-height" "100vh"
        , style "padding" "2rem"
        , style "transition" "background 0.3s ease"
        ]
        [ div [ style "text-align" "center", style "margin-bottom" "0.75rem", style "font-weight" "600" ]
            [ text (titleText ++ "  |  Tag: " ++ currentTag) ]
        , viewLoginButtons model.user
        , if List.isEmpty visible then
            div
                [ style "max-width" "1200px"
                , style "margin" "0 auto"
                , style "text-align" "center"
                , style "color" "#6b7280"
                , style "padding" "1rem 0 2rem"
                ]
                [ text "Ingen bilder tilgjengelig." ]
          else
            viewGrid visible
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
    div [ style "text-align" "center", style "margin-bottom" "1.5rem" ]
        (case currentUser of
            None ->
                [ btn JanInge "Logg inn som Jan Inge (001)" "#e74c3c"
                , btn Sindre "Logg inn som Sindre (002)" "#3498db"
                , btn Ghost "Logg inn som Ghost (003)" "#7f8c8d"
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


-- GRID

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
            [ text (imgData.title ++ " | " ++ imgData.idTag) ]
        ]


-- DATA + ACL

images : List Image
images =
    [ { url = "bilde1.webp", title = "Bilde 1", idTag = "IMG-A12B3", allowedUserTags = [ "001" ] }
    , { url = "bilde2.jpg", title = "Bilde 2", idTag = "IMG-C91D4", allowedUserTags = [ "001" ] }
    , { url = "bilde3.png", title = "Bilde 3", idTag = "IMG-Z73F2", allowedUserTags = [ "002" ] }
    , { url = "bilde4.jpg", title = "Bilde 5", idTag = "IMG-P84R1", allowedUserTags = [ "002" ] }
    , { url = "bilde5.jpg", title = "Bilde 4", idTag = "IMG-T56K9", allowedUserTags = [ "003" ] }
    , { url = "default1.jpg", title = "Standard bilde 1", idTag = "IMG-Q47N8", allowedUserTags = [ ] }
    , { url = "default2.jpg", title = "Standard bilde 2", idTag = "IMG-R52K1", allowedUserTags = [ ] }
    ]


visibleImages : User -> List Image -> List Image
visibleImages user imgs =
    case userTag user of
        Nothing ->
            -- Ikke innlogget: vis kun offentlige bilder
            List.filter (\i -> List.isEmpty (i.allowedUserTags)) imgs

        Just tag ->
            -- Innlogget: vis offentlige + brukers egne
            List.filter
                (\i ->
                    List.isEmpty i.allowedUserTags
                        || List.member tag i.allowedUserTags
                )
                imgs

userTag : User -> Maybe String
userTag u =
    case u of
        JanInge ->
            Just "001"

        Sindre ->
            Just "002"

        Ghost ->
            Just "003"

        None ->
            Nothing
