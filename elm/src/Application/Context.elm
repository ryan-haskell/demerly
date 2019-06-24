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
    , viewport : Viewport
    }


type alias Viewport =
    { width : Int
    , height : Int
    }


type Msg
    = ToggleMenu
    | SetViewport Int Int


init : Route -> Model
init route =
    Model
        False
        route
        (Viewport 1920 1080)


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleMenu ->
            { model | isMenuOpen = not model.isMenuOpen }

        SetViewport width height ->
            { model | viewport = Viewport width height }


hideMenu : Model -> Model
hideMenu model =
    { model | isMenuOpen = False }


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }
