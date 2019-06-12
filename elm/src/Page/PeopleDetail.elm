module Page.PeopleDetail exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Css.Transitions as Transitions
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src)
import Html.Styled.Events exposing (onClick)


type alias Page =
    { name : String
    , email : Maybe String
    , credentials : String
    , position : String
    , phone : String
    , fax : String
    , bio : String
    , photo : String
    }


type alias Link =
    { label : String
    , url : String
    }


type alias Settings =
    { logo : String
    , links : List Link
    , address : String
    , phone : String
    , fax : String
    }


type alias Content =
    { page : Page
    , settings : Settings
    }


content : Content
content =
    Content
        { photo = "/images/photo-mark2.jpg"
        , name = "Mark Demerly"
        , email = Just "mark@demerlyarchitects.com"
        , credentials = "AIA, NCARB, LEED-AP"
        , position = "President"
        , phone = "317.847.0724"
        , fax = "888.895.2811"
        , bio = """
        Heading up his own firm allows Mark to focus on what he values most: designing homes for people to enjoy. His professional, civic and community interests are fueled by his passion for making Indianapolis communities better places to live. As the Midtown Economic Council representative, he advocates for responsible growth and more public amenities in Midtown Indianapolis development. He launched the Broad Ripple Winter Market to support sustainability and enable local producers and growers to expand their businesses. In short order, the market became a prized amenity for northside residents. Mark has served as the president for IMA Design Arts and Contemporary Arts support groups, and is a past president and founding member of the national AIA Custom Residential Architect Network committee, which has advocated for and increased awareness of the residential architecture profession. He serves on Broad Ripple’s Land Use and Development Committee and participates in numerous other community initiatives. Mark’s devotion to cooking and food has helped inspire his designs for the restaurants the firm has developed for the city’s top chefs. His love of nature, hiking and the outdoors has led to community gardens and memorials to those who have contributed much.

        Mark has Bachelor of Science in X and Bachelor of Science in Architecture degrees from Ball State University. 
    """
        }
        { logo = "/images/logo-mobile.svg"
        , links =
            [ Link "Projects" "/projects"
            , Link "Process" "/process"
            , Link "Profile" "/profile"
            , Link "Contact" "/contact"
            ]
        , address = "6500 Westfield Boulevard   /   Indianapolis, IN 46220"
        , phone = "317.847.0724"
        , fax = "888.895.2811"
        }


type alias Model =
    { isMenuVisible : Bool
    }


init : Model
init =
    Model False


type Msg
    = UserClickedMenu


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserClickedMenu ->
            { model | isMenuVisible = not model.isMenuVisible }


view : Model -> Html Msg
view model =
    div []
        [ navbar model
        , mainMenu model
        , mainLayout
        , siteFooter
        ]


navbarHeight =
    px 115


navbar : Model -> Html Msg
navbar model =
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
                , padding2 (px 20) siteHorizontalPadding.mobile
                , justifyContent spaceBetween
                , alignItems center
                , zIndex (int 2)
                ]
            ]
            [ a [ href "/" ]
                [ img
                    [ src content.settings.logo
                    , alt "Demerly Architext"
                    ]
                    []
                ]
            , button
                [ onClick UserClickedMenu
                , attribute "aria-label" "Toggle Menu"
                ]
                [ menuIcon model
                ]
            ]
        ]


menuIcon : Model -> Html Msg
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


mainMenuLink : Link -> Html Msg
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


mainMenu : Model -> Html Msg
mainMenu model =
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
            , backgroundColor colors.milk
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , Transitions.transition [ Transitions.opacity 200, Transitions.visibility 200 ]
            ]
        ]
        (List.map mainMenuLink content.settings.links)


siteFooter : Html Msg
siteFooter =
    footer
        [ css
            [ padding2 (px 20) siteHorizontalPadding.mobile
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
            [ p [ css [ marginBottom zero ] ] [ text content.settings.address ]
            , p []
                [ span
                    [ css
                        [ marginRight (rem 1)
                        ]
                    ]
                    [ text ("P - " ++ content.settings.phone) ]
                , span [] [ text ("F - " ++ content.settings.fax) ]
                ]
            ]
        ]


colors =
    { milk = rgba 255 255 255 0.95
    , dark = rgb 74 74 74
    , charcoal = rgb 151 151 151
    }


siteHorizontalPadding =
    { mobile = px 32
    , tableet = px 40
    , desktop = px 120
    }


spacing =
    { base = px 36
    , large = px 76
    , extraLarge = px 100
    }


contentPaddingHorizontalMobile =
    [ paddingLeft (px 50)
    , paddingRight (px 50)
    ]


mainLayout : Html Msg
mainLayout =
    main_ []
        [ profileSnapshot
        , profileDeets
        ]


profileSnapshot : Html Msg
profileSnapshot =
    div
        [ css
            [ backgroundImage (url content.page.photo)
            , backgroundSize cover
            , backgroundPosition2 (pct 100) zero
            , height (px 390)
            ]
        ]
        []


designMark =
    [ Css.property "content" "''"
    , display block
    , height (px 1)
    , width (px 50)
    , backgroundColor colors.charcoal
    , marginTop spacing.base
    ]


profileDeets : Html Msg
profileDeets =
    div
        [ css
            (List.append contentPaddingHorizontalMobile
                [ paddingTop (px 50)
                , after designMark
                ]
            )
        ]
        [ h1
            [ css
                [ fontSize (px 24)
                , fontWeight (int 600)
                , marginBottom (px 18)
                ]
            ]
            [ text content.page.name ]
        , div
            []
            [ text content.page.credentials ]
        , div []
            [ text content.page.position ]
        , p
            []
            [ phoneCombo "p" content.page.phone
            , phoneCombo "f" content.page.fax
            ]
        , case content.page.email of
            Just value ->
                viewemail value

            Nothing ->
                text ""
        , content.page.email
            -- Maybe String
            |> Maybe.map viewemail
            -- Maybe (Html Msg)
            |> Maybe.withDefault (text "")

        -- (Html Msg)
        ]


renemap : (a -> b) -> Maybe a -> Maybe b
renemap fn maybe =
    case maybe of
        Just value ->
            Just (fn value)

        Nothing ->
            Nothing


viewemail : String -> Html Msg
viewemail email =
    p
        []
        [ a
            [ href ("mailto:" ++ email)
            ]
            [ text email
            ]
        ]


phoneCombo : String -> String -> Html Msg
phoneCombo prefix digits =
    span
        [ css
            [ display inlineBlock
            , marginRight (px 16)
            ]
        ]
        [ text (prefix ++ ": " ++ digits)
        ]
