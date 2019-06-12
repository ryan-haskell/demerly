module Main exposing (main)

import Application.Context as Context
import Browser
import Browser.Navigation as Nav
import Css exposing (..)
import Css.Global as Global
import Html exposing (Html)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Json.Encode as Json
import Page.ProfileDetail
import Style
import Url exposing (Url)


type alias Model =
    { context : Context.Model
    , page : Page
    }


type Page
    = ProfileDetail Page.ProfileDetail.Content Page.ProfileDetail.Model
    | NotFound


type Msg
    = ContextSentMsg Context.Msg
    | PageSentMsg PageMsg
    | UserClickedLink Browser.UrlRequest
    | AppRequestedUrl Url


type PageMsg
    = ProfileDetailPageSentMsg Page.ProfileDetail.Msg


type alias Flags =
    Json.Value


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        , onUrlRequest = UserClickedLink
        , onUrlChange = AppRequestedUrl
        }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model (ProfileDetail Page.ProfileDetail.init)
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ProfileDetailMsg msg_, ProfileDetail model_ ) ->
            ( { model | page = ProfileDetail (Page.ProfileDetail.update msg_ model_) }
            , Cmd.none
            )

        ( ProfileDetailMsg _, _ ) ->
            ( model, Cmd.none )


content =
    { profileDetail =
        Page.ProfileDetail.Content
            { photo = Just "/images/photo-mark2.jpg"
            , name = "Mark Demerly"
            , email = Just "mark@demerlyarchitects.com"
            , credentials = Just "AIA, NCARB, LEED-AP"
            , position = Just "President"
            , phone = Just "317.847.0724"
            , fax = Just "888.895.2811"
            , bio = """
Heading up his own firm allows Mark to focus on what he values most: designing homes for people to enjoy. His professional, civic and community interests are fueled by his passion for making Indianapolis communities better places to live. As the Midtown Economic Council representative, he advocates for responsible growth and more public amenities in Midtown Indianapolis development. He launched the Broad Ripple Winter Market to support sustainability and enable local producers and growers to expand their businesses. In short order, the market became a prized amenity for northside residents. Mark has served as the president for IMA Design Arts and Contemporary Arts support groups, and is a past president and founding member of the national AIA Custom Residential Architect Network committee, which has advocated for and increased awareness of the residential architecture profession. He serves on Broad Ripple’s Land Use and Development Committee and participates in numerous other community initiatives. Mark’s devotion to cooking and food has helped inspire his designs for the restaurants the firm has developed for the city’s top chefs. His love of nature, hiking and the outdoors has led to community gardens and memorials to those who have contributed much.

Mark has Bachelor of Science in X and Bachelor of Science in Architecture degrees from Ball State University. 
"""
            }
            { header =
                { brand = "Demerly Architects"
                , logos =
                    { mobile = "/images/logo-mobile.svg"
                    , desktop = "/images/logo-desktop.svg"
                    }
                , linkLabels =
                    { projects = "Projects"
                    , process = "Process"
                    , profile = "Profile"
                    , contact = "Contact"
                    }
                }
            , footer =
                { address = "6500 Westfield Boulevard   /   Indianapolis, IN 46220"
                , phone = "317.847.0724"
                , fax = "888.895.2811"
                }
            }
    }


view : Model -> Html.Html Msg
view model =
    Html.Styled.toUnstyled <|
        div []
            [ Global.global Style.globals
            , case model.page of
                ProfileDetail model_ ->
                    Html.Styled.map ProfileDetailMsg
                        (Page.ProfileDetail.view content.profileDetail model_)

                NotFoundModel ->
                    div
                        [ css Style.typography.title
                        ]
                        [ text "Page not found." ]
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
