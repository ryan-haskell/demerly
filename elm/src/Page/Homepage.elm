module Page.Homepage exposing (Content, view)

import Application.Context as Context
import Application.Document exposing (Document)
import Css exposing (..)
import Data.Homepage as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (class, css, href)
import Style


type alias Content =
    { page : Page.Homepage
    , settings : Settings
    }


view : Context.Model -> Content -> Document msg
view context content =
    { title = "Demerly Architects"
    , body =
        [ viewSlides context content.page
        ]
    }


viewSlides : Context.Model -> Page.Homepage -> Html msg
viewSlides { viewport } page =
    div
        [ css
            [ Style.breakpoints.desktop
                [ displayFlex
                , height Style.sizes.pageHeight
                , overflowX auto
                , marginLeft <|
                    if viewport.width > Style.widths.container then
                        px (toFloat (viewport.width - Style.widths.container) / 2)

                    else
                        px 0
                ]
            ]
        ]
        (List.map viewSlide page.slides)


viewSlide : Page.Slide -> Html msg
viewSlide slide =
    a
        [ class "homepage__slide"
        , href ("/projects/" ++ slide.slug)
        , css
            [ height (vh 70)
            , position relative
            , backgroundColor Style.colors.dark
            , color Style.colors.white
            , backgroundPosition center
            , backgroundSize cover
            , backgroundImage (url slide.image)
            , overflowY hidden
            , Style.breakpoints.desktop
                [ height (pct 100)
                , minWidth (vw 27)
                ]
            ]
        ]
        [ div
            [ css
                [ position absolute
                , top zero
                , left zero
                , right zero
                , bottom zero
                , zIndex (int 1)
                , pointerEvents none
                , backgroundImage
                    (linearGradient2
                        toBottom
                        (stop (rgba 0 0 0 0))
                        (stop (rgba 0 0 0 0.7))
                        []
                    )
                ]
            ]
            []
        , div
            [ class "homepage__gradient"
            , css
                [ position absolute
                , top zero
                , left zero
                , right zero
                , bottom zero
                , zIndex (int 1)
                , opacity zero
                , pointerEvents none
                , backgroundImage <|
                    linearGradient2 toBottom
                        (stop2 (rgba 0 0 0 0) (pct 25))
                        (stop (rgba 97 81 111 0.7))
                        []
                , property "transition" "opacity 200ms ease-in-out"

                -- , Style.breakpoints.desktop
                --     [ hover
                --         [ opacity (num 1)
                --         ]
                --     ]
                ]
            ]
            []
        , div
            [ class "homepage__content"
            , css
                [ position absolute
                , bottom (rem 1)
                , left (rem 1)
                , zIndex (int 2)
                , pointerEvents none
                , property "transition" "transform 200ms ease-in-out"
                , Style.breakpoints.desktop
                    [ transform (translateY (px 66))
                    ]
                ]
            ]
            [ h3
                [ css Style.typography.link ]
                [ text slide.title ]
            , p
                [ css
                    [ display none
                    , Style.breakpoints.desktop
                        [ display block
                        , marginTop (rem 1)
                        , paddingTop (rem 1)
                        , position relative
                        ]
                    , before
                        [ property "content" "''"
                        , position absolute
                        , top zero
                        , width (rem 2)
                        , height (px 1)
                        , backgroundColor Style.colors.milk
                        ]
                    ]
                ]
                [ text slide.details ]
            ]
        ]
