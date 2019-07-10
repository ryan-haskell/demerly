module Style exposing
    ( breakpoints
    , colors
    , globals
    , grid
    , listReset
    , overlayBase
    , photoCardRatio
    , sizes
    , spacing
    , styles
    , typography
    , visuallyHidden
    , widths
    )

import Css exposing (..)
import Css.Global as Global
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Transitions as Transitions


colors =
    { milk = rgba 255 255 255 0.95
    , dark = rgb 74 74 74
    , charcoal = rgb 151 151 151
    , white = rgb 255 255 255
    , grey = rgb 238 238 238
    , purple = rgb 97 81 111
    , opaquePurple = rgba 97 81 111 0.9
    , overlayBlue = rgba 65 75 104 0.35
    , opaqueBlack = rgba 0 0 0 0.7
    , opaqueBlackZero = rgba 0 0 0 0
    }


spacingValues =
    { tiny = 20
    , small = 32
    , medium = 48
    , large = 64
    , extraLarge = 96
    }


spacing =
    { tiny = px spacingValues.tiny
    , small = px spacingValues.small
    , medium = px spacingValues.medium
    , large = px spacingValues.large
    , extraLarge = px spacingValues.extraLarge
    }


heights =
    { navbar = 115
    , footer = 90
    }


widths =
    { container = 1440
    }


sizes =
    { navbarHeight = px heights.navbar
    , containerWidth = px widths.container
    , pageHeightMobile = calc (vh 100) minus (px heights.navbar)
    , pageHeight = calc (vh 100) minus (px (heights.navbar + heights.footer))
    }


styles =
    { container =
        [ width (pct 100)
        , maxWidth sizes.containerWidth
        , margin2 zero auto
        ]
    }


visuallyHidden =
    [ height (px 1)
    , margin (px -1)
    , overflow hidden
    , padding zero
    , position absolute
    , width (px 1)
    , Css.property "clip" "rect(1px, 1px, 1px, 1px)"
    ]


overlayBase =
    [ position absolute
    , top zero
    , bottom zero
    , left zero
    , right zero
    ]


families =
    { heading = [ "Barlow", "sans-serif" ]
    , body = [ "Frank Ruhl Libre", "serif" ]
    }


above px_ =
    withMedia [ only screen [ Media.minWidth (px px_) ] ]


breakpoints =
    { desktop = above 720
    }


halfGridWidth =
    calc (pct 50) minus (px (spacingValues.medium / 2))


grid =
    { context =
        [ breakpoints.desktop
            [ displayFlex
            , flexWrap wrap
            , justifyContent spaceBetween
            ]
        ]
    , twoColumnList =
        [ marginBottom spacing.tiny
        , breakpoints.desktop
            [ width halfGridWidth
            , marginBottom spacing.medium
            ]
        ]
    }


typography =
    { title =
        [ fontSize (px 24)
        , lineHeight (px 29)
        , letterSpacing (px 0.67)
        , fontFamilies families.heading
        , fontWeight (int 600)
        , textTransform uppercase
        , breakpoints.desktop
            [ fontSize (px 32)
            , lineHeight (px 38)
            , letterSpacing (px 0.98)
            ]
        ]
    , subtitle =
        [ fontSize (px 16)
        , lineHeight (px 19)
        , letterSpacing (px 0.8)
        , fontFamilies families.heading
        , fontWeight (int 600)
        , breakpoints.desktop
            [ fontSize (px 18)
            , lineHeight (px 22)
            , letterSpacing (px 0.9)
            ]
        ]
    , paragraph =
        [ fontSize (px 16)
        , lineHeight (px 24)
        , letterSpacing (px 0.31)
        , fontFamilies families.body
        , fontWeight (int 400)
        , breakpoints.desktop
            [ fontSize (px 18)
            , lineHeight (px 24)
            , letterSpacing (px 0.31)
            ]
        ]
    , link =
        [ fontSize (px 20)
        , lineHeight (px 24)
        , letterSpacing (px 1)
        , fontFamilies families.heading
        , fontWeight (int 600)
        ]
    , smallLink =
        [ letterSpacing (px 1)
        , fontFamilies families.heading
        , fontWeight (int 600)
        , breakpoints.desktop
            [ fontSize (px 18) ]
        ]
    , highlightTitle =
        [ fontSize (px 18)
        , lineHeight (px 21)
        , letterSpacing (px 1)
        , fontFamilies families.heading
        , fontWeight (int 600)
        , textTransform uppercase
        , breakpoints.desktop
            [ fontSize (px 20)
            , lineHeight (px 24)
            ]
        ]
    , toggleOverlayTitle =
        [ fontSize (px 14)
        , letterSpacing (px 1)
        , lineHeight (px 20)
        , fontFamilies families.heading
        , fontWeight (int 600)
        , textTransform uppercase
        , breakpoints.desktop
            [ fontSize (px 20)
            , fontWeight (int 400)
            , lineHeight (px 24)
            ]
        ]
    }


listReset =
    [ listStyle none
    , paddingLeft zero
    , margin zero
    ]


photoCardDimensions =
    { width = 635
    , height = 375
    }


photoCardRatio =
    photoCardDimensions.height / photoCardDimensions.width


globals =
    Global.global
        [ Global.selector "body"
            [ color (rgb 74 74 74)
            , fontFamilies [ "Barlow", "sans-serif" ]
            ]
        , Global.selector "html, body, [data-elm-hot]"
            [ height (pct 100)
            ]
        , Global.selector "*"
            [ boxSizing borderBox
            ]
        , Global.selector "h1, h2, h3, h4, h5, h6"
            [ margin zero
            ]
        , Global.selector ".rich-text"
            [ lineHeight (num 1.5)
            , fontFamilies families.body
            ]
        , Global.selector ".rich-text--large"
            [ fontSize (px 22)
            , breakpoints.desktop
                [ fontSize (px 32)
                ]
            ]
        , Global.selector ".page, .layout"
            [ opacity zero
            , Transitions.transition
                [ Transitions.opacity 300
                ]
            ]
        , Global.selector ".page--visible, .layout--visible"
            [ opacity (num 1)
            ]
        , Global.class "layout"
            [ displayFlex
            , flexDirection column
            , minHeight (pct 100)
            ]
        , Global.class "page"
            [ property "flex" "1 0 auto"
            , height (pct 100)
            ]
        , Global.button
            [ backgroundColor (rgba 0 0 0 0)
            , border zero
            , borderRadius zero
            , padding zero
            ]
        , Global.a
            [ color inherit
            ]
        , Global.selector ".homepage__slide:hover .homepage__gradient"
            [ opacity (num 1)
            ]
        , Global.selector ".homepage__slide:hover .homepage__content"
            [ transform none
            ]
        ]
