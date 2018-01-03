module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, src)
import Navigation exposing (Location)


---- MODEL ----


type Route
    = PageA
    | PageB
    | NotFoundPage


type alias Model =
    { currentRoute : Route
    }


init : Location -> ( Model, Cmd Msg )
init location =
    ( location
        |> locationToRoute
        |> initialModel
    , Cmd.none
    )


initialModel : Route -> Model
initialModel route =
    { currentRoute = route
    }



---- ROUTING ----


updateLocation : Location -> Msg
updateLocation =
    Debug.log "Location: " >> LoadPage


locationToRoute : Location -> Route
locationToRoute { hash } =
    case hash of
        "" ->
            PageA

        "#pageA" ->
            PageA

        "#pageB" ->
            PageB

        _ ->
            NotFoundPage



---- UPDATE ----


type Msg
    = LoadPage Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPage location ->
            { model | currentRoute = locationToRoute location } ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewPage model.currentRoute
        ]


viewPage : Route -> Html Msg
viewPage route =
    case route of
        PageA ->
            viewPageA

        PageB ->
            viewPageB

        NotFoundPage ->
            viewNotFoundPage


viewPageA : Html Msg
viewPageA =
    div []
        [ h1 []
            [ text "Hello from Page A" ]
        , a
            [ href "#pageB" ]
            [ text "Switch to Page B" ]
        ]


viewPageB : Html Msg
viewPageB =
    div []
        [ h1 [] [ text "Hello from Page B" ]
        , a
            [ href "#pageA" ]
            [ text "Switch to Page A" ]
        ]


viewNotFoundPage : Html Msg
viewNotFoundPage =
    h1 [] [ text "Not found :-/" ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program
        updateLocation
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
