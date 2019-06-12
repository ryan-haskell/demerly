module Style exposing
    ( breakpoints
    , colors
    , globals
    , spacing
    , typography
    )

import Css exposing (..)
import Css.Global as Global
import Css.Media as Media exposing (only, screen, withMedia)


colors =
    { milk = rgba 255 255 255 0.95
    , dark = rgb 74 74 74
    , charcoal = rgb 151 151 151
    }


spacing =
    { tiny = px 20
    , small = px 32
    , medium = px 48
    , large = px 64
    , extraLarge = px 96
    }


families =
    { heading = [ "Barlow", "sans-serif" ]
    , body = [ "Frank Ruhl Libre", "serif" ]
    }


above px_ =
    withMedia [ only screen [ Media.minWidth (px px_) ] ]


breakpoints =
    { desktop = above 480
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
    }


globals =
    Global.global
        [ Global.selector "body"
            [ backgroundColor (rgb 225 225 225)
            , color (rgb 74 74 74)
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
            ]
        ]
