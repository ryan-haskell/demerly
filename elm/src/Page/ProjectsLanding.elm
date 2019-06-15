module Page.ProjectsLanding exposing (Content, Model, Msg, init, update, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Style


type alias Model =
    { typeFilter : Maybe String
    }


type Msg
    = SetTypeFilter String
    | ResetTypeFilter


type alias Content =
    { settings : Settings
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
            { model | typeFilter = Just type_ }

        ResetTypeFilter ->
            { model | typeFilter = Nothing }



-- VIEW


view : Content -> Model -> Document Msg
view content model =
    { title = "Projects | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text "Projects Landing" ]
            , div [ css [ marginTop Style.spacing.small ] ]
                [ strong [] [ text "Selected: " ]
                , text (model.typeFilter |> Maybe.withDefault "Nothing selected...")
                , div
                    [ css
                        [ marginTop Style.spacing.tiny
                        ]
                    ]
                    (List.map (viewTypeFilterButton model.typeFilter)
                        [ "Residential"
                        , "Renovation"
                        , "Commercial"
                        ]
                    )
                ]
            ]
        ]
    }


viewTypeFilterButton : Maybe String -> String -> Html Msg
viewTypeFilterButton typeFilter label_ =
    button
        [ css
            [ marginRight Style.spacing.tiny
            , border2 (px 1) solid
            , padding2 (px 8) (px 16)
            ]
        , css
            (if typeFilter == Just label_ then
                [ color (rgb 97 81 111)
                , borderColor (rgb 97 81 111)
                ]

             else
                []
            )
        , onClick (SetTypeFilter label_)
        ]
        [ text label_ ]
