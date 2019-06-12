module Application.Context exposing
    ( Model
    , Msg(..)
    , init
    , update
    )


type alias Model =
    { isMenuOpen : Bool
    }


type Msg
    = ToggleMenu


init : Model
init =
    Model False


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleMenu ->
            { model | isMenuOpen = not model.isMenuOpen }
