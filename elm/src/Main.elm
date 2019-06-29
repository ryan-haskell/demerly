module Main exposing (main)

import Application.Context as Context
import Application.Document as Document exposing (Document)
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Components
import Css exposing (..)
import Data.Content as Content exposing (Content)
import Data.Settings as Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, classList, css)
import Http
import Json.Decode as D
import Json.Encode as Json
import Page.ContactLanding
import Page.Homepage
import Page.NotFound
import Page.ProcessLanding
import Page.ProfileDetail
import Page.ProfileLanding
import Page.ProjectsDetail
import Page.ProjectsLanding
import Ports
import Process
import Route exposing (Route)
import Style
import Task
import Url exposing (Url)


type alias Model =
    { key : Nav.Key
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
    | ProjectsLanding Page.ProjectsLanding.Content Page.ProjectsLanding.Model
    | ProjectsDetail Page.ProjectsDetail.Content
    | ProcessLanding Page.ProcessLanding.Content
    | ProfileLanding Page.ProfileLanding.Content
    | ProfileDetail Page.ProfileDetail.Content
    | ContactLanding Page.ContactLanding.Content
    | NotFound
    | BadJson


type Msg
    = ContextSentMsg Context.Msg
    | UserClickedLink UrlRequest
    | BrowserChangedUrl Url
    | AppReceivedContent Url (Result Http.Error Content)
    | AppNavigatedTo Url (Result Http.Error Content)
    | SetTransition Transition
    | ProjectsLandingSentMsg Page.ProjectsLanding.Msg


main : Program Json.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = subscriptions
        , onUrlRequest = UserClickedLink
        , onUrlChange = BrowserChangedUrl
        }



-- INIT


init : Json.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init json url key =
    ( initModel json url key
    , Cmd.batch
        [ Browser.Dom.getViewport
            |> Task.perform
                (\{ viewport } ->
                    ContextSentMsg
                        (Context.SetViewport
                            (floor viewport.width)
                            (floor viewport.height)
                        )
                )
        , delay pageTransitionSpeed (SetTransition PageReady)
        , Ports.jumpToTop
        ]
    )


initModel : Json.Value -> Url -> Nav.Key -> Model
initModel json url key =
    let
        route =
            Route.fromUrl url
    in
    Model
        key
        Hidden
        (Context.init route)
        (case D.decodeValue Content.decoder json of
            Ok content ->
                initPage route content

            Err reason ->
                BadJson
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
            BadJson

        ( Route.ProjectsLanding, Content.ProjectsLanding settings page ) ->
            ProjectsLanding
                (Page.ProjectsLanding.Content settings page)
                Page.ProjectsLanding.init

        ( Route.ProjectsLanding, _ ) ->
            BadJson

        ( Route.ProjectsDetail _, Content.ProjectsDetail settings page ) ->
            ProjectsDetail
                (Page.ProjectsDetail.Content settings page)

        ( Route.ProjectsDetail _, _ ) ->
            BadJson

        ( Route.ProcessLanding, Content.OnlySettings settings ) ->
            ProcessLanding
                (Page.ProcessLanding.Content settings)

        ( Route.ProcessLanding, _ ) ->
            BadJson

        ( Route.ProfileLanding, Content.ProfileLanding settings page ) ->
            ProfileLanding
                (Page.ProfileLanding.Content settings page)

        ( Route.ProfileLanding, _ ) ->
            BadJson

        ( Route.ProfileDetail slug, Content.ProfileDetail settings page ) ->
            ProfileDetail
                (Page.ProfileDetail.Content
                    page
                    settings
                )

        ( Route.ProfileDetail _, _ ) ->
            BadJson

        ( Route.ContactLanding, Content.OnlySettings settings ) ->
            ContactLanding
                (Page.ContactLanding.Content settings)

        ( Route.ContactLanding, _ ) ->
            BadJson

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

        UserClickedLink link ->
            case link of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        BrowserChangedUrl url ->
            ( { model
                | transition = PageChanging
                , context =
                    model.context
                        |> Context.hideMenu
                        |> Context.setRoute (Route.fromUrl url)
              }
            , requestContentFor url
            )

        AppReceivedContent url result ->
            ( model
            , delay 300 (AppNavigatedTo url result)
            )

        AppNavigatedTo url result ->
            ( { model
                | transition = PageReady
                , page =
                    result
                        |> Result.map (initPage (Route.fromUrl url))
                        |> Result.withDefault NotFound
              }
            , Ports.jumpToTop
            )

        SetTransition transition ->
            ( { model | transition = transition }
            , Cmd.none
            )

        ProjectsLandingSentMsg msg_ ->
            ( case model.page of
                ProjectsLanding content model_ ->
                    { model
                        | page =
                            ProjectsLanding content
                                (Page.ProjectsLanding.update msg_ model_)
                    }

                _ ->
                    model
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
viewPage { page, context } =
    case page of
        ContactLanding content ->
            ( Page.ContactLanding.view
            , content.settings
            )

        Homepage content ->
            ( Page.Homepage.view context content
            , content.settings
            )

        NotFound ->
            ( Page.NotFound.view
            , Settings.fallback
            )

        ProcessLanding content ->
            ( Page.ProcessLanding.view
            , content.settings
            )

        ProfileDetail content ->
            ( Page.ProfileDetail.view content
            , content.settings
            )

        ProfileLanding content ->
            ( Page.ProfileLanding.view content
            , content.settings
            )

        ProjectsLanding content model ->
            ( Page.ProjectsLanding.view content model
                |> Document.map ProjectsLandingSentMsg
            , content.settings
            )

        ProjectsDetail content ->
            ( Page.ProjectsDetail.view content
            , content.settings
            )

        BadJson ->
            ( { title = "Oops | Demerly Architects"
              , body =
                    [ div
                        [ css Style.styles.container
                        , css [ padding2 zero Style.spacing.small ]
                        ]
                        [ h1 [] [ text "Oops!" ]
                        , p []
                            [ text "The content for this page didn't match up."
                            ]
                        , p []
                            [ text "Maybe a required field is missing on the backend?"
                            ]
                        ]
                    ]
              }
            , Settings.fallback
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onResize
        (\w h -> ContextSentMsg (Context.SetViewport w h))
