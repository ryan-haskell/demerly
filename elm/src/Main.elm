module Main exposing (main)

import Browser
import Html exposing (..)
import Markdown


type alias Flags =
    { person : Person
    , settings : Settings
    }


type alias Settings =
    { header : Header
    , footer : Footer
    }


type alias Header =
    { brand : String
    , logos : { mobile : String, desktop : String }
    , linkLabels : LinkLabels
    }


type alias LinkLabels =
    { projects : String
    , process : String
    , profile : String
    , contact : String
    }


type alias Footer =
    { address : String
    , phone : String
    , fax : String
    }


type alias Person =
    { bio : String
    , fullname : Maybe String
    , email : Maybe String
    , phone : Maybe String
    , fax : Maybe String
    }


type alias Model =
    { person : Person
    , settings : Settings
    }


type Msg
    = NoOp


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        flags.person
        flags.settings
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Markdown.toHtml [] model.person.bio


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
