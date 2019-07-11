module Page.ProjectsLanding exposing (Content, Model, Msg, init, update, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.ProjectsLanding as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (alt, css, href, src)
import Html.Styled.Events as Events exposing (onClick)
import Set
import Style
import Json.Decode as D exposing (Decoder)

type alias Model =
    { typeFilter : Maybe String
    }


type Msg
    = UserClickedTypeButton (Maybe String)


type alias Content =
    { settings : Settings
    , page : Page.ProjectsLanding
    }



-- INIT


init : Model
init =
    Model Nothing



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserClickedTypeButton type_ ->
            { model | typeFilter = type_ }



-- VIEW


view : Content -> Model -> Document Msg
view { page } model =
    { title = "Projects | Demerly Architects"
    , body =
        [ main_
            [ css Style.styles.container
            , css
                [ padding2 zero Style.spacing.small
                , position relative
                ]
            ]
            [ h1 [] [ text page.title ]
            , p [ css Style.typography.paragraph, css [ maxWidth (ch 60) ] ]
                [ text page.description ]
            , div
                [ css
                    [ marginTop Style.spacing.small
                    , display none
                    , position absolute
                    , zIndex (int 2)
                    , right (rem 2)
                    , top (rem 1)
                    , Style.breakpoints.desktop [ displayFlex ]
                    , alignItems center
                    ]
                ]
                [ strong [] [ text page.filters.label ]
                , let
                    choices =
                        Option Nothing page.filters.allLabel :: getProjectTypes page.projects

                    viewOption choice =
                        option
                            [ Attr.value (choice.key |> Maybe.withDefault "") ]
                            [ text choice.label
                            ]
                  in
                  select
                    [ css
                        [ marginLeft (rem 1)
                        , border2 (px 1) solid
                        , padding2 (px 8) (px 24)
                        , textTransform uppercase
                        , backgroundColor Style.colors.white
                        , Css.property "-webkit-appearance" "none"
                        ]
                    , Events.on "change" changeDecoder
                    ]
                    (List.map viewOption choices)
                ]
            , grid (List.filter (shouldViewProject model.typeFilter) page.projects)
            ]
        ]
    }

changeDecoder : Decoder Msg
changeDecoder =
    D.field "target" (D.field "value" D.string)
    |> D.map (\value -> if String.isEmpty value then Nothing else Just value)
    |> D.map UserClickedTypeButton

shouldViewProject : Maybe String -> Page.ProjectLink -> Bool
shouldViewProject selectedType project =
    selectedType == Nothing || selectedType == getProjectType project


grid : List Page.ProjectLink -> Html msg
grid people =
    ul
        [ css (Style.listReset ++ Style.grid.context)
        ]
        (List.map gridChild people)


gridChild project =
    li [ css Style.grid.twoColumnList ]
        [ viewProject project ]


opaqueOverlayStyles =
    Style.overlayBase
        ++ [ Css.property "content" "''"
           , display block
           , backgroundColor Style.colors.overlayBlue
           ]


gradientOverlay =
    Style.overlayBase
        ++ [ Css.property "content" "''"
           , display block
           , top (pct 55)
           , backgroundImage (linearGradient2 toBottom (stop2 Style.colors.opaqueBlackZero <| pct 0) (stop <| Style.colors.opaqueBlack) [])
           ]


viewProject : Page.ProjectLink -> Html msg
viewProject project =
    a
        [ href project.url
        , css
            [ textDecoration none
            , display block
            , backgroundSize cover
            , backgroundRepeat noRepeat
            , backgroundPosition center
            , backgroundImage (url project.image)
            , width (pct 100)
            , paddingBottom (pct (Style.photoCardRatio * 100))
            , position relative
            , before opaqueOverlayStyles
            , after gradientOverlay
            ]
        ]
        [ span
            [ css Style.typography.highlightTitle
            , css
                [ position absolute
                , left Style.spacing.small
                , bottom Style.spacing.small
                , color Style.colors.white
                , zIndex (int 2)
                ]
            ]
            [ text (project.name ++ " - " ++ Maybe.withDefault "" (getProjectType project))
            ]
        ]


type alias Option =
    { key : Maybe String
    , label : String
    }


getProjectTypes : List Page.ProjectLink -> List Option
getProjectTypes =
    List.filterMap getProjectType
        >> Set.fromList
        >> Set.toList
        >> List.map (\key -> Option (Just key) key)


getProjectType : Page.ProjectLink -> Maybe String
getProjectType link =
    link.url
        |> String.split "/"
        |> List.drop 2
        |> List.head
