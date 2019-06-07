module Page.PeopleDetail exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick)


type alias Model =
    { name : String
    , email : Maybe String
    }


init : Model
init =
    { name = "Mark Demerly"
    , email = Just "mdemerly@demerly.com"
    }


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    text model.name
