module Page.ProfileLanding exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.ProfileLanding as Page
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Markdown
import Style


type alias Content =
    { settings : Settings
    , page : Page.ProfileLanding
    }


view : Content -> Document msg
view { page } =
    { title = "Profile | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1
                [ css Style.typography.title
                , css [ marginBottom Style.spacing.small ]
                ]
                [ text page.title ]
            , leadCopy page.description
            , section [ css [ marginTop Style.spacing.large ] ]
                [ h3
                    [ css Style.typography.title
                    , css [ marginBottom Style.spacing.small ]
                    ]
                    [ text page.team.title ]
                , profileList (sortByLastName page.team.people)
                ]
            ]
        ]
    }

sortByLastName =
    List.sortBy (lastName >> Maybe.withDefault "")

lastName : { a | name : String } -> Maybe String
lastName =
    .name
        >> String.split " "
        >> List.drop 1
        >> List.head


leadCopy : String -> Html msg
leadCopy description =
    div [ css Style.typography.paragraph, css [ maxWidth (ch 60) ] ]
        [ Html.Styled.fromUnstyled <|
            Markdown.toHtml [] description
        ]


photoDimensions =
    { width = 635
    , height = 375
    }


photoRatio =
    photoDimensions.height / photoDimensions.width


profileList : List Page.PeopleLink -> Html msg
profileList people =
    ul
        [ css (Style.listReset ++ Style.grid.context)
        ]
        (List.map listChild people)


listChild personRecord_ =
    li [ css Style.grid.twoColumnList ]
        [ profileCard personRecord_ ]


profileCard : Page.PeopleLink -> Html msg
profileCard person =
    a
        [ href person.url
        , css
            [ textDecoration none
            , display block
            , backgroundSize cover
            , backgroundPosition2 (pct 100) zero
            , backgroundImage (url person.image)
            , width (pct 100)
            , paddingBottom (pct (photoRatio * 100))
            , position relative
            ]
        ]
        [ span
            [ css
                ([ position absolute
                 , left Style.spacing.small
                 , top Style.spacing.small
                 ]
                    ++ Style.typography.highlightTitle
                )
            ]
            [ text person.name
            ]
        ]
