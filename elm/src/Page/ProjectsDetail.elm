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
        [ main_
            [ css Style.styles.container ]
            -- Demo of update
            [ div
                [ css
                    [ height Style.sizes.pageHeightMobile
                    , position relative
                    ]
                ]
                [ toggleTrigger page.title
                , div
                    [ css
                        [ width (pct 100)
                        , height (pct 100)
                        ]
                    ]
                    (List.map slideImage page.images)
                , arrowsControl page.images
                ]
            ]
        ]
    }


slideImage photo =
    div
        [ css
            [ backgroundImage (url photo)
            , backgroundSize cover
            , width (pct 100)
            , height (pct 100)
            ]
        ]
        []


toggleTrigger label =
    div
        [ css
            [ position absolute
            , bottom zero
            , left zero
            , right zero
            , paddingRight (px 150)
            , height (px 90)
            , backgroundColor Style.colors.grey
            ]
        ]
        [ button
            [ css
                [ padding (rem 1)
                , width (pct 100)
                , height (pct 100)
                , displayFlex
                , alignItems center
                ]
            , onClick ToggleTextSection
            ]
            [ span
                [ css
                    (Style.typography.toggleOverlayTitle
                        ++ [ color Style.colors.dark
                           , order (int 2)
                           ]
                    )
                ]
                [ text label ]
            , span
                [ css
                    [ borderRadius (pct 50)
                    , backgroundColor Style.colors.purple
                    , width (px 40)
                    , height (px 40)
                    , marginRight (px 14)
                    , position relative
                    , after
                        [ Css.property "content" "''"
                        , display block
                        , width (px 13)
                        , height (px 2)
                        , position absolute
                        , left (pct 50)
                        , top (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , backgroundColor Style.colors.white
                        ]
                    , before
                        [ Css.property "content" "''"
                        , display block
                        , width (px 2)
                        , height (px 13)
                        , position absolute
                        , left (pct 50)
                        , top (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , backgroundColor Style.colors.white
                        ]
                    ]
                ]
                []
            ]
        ]


arrowsControl images =
    if List.length images > 1 then
        div
            [ css
                [ position absolute
                , right zero
                , bottom zero
                , backgroundColor Style.colors.grey
                ]
            ]
            [ button
                [ css
                    (arrowButtonStyle
                        ++ [ marginRight (px 1) ]
                    )
                , onClick PreviousImage
                ]
                [ span [ css Style.visuallyHidden ] [ text "Previous" ]
                , leftArrow
                ]
            , button
                [ css arrowButtonStyle
                , onClick NextImage
                ]
                [ span [ css Style.visuallyHidden ] [ text "Previous" ]
                , rightArrow
                ]
            ]

    else
        text ""


arrowButtonStyle =
    [ backgroundColor Style.colors.white
    , position relative
    , width (px 75)
    , height (px 90)
    ]


leftArrow =
    span
        [ css
            [ position absolute
            , top (pct 50)
            , width (px 13)
            , height (px 2)
            , after
                [ Css.property "content" "''"
                , display block
                , width (pct 100)
                , height (pct 100)
                , transform (rotate (deg -45))
                , Css.property "transform-origin" "0"
                , position absolute
                , left zero
                , top (px 1)
                , backgroundColor Style.colors.purple
                ]
            , before
                [ Css.property "content" "''"
                , display block
                , width (pct 100)
                , height (pct 100)
                , transform (rotate (deg 45))
                , Css.property "transform-origin" "0"
                , position absolute
                , left zero
                , backgroundColor Style.colors.purple
                ]
            ]
        ]
        []


rightArrow =
    span
        [ css
            [ position absolute
            , top (pct 50)
            , width (px 13)
            , height (px 2)
            , after
                [ Css.property "content" "''"
                , display block
                , width (pct 102)
                , height (pct 100)
                , transform (rotate (deg -45))
                , Css.property "transform-origin" "100% 0"
                , position absolute
                , left zero
                , backgroundColor Style.colors.purple
                ]
            , before
                [ Css.property "content" "''"
                , display block
                , width (pct 100)
                , height (pct 100)
                , transform (rotate (deg 45))
                , Css.property "transform-origin" "100%"
                , position absolute
                , left zero
                , backgroundColor Style.colors.purple
                ]
            ]
        ]
        []



--             , span [] [ text (String.fromInt model.currentImage) ]
--             , span []
--                 [ text
--                     (if model.isTextExpanded then
--                         "Expanded"
--                      else
--                         "Collapsed"
--                     )
--                 ]
--             , button [ css [ border3 (px 1) solid Style.colors.dark, padding (rem 1) ], onClick ToggleTextSection ] [ text "Toggle Text" ]
-- , p []
--                     [ text page.year
--                     , text " – "
--                     , text page.type_
--                     , text ", "
--                     , text page.location
--                     ]
