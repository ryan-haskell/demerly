module Page.ProjectsLanding exposing (Content, Model, Msg, init, update, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.ProjectsLanding as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Html.Styled.Events exposing (onClick)
import Set
import Style


type alias Model =
    { typeFilter : Maybe String
    }


type Msg
    = SetTypeFilter (Maybe String)


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
        SetTypeFilter type_ ->
            { model | typeFilter = type_ }



-- VIEW


view : Content -> Model -> Document Msg
view { page } model =
    { title = "Projects | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text page.title ]
            , p [ css Style.typography.paragraph, css [ maxWidth (ch 60) ] ] [ text page.description ]
            , div [ css [ marginTop Style.spacing.small ] ]
                [ strong [] [ text page.filters.label ]
                , div
                    [ css
                        [ marginTop Style.spacing.tiny
                        ]
                    ]
                    (List.map (viewTypeFilterButton model.typeFilter)
                        (Option Nothing page.filters.allLabel
                            :: getProjectTypes page.projects
                        )
                    )
                ]
            , grid (List.filter (shouldViewProject model.typeFilter) page.projects)
            ]
        ]
    }


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


viewProject : Page.ProjectLink -> Html msg
viewProject project =
    a
        [ href project.url
        , css
            [ textDecoration none
            , display block
            , backgroundSize cover
            , backgroundPosition2 (pct 100) zero
            , backgroundImage (url project.image)
            , width (pct 100)
            , paddingBottom (pct 50)
            , position relative
            ]
        ]
        [ span
            [ css Style.typography.highlightTitle
            , css
                [ position absolute
                , left Style.spacing.small
                , bottom Style.spacing.small
                , color Style.colors.white
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


viewTypeFilterButton : Maybe String -> Option -> Html Msg
viewTypeFilterButton typeFilter { key, label } =
    button
        [ css
            [ marginRight Style.spacing.tiny
            , marginBottom Style.spacing.tiny
            , border2 (px 1) solid
            , padding2 (px 8) (px 16)
            , textTransform uppercase
            ]
        , css
            (if typeFilter == key then
                [ color (rgb 97 81 111)
                , borderColor (rgb 97 81 111)
                ]

             else
                []
            )
        , onClick (SetTypeFilter key)
        ]
        [ text label ]
