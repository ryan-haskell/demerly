module Components exposing
    ( mainMenu
    , navbar
    , siteFooter
    )

import Css exposing (..)
import Css.Transitions as Transitions
import Data.Settings exposing (Link, Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src)
import Html.Styled.Events exposing (onClick)
import Style


navbarHeight =
    px 115


type alias Model a =
    { a
        | isMenuVisible : Bool
    }


navbar : Settings -> msg -> Model a -> Html msg
navbar settings onMenuClick model =
    header
        [ css
            [ height navbarHeight ]
        ]
        [ div
            [ css
                [ height navbarHeight
                , position fixed
                , left zero
                , right zero
                , top zero
                , backgroundColor (rgb 255 255 255)
                , displayFlex
                , padding2 Style.spacing.tiny Style.spacing.small
                , justifyContent spaceBetween
                , alignItems center
                , zIndex (int 2)
                ]
            ]
            [ a [ href "/" ]
                [ img
                    [ src settings.logo
                    , alt "Demerly Architext"
                    ]
                    []
                ]
            , button
                [ onClick onMenuClick
                , attribute "aria-label" "Toggle Menu"
                ]
                [ menuIcon model
                ]
            ]
        ]


menuIcon : Model a -> Html msg
menuIcon model =
    let
        hamburgerIconPath =
            "/images/hamburger.svg"

        closeIconPath =
            "/images/close.svg"

        iconToShow =
            if model.isMenuVisible then
                closeIconPath

            else
                hamburgerIconPath
    in
    img [ src iconToShow, attribute "aria-hidden" "true" ] []


mainMenuLink : Link -> Html msg
mainMenuLink { label, url } =
    a
        [ href url
        , css
            [ fontSize (px 32)
            , textTransform uppercase
            , fontWeight (int 600)
            , letterSpacing (px 1.78)
            , fontFamilies [ "Barlow", "sans-serif" ]
            , textDecoration none
            , marginBottom (px 16)
            , color inherit
            , position relative
            , before
                [ Css.property "content" "''"
                , position absolute
                , left (px -8)
                , top (pct 50)
                , right (px -8)
                , borderTop3 (px 1) solid (rgb 0 0 0)
                , transform (scaleX 0.0)
                , Css.property "transform-origin" "0 0"
                , Transitions.transition [ Transitions.transform 300 ]
                ]
            , hover
                [ before
                    [ transform none
                    ]
                ]
            ]
        ]
        [ text label ]


mainMenu : Settings -> Model a -> Html msg
mainMenu settings model =
    nav
        [ css
            [ position fixed
            , opacity
                (if model.isMenuVisible then
                    num 1

                 else
                    num 0
                )
            , property "visibility"
                (if model.isMenuVisible then
                    "visible"

                 else
                    "hidden"
                )
            , top zero
            , bottom zero
            , left zero
            , right zero
            , backgroundColor Style.colors.milk
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , Transitions.transition [ Transitions.opacity 200, Transitions.visibility 200 ]
            ]
        ]
        (List.map mainMenuLink settings.links)


siteFooter : Settings -> Html msg
siteFooter settings =
    footer
        [ css
            [ padding2 Style.spacing.tiny Style.spacing.small
            , backgroundColor (rgb 255 255 255)
            ]
        ]
        [ address
            [ css
                [ displayFlex
                , fontStyle normal
                , flexDirection rowReverse
                , flexWrap wrap
                ]
            ]
            [ p [ css [ marginBottom zero ] ] [ text settings.address ]
            , p []
                [ span
                    [ css
                        [ marginRight (rem 1)
                        ]
                    ]
                    [ text ("P - " ++ settings.phone) ]
                , span [] [ text ("F - " ++ settings.fax) ]
                ]
            ]
        ]
