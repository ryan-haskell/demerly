module Main exposing (main)

import Application.Context as Context
import Application.Document as Document exposing (Document)
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Components
import Data.Content as Content exposing (Content)
import Data.Settings as Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, classList, css)
import Http
import Json.Decode as D
import Json.Encode as Json
import Page.Homepage
import Page.ProfileDetail
import Process
import Route exposing (Route)
import Style
import Task
import Url exposing (Url)


type alias Model =
    { key : Nav.Key
    , url : Url
    , transition : Transition
    , context : Context.Model
    , page : Page
    }


type Transition
    = Hidden
    | PageChanging
    | PageReady


pageTransitionSpeed : Float
pageTransitionSpeed =
    300


isLayoutVisible : Transition -> Bool
isLayoutVisible t =
    t /= Hidden


isPageVisible : Transition -> Bool
isPageVisible t =
    t == PageReady


type Page
    = Homepage Page.Homepage.Content
    | ProfileDetail Page.ProfileDetail.Content
    | NotFound
    | BadJson String


type Msg
    = ContextSentMsg Context.Msg
    | AppRequestedUrl UrlRequest
    | AppChangedUrl Url
    | AppReceivedContent Url (Result Http.Error Content)
    | AppNavigatedTo Url (Result Http.Error Content)
    | SetTransition Transition


main : Program Json.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = always Sub.none
        , onUrlRequest = AppRequestedUrl
        , onUrlChange = AppChangedUrl
        }



-- INIT


init : Json.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init json url key =
    ( initModel json url key
    , delay pageTransitionSpeed (SetTransition PageReady)
    )


initModel : Json.Value -> Url -> Nav.Key -> Model
initModel json url key =
    Model
        key
        url
        Hidden
        Context.init
        (case D.decodeValue Content.decoder json of
            Ok content ->
                initPage (Route.fromUrl url) content

            Err reason ->
                BadJson (D.errorToString reason)
        )


initPage : Route -> Content -> Page
initPage route content =
    case ( route, content ) of
        ( Route.Homepage, Content.Homepage settings page ) ->
            Homepage
                (Page.Homepage.Content
                    page
                    settings
                )

        ( Route.Homepage, _ ) ->
            NotFound

        ( Route.ProfileDetail slug, Content.ProfileDetail settings page ) ->
            ProfileDetail
                (Page.ProfileDetail.Content
                    page
                    settings
                )

        ( Route.ProfileDetail _, _ ) ->
            NotFound

        ( Route.NotFound, _ ) ->
            NotFound



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContextSentMsg msg_ ->
            ( { model | context = Context.update msg_ model.context }
            , Cmd.none
            )

        AppRequestedUrl request ->
            case request of
                Internal url ->
                    ( { model
                        | transition = PageChanging
                        , context = Context.hideMenu model.context
                      }
                    , requestContentFor url
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        AppReceivedContent url result ->
            ( model
            , delay 300 (AppNavigatedTo url result)
            )

        AppNavigatedTo url result ->
            ( { model
                | page =
                    result
                        |> Result.map (initPage (Route.fromUrl url))
                        |> Result.withDefault NotFound
              }
            , Nav.pushUrl model.key (Url.toString url)
            )

        AppChangedUrl url ->
            ( { model
                | transition = PageReady
                , url = url
              }
            , Cmd.none
            )

        SetTransition transition ->
            ( { model | transition = transition }
            , Cmd.none
            )


delay : Float -> msg -> Cmd msg
delay ms msg =
    Process.sleep ms
        |> Task.perform (always msg)


requestContentFor : Url -> Cmd Msg
requestContentFor url =
    Http.get
        { url = apiEndpointFor url.path
        , expect = Http.expectJson (AppReceivedContent url) Content.decoder
        }


apiEndpointFor : String -> String
apiEndpointFor url =
    if String.endsWith "/" url then
        url ++ "index.json"

    else
        url ++ "/index.json"



-- VIEW


toUnstyled { title, body } =
    { title = title
    , body = List.map Html.Styled.toUnstyled body
    }


view : Model -> Document Msg
view model =
    let
        ( page, settings ) =
            viewPage model
    in
    { title = page.title
    , body =
        [ Style.globals
        , div
            [ class "layout"
            , classList
                [ ( "layout--visible"
                  , isLayoutVisible model.transition
                  )
                ]
            ]
            [ Html.Styled.map ContextSentMsg
                (Components.navbar
                    settings
                    Context.ToggleMenu
                    model.context
                )
            , Components.mainMenu
                settings
                model.context
            , div
                [ class "page"
                , classList
                    [ ( "page--visible"
                      , isPageVisible model.transition
                      )
                    ]
                ]
                page.body
            , Components.siteFooter settings
            ]
        ]
    }


viewPage : Model -> ( Document Msg, Settings )
viewPage { page } =
    case page of
        Homepage content ->
            ( Page.Homepage.view content
            , content.settings
            )

        ProfileDetail content ->
            ( Page.ProfileDetail.view content
            , content.settings
            )

        NotFound ->
            ( { title = "Not Found | Demerly Architects"
              , body = [ h1 [] [ text "Page not found." ] ]
              }
            , Settings.fallback
            )

        BadJson reason ->
            ( { title = "Uh oh | Demerly Architects"
              , body = [ text reason ]
              }
            , Settings.fallback
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
