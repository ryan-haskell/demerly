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



-- NAVBAR


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
                        , css
                            [ padding Style.spacing.tiny
                            , Style.breakpoints.desktop
                                [ display none
                                ]
                            ]
                        ]
                        [ menuIcon context
                        ]
                    , viewNavbarLinks context settings
                    ]
                ]
            ]
        ]


viewNavbarLinks : Context.Model -> Settings -> Html msg
viewNavbarLinks context settings =
    div
        [ css
            [ display none
            , Style.breakpoints.desktop [ displayFlex ]
            ]
        ]
        (List.map
            (viewNavbarLink context)
            (links settings)
        )


viewNavbarLink : Context.Model -> ( String, String ) -> Html msg
viewNavbarLink context ( label, url ) =
    a
        [ href url
        , css linkStyles
        , css (linkLineEffect (String.contains url (Route.toString context.route)))
        , css [ marginLeft Style.spacing.small ]
        ]
        [ text label ]


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



-- MOBILE MENU


mainMenuLink : Context.Model -> ( String, String ) -> Html msg
mainMenuLink context ( label, url ) =
    let
        isActive =
            String.contains url (Route.toString context.route)
    in
    a
        [ href url
        , css linkStyles
        , css (linkLineEffect isActive)
        , css
            [ marginBottom (px 16)
            ]
        ]
        [ text label ]


linkStyles =
    [ textDecoration none
    , fontSize (px 32)
    , textTransform uppercase
    , fontWeight (int 600)
    , letterSpacing (px 1.78)
    , fontFamilies [ "Barlow", "sans-serif" ]
    , Style.breakpoints.desktop
        [ fontSize (px 18)
        , letterSpacing (px 1)
        ]
    ]


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
            , Style.breakpoints.desktop
                [ display none
                ]
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


linkLineEffect isActive =
    [ position relative
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
    , hover [ before [ transform none ] ]
    ]
        ++ (if isActive then
                [ before [ transform none ] ]

            else
                []
           )



-- FOOTER


siteFooter : Settings -> Html msg
siteFooter settings =
    footer
        [ css
            [ padding2 Style.spacing.tiny Style.spacing.small
            , backgroundColor (rgb 255 255 255)
            ]
        ]
        [ div [ css Style.styles.container ]
            [ address
                [ css
                    [ displayFlex
                    , fontStyle normal
                    , justifyContent flexEnd
                    , flexWrap wrap
                    ]
                ]
                [ p
                    [ css
                        [ marginBottom zero
                        , marginRight Style.spacing.small
                        ]
                    ]
                    [ text settings.footer.address ]
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
        ]
