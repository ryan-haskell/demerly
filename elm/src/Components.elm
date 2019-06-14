module Components exposing
    ( mainMenu
    , navbar
    , siteFooter
    )

import Application.Context as Context
import Css exposing (..)
import Css.Transitions as Transitions
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src)
import Html.Styled.Events exposing (onClick)
import Route exposing (Route)
import Style


navbar : Settings -> msg -> Context.Model -> Html msg
navbar settings onMenuClick context =
    header
        [ css
            [ height Style.sizes.navbarHeight ]
        ]
        [ div
            [ css
                [ height Style.sizes.navbarHeight
                , position fixed
                , left zero
                , right zero
                , top zero
                , backgroundColor (rgb 255 255 255)
                , zIndex (int 2)
                , padding2 Style.spacing.tiny Style.spacing.small
                ]
            ]
            [ div
                [ css Style.styles.container
                , css
                    [ height (pct 100)
                    ]
                ]
                [ div
                    [ css
                        [ displayFlex
                        , justifyContent spaceBetween
                        , alignItems center
                        , height (pct 100)
                        ]
                    ]
                    [ a
                        [ href "/" ]
                        [ img
                            [ src settings.header.logos.mobile
                            , alt settings.header.brand
                            , css [ Style.breakpoints.desktop [ display none ] ]
                            ]
                            []
                        , img
                            [ src settings.header.logos.desktop
                            , alt settings.header.brand
                            , css
                                [ display none
                                , Style.breakpoints.desktop [ display block ]
                                ]
                            ]
                            []
                        ]
                    , button
                        [ onClick onMenuClick
                        , attribute "aria-label" "Toggle Menu"
                        , css [ padding Style.spacing.tiny ]
                        ]
                        [ menuIcon context
                        ]
                    ]
                ]
            ]
        ]


menuIcon : Context.Model -> Html msg
menuIcon context =
    let
        hamburgerIconPath =
            "/images/hamburger.svg"

        closeIconPath =
            "/images/close.svg"

        iconToShow =
            if context.isMenuOpen then
                closeIconPath

            else
                hamburgerIconPath
    in
    img [ src iconToShow, attribute "aria-hidden" "true" ] []


type alias Link =
    { label : String
    , url : String
    }


mainMenuLink : Context.Model -> ( String, String ) -> Html msg
mainMenuLink context ( label, url ) =
    let
        activeStyles =
            [ before
                [ transform none
                ]
            ]

        isActive =
            String.contains url (Route.toString context.route)
    in
    a
        [ href url
        , css
            ([ fontSize (px 32)
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
             , hover activeStyles
             ]
                ++ (if isActive then
                        activeStyles

                    else
                        []
                   )
            )
        ]
        [ text label ]


mainMenu : Settings -> Context.Model -> Html msg
mainMenu settings context =
    nav
        [ css
            [ position fixed
            , opacity
                (if context.isMenuOpen then
                    num 1

                 else
                    num 0
                )
            , property "visibility"
                (if context.isMenuOpen then
                    "visible"

                 else
                    "hidden"
                )
            , top zero
            , bottom zero
            , left zero
            , right zero
            , zIndex (int 1)
            , backgroundColor Style.colors.milk
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , Transitions.transition [ Transitions.opacity 200, Transitions.visibility 200 ]
            ]
        ]
        (List.map
            (mainMenuLink context)
            (links settings)
        )


links : Settings -> List ( String, String )
links settings =
    let
        { projects, process, profile, contact } =
            settings.header.linkLabels
    in
    [ ( projects, "/projects" )
    , ( process, "/process" )
    , ( profile, "/profile" )
    , ( contact, "/contact" )
    ]


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
            [ p [ css [ marginBottom zero ] ] [ text settings.footer.address ]
            , p []
                [ span
                    [ css
                        [ marginRight (rem 1)
                        ]
                    ]
                    [ text ("P - " ++ settings.footer.phone) ]
                , span [] [ text ("F - " ++ settings.footer.fax) ]
                ]
            ]
        ]
