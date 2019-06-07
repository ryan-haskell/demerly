module Main exposing (main)

import Browser
import Css exposing (..)
import Html exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Page.PeopleDetail



-- import Markdown
-- type alias Flags =
--     { person : Person
--     , settings : Settings
--     }
-- type alias Settings =
--     { header : Header
--     , footer : Footer
--     }
-- type alias Header =
--     { brand : String
--     , logos : { mobile : String, desktop : String }
--     , linkLabels : LinkLabels
--     }
-- type alias LinkLabels =
--     { projects : String
--     , process : String
--     , profile : String
--     , contact : String
--     }
-- type alias Footer =
--     { address : String
--     , phone : String
--     , fax : String
--     }
-- type alias Person =
--     { bio : String
--     , fullname : Maybe String
--     , email : Maybe String
--     , phone : Maybe String
--     , fax : Maybe String
--     }


type alias Model =
    { page : Page
    }


type Page
    = PeopleDetailModel Page.PeopleDetail.Model
    | NotFoundModel


type Msg
    = PeopleDetailMsg Page.PeopleDetail.Msg


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model (PeopleDetailModel Page.PeopleDetail.init)
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( PeopleDetailMsg msg_, PeopleDetailModel model_ ) ->
            ( { model | page = PeopleDetailModel (Page.PeopleDetail.update msg_ model_) }
            , Cmd.none
            )

        ( PeopleDetailMsg _, _ ) ->
            ( model, Cmd.none )


spacing =
    { big = rem 2
    }


view : Model -> Html.Html Msg
view model =
    Html.Styled.toUnstyled <|
        case model.page of
            PeopleDetailModel model_ ->
                Html.Styled.map PeopleDetailMsg
                    (Page.PeopleDetail.view model_)

            NotFoundModel ->
                div
                    [ css
                        [ fontSize spacing.big
                        , color (rgb 255 100 100)
                        , margin2 (px 100) (rem 5)
                        ]
                    ]
                    [ text "Page not found." ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
