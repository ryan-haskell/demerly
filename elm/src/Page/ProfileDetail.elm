module Page.ProfileDetail exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Css.Transitions as Transitions
import Data.Page.ProfileDetail as Page
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src)
import Html.Styled.Events exposing (onClick)
import Markdown
import Style


type alias Content =
    { page : Page.ProfileDetail
    , settings : Settings
    }


contentPaddingHorizontalMobile =
    [ paddingLeft Style.spacing.small
    , paddingRight Style.spacing.small
    ]


title : Content -> String
title { page } =
    String.join " | "
        [ page.name
        , "Profile"
        , "Demerly Architects"
        ]


view : Content -> Document msg
view content =
    { title = title content
    , body =
        [ main_ []
            [ optionally profileSnapshot content.page.image
            , profileDeets content
            , viewBio content.page.bio
            ]
        ]
    }


profileSnapshot : String -> Html msg
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


profileDeets : Content -> Html msg
profileDeets content =
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


viewBio : String -> Html msg
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


viewEmail : String -> Html msg
viewEmail email =
    p
        []
        [ a
            [ href ("mailto:" ++ email)
            ]
            [ text email
            ]
        ]


phoneCombo : String -> String -> Html msg
phoneCombo prefix digits =
    span
        [ css
            [ display inlineBlock
            , marginRight Style.spacing.tiny
            ]
        ]
        [ text (prefix ++ ": " ++ digits)
        ]
