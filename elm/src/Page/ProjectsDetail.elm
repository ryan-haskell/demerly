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
import Css.Transitions as Transitions
import Data.ProjectsDetail as Page
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css, href, src)
import Html.Styled.Events exposing (onClick)
import Markdown
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
    { title = page.title ++ " | Projects | Demerly Architects"
    , body =
        [ main_
            [ css Style.styles.container ]
            -- Demo of update
            [ div
                [ css
                    [ height Style.sizes.pageHeightMobile
                    , position relative
                    , overflow hidden
                    , Style.breakpoints.desktop
                        [ height Style.sizes.pageHeight
                        ]
                    ]
                ]
                [ toggleTrigger model.isTextExpanded page.title
                , detailsModal model page
                , div
                    [ css
                        [ width (pct 100)
                        , height (pct 100)
                        , position relative
                        , Style.breakpoints.desktop
                            [ after dimPsuedoOverlay
                            , zIndex (int 2)
                            ]
                        ]
                    ]
                    (List.indexedMap (slideImage model.currentImage) page.images)
                , arrowsControl page.images
                ]
            ]
        ]
    }


slideImage currentImage idx photo =
    div
        [ css
            [ backgroundImage (url photo)
            , backgroundSize cover
            , backgroundPosition center
            , width (pct 100)
            , height (pct 100)
            , position absolute
            , top zero
            , left zero
            , Transitions.transition
                [ Transitions.opacity 450
                ]
            , if currentImage == idx then
                opacity (int 1)

              else
                opacity zero
            ]
        ]
        []


detailsModal model_ page =
    div
        [ css
            (Style.overlayBase
                ++ [ overflow auto
                   , position absolute
                   , top zero
                   , bottom zero
                   , left zero
                   , right zero
                   , zIndex (int 2)
                   , padding Style.spacing.medium
                   , paddingRight Style.spacing.small
                   , backgroundColor Style.colors.opaquePurple
                   , color Style.colors.white
                   , Style.breakpoints.desktop
                        [ left (px 320)
                        , zIndex (int 8)
                        , displayFlex
                        , flexDirection column
                        , justifyContent center
                        ]
                    ,Transitions.transition
                            [ Transitions.transform 450
                            ]
                   ]
                ++ (if model_.isTextExpanded then
                        []

                    else
                        [ transform (translateY (pct 100))
                        , Style.breakpoints.desktop [ transform (translateX (pct 100)) ] 
                        ]
                   )
            )
        ]
        [ h1 [ css Style.visuallyHidden ] [ text page.title ]
        , p
            [ css
                [ fontWeight (int 600)
                , margin3 zero zero Style.spacing.small
                ]
            ]
            [ text page.year
            , text " – "
            , text page.type_
            , text ", "
            , text page.location
            ]
        , Markdown.toHtml [ Attr.class "rich-text rich-text--large" ] page.details |> Html.Styled.fromUnstyled
        ]

toggleTrigger isTextExpanded label =
    div
        [ css
            [ position absolute
            , bottom zero
            , left zero
            , right zero
            , paddingRight (px 150)
            , height (px 90)
            , zIndex (int 3)
            , backgroundColor Style.colors.grey
            , Style.breakpoints.desktop
                [ backgroundColor transparent
                , marginBottom zero
                , top (px 24)
                , left Style.spacing.medium
                , right auto
                , paddingRight zero
                , zIndex (int 7)
                ]
            ]
        ]
        [ button
            [ css
                [ padding (rem 1)
                , width (pct 100)
                , height (pct 100)
                , displayFlex
                , alignItems center
                , Style.breakpoints.desktop
                    [ width auto
                    ]
                ]
            , onClick ToggleTextSection
            ]
            [ span
                [ css
                    (Style.typography.toggleOverlayTitle
                        ++ [ color Style.colors.dark
                           , order (int 2)
                           , Style.breakpoints.desktop
                                [ order zero
                                , color Style.colors.white
                                ]
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
                    , Style.breakpoints.desktop
                        [ marginLeft (px 14)
                        , marginRight zero
                        , width (px 36)
                        , height (px 36)
                        , backgroundColor Style.colors.white
                        , Transitions.transition
                            [ Transitions.transform 300
                            ]
                        , after
                            [ backgroundColor Style.colors.purple
                            ]
                        , before
                            [ backgroundColor Style.colors.purple
                            ]
                        ]
                    ]
                , css <|
                    if isTextExpanded then
                        [ Style.breakpoints.desktop
                            [ backgroundColor Style.colors.purple
                            , after
                                [ backgroundColor Style.colors.white
                                ]
                            , before
                                [ backgroundColor Style.colors.white
                                ]
                            ]
                        , transform (rotate (deg 45))
                        ]

                    else
                        []
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
                , zIndex (int 5)
                , backgroundColor Style.colors.grey
                , displayFlex
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


dimPsuedoOverlay =
    Style.overlayBase
        ++ [ Css.property "content" "''"
           , display block
           , bottom auto
           , height (px 150)
           , backgroundImage (linearGradient2 toBottom (stop2 Style.colors.opaqueBlack <| pct 0) (stop <| Style.colors.opaqueBlackZero) [])
           ]



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
