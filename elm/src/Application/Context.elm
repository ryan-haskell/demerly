module Application.Context exposing
    ( Model
    , Msg(..)
    , hideMenu
    , init
    , setRoute
    , update
    )

import Route exposing (Route)


type alias Model =
    { isMenuOpen : Bool
    , route : Route
    }


type Msg
    = ToggleMenu


init : Route -> Model
init route =
    Model False route


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleMenu ->
            { model | isMenuOpen = not model.isMenuOpen }


hideMenu : Model -> Model
hideMenu model =
    { model | isMenuOpen = False }


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }
