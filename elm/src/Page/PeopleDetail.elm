module Page.PeopleDetail exposing (Model, Msg, init, update, view)

import Components
import Css exposing (..)
import Css.Transitions as Transitions
import Data.Settings exposing (Link, Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src)
import Html.Styled.Events exposing (onClick)
import Markdown
import Style


type alias Page =
    { name : String
    , photo : Maybe String
    , bio : String
    , email : Maybe String
    , phone : Maybe String
    , fax : Maybe String
    , credentials : Maybe String
    , position : Maybe String
    }


type alias Content =
    { page : Page
    , settings : Settings
    }


content : Content
content =
    Content
        { photo = Just "/images/photo-mark2.jpg"
        , name = "Mark Demerly"
        , email = Just "mark@demerlyarchitects.com"
        , credentials = Just "AIA, NCARB, LEED-AP"
        , position = Just "President"
        , phone = Just "317.847.0724"
        , fax = Just "888.895.2811"
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
        [ Components.navbar content.settings UserClickedMenu model
        , Components.mainMenu content.settings model
        , mainLayout
        , Components.siteFooter content.settings
        ]


contentPaddingHorizontalMobile =
    [ paddingLeft Style.spacing.small
    , paddingRight Style.spacing.small
    ]


mainLayout : Html Msg
mainLayout =
    main_ []
        [ optionally profileSnapshot content.page.photo
        , profileDeets
        , viewBio content.page.bio
        ]


profileSnapshot : String -> Html Msg
profileSnapshot photo =
    div
        [ css
            [ backgroundImage (url photo)
            , backgroundSize cover
            , backgroundPosition2 (pct 100) zero
            , width (pct 100)
            , height zero
            , paddingBottom (pct 100)
            , Style.breakpoints.desktop
                [ paddingBottom (pct 60)
                ]
            ]
        ]
        []


designMark =
    [ Css.property "content" "''"
    , display block
    , height (px 1)
    , width Style.spacing.large
    , backgroundColor Style.colors.charcoal
    , marginTop Style.spacing.small
    ]


profileDeets : Html Msg
profileDeets =
    div
        [ css
            (List.append contentPaddingHorizontalMobile
                [ paddingTop Style.spacing.medium
                , after designMark
                ]
            )
        ]
        [ h1
            [ css Style.typography.title ]
            [ text content.page.name ]
        , div [ css [ marginBottom Style.spacing.tiny ] ] []
        , optionally viewSubheader content.page.credentials
        , optionally viewSubheader content.page.position
        , p
            []
            [ optionally (phoneCombo "p") content.page.phone
            , optionally (phoneCombo "f") content.page.fax
            ]
        , optionally viewEmail content.page.email
        ]


viewSubheader stuff =
    div [ css Style.typography.subtitle ] [ text stuff ]


viewBio : String -> Html Msg
viewBio bioMarkdown =
    div
        [ css
            [ padding Style.spacing.small
            ]
        ]
        [ Markdown.toHtml [ Attr.class "rich-text" ] bioMarkdown |> Html.Styled.fromUnstyled
        ]


optionally : (a -> Html msg) -> Maybe a -> Html msg
optionally viewFn maybe =
    maybe
        |> Maybe.map viewFn
        |> Maybe.withDefault (text "")


viewEmail : String -> Html Msg
viewEmail email =
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
            , marginRight Style.spacing.tiny
            ]
        ]
        [ text (prefix ++ ": " ++ digits)
        ]
