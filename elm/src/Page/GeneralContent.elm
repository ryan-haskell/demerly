module Page.GeneralContent exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.GeneralContent as Page
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Markdown
import Style


type alias Content =
    { settings : Settings
    , page : Page.GeneralContent
    }


view : Content -> Document msg
view { page } =
    { title = page.title ++ " | Demerly Architects"
    , body =
        [ main_
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ div
                [ css
                    [ position relative
                    , Style.breakpoints.desktop
                        [ displayFlex
                        ]
                    ]
                ]
                [ div
                    [ css
                        [ 
                            
                        Style.breakpoints.desktop
                            [ width (pct 50) ]
                        ]
                    ]
                    [ pageHeader page
                    ]
                , div
                    [ css
                        [ Style.breakpoints.desktop
                            [ width (pct 50)
                            , padding Style.spacing.medium
                            , paddingTop Style.spacing.medium
                            ]
                        ]
                    ]
                    [ bodyContent page
                    ]
                ]
            ]
        ]
    }


pageHeader : Page.GeneralContent -> Html msg
pageHeader page =
    header
        [ css
            [ backgroundImage (url page.image)
            , backgroundSize cover
            , backgroundPosition center
            , backgroundColor Style.colors.purple
            , marginLeft (px (Style.spacingValues.small * -1))
            , marginRight (px (Style.spacingValues.small * -1))
            , paddingLeft (px Style.spacingValues.small)
            , padding2 Style.spacing.medium Style.spacing.small
            , Style.breakpoints.desktop
                [ margin zero
                , padding Style.spacing.medium
                ]
            ]
        ]
        [ h1
            [ css
                [ color Style.colors.white
                ]
            ]
            [ text page.title ]
        , p
            [ css Style.typography.leadCopy
            , css
                [ color Style.colors.milk
                ]
            ]
            [ text page.description ]
        ]


bodyContent : Page.GeneralContent -> Html msg
bodyContent page =
    div
        [ css
            [ paddingTop Style.spacing.small
            , Style.breakpoints.desktop
                [ paddingTop zero ]
            ]
        ]
        [ Markdown.toHtml [ Attr.class "rich-text" ] page.content |> Html.Styled.fromUnstyled
        ]
