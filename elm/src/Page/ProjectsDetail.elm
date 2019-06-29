module Page.ProjectsDetail exposing
    ( Content
    , Model
    , Msg
    , init
    , update
    , view
    )

import Application.Document exposing (Document)
import Css exposing (..)
import Data.ProjectsDetail as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, css, src)
import Html.Styled.Events exposing (onClick)
import Style


type alias Content =
    { settings : Settings
    , page : Page.ProjectsDetail
    }


type alias Model =
    { isTextExpanded : Bool
    , currentImage : Int
    }



-- INIT


init : Model
init =
    Model False 0



-- UPDATE


type Msg
    = ToggleTextSection
    | NextImage
    | PreviousImage


update : Content -> Msg -> Model -> Model
update { page } msg model =
    let
        updateCurrentImage fn =
            model.currentImage
                |> (\num -> fn num 1)
                |> modBy (List.length page.images)
    in
    case msg of
        ToggleTextSection ->
            { model | isTextExpanded = not model.isTextExpanded }

        NextImage ->
            { model | currentImage = updateCurrentImage (+) }

        PreviousImage ->
            { model | currentImage = updateCurrentImage (-) }



-- VIEW


view : Content -> Model -> Document Msg
view { page } model =
    { title = "Some Project | Projects | Demerly Architects"
    , body =
        [ div []
            -- Demo of update
            [ button [ css [ border3 (px 1) solid Style.colors.dark, padding (rem 1) ], onClick PreviousImage ] [ text "Previous" ]
            , span [] [ text (String.fromInt model.currentImage) ]
            , button [ css [ border3 (px 1) solid Style.colors.dark, padding (rem 1) ], onClick NextImage ] [ text "Next" ]
            , span []
                [ text
                    (if model.isTextExpanded then
                        "Expanded"

                     else
                        "Collapsed"
                    )
                ]
            , button [ css [ border3 (px 1) solid Style.colors.dark, padding (rem 1) ], onClick ToggleTextSection ] [ text "Toggle Text" ]
            ]
        , div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text page.title ]
            , p []
                [ text page.year
                , text " – "
                , text page.type_
                , text ", "
                , text page.location
                ]
            , div []
                (List.map (\url -> img [ src url, alt page.title ] [])
                    page.images
                )
            ]
        ]
    }
