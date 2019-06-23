module Page.ProfileLanding exposing (Content, view)

import Css exposing (..)
import Data.Settings exposing (Settings)
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Markdown
import Style


type alias Content =
    { settings : Settings
    }


view =
    { title = "Profile | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [ css Style.typography.title ] [ text "Profile Landing" ] ]
        , leadCopy
        , profileCard
        ]
    }


leadCopy : Html msg
leadCopy =
    div []
        [ text "Founded in 1999, Demerly Architects is an award-winning architecture firm that believes successful projects begin with a collaborative design process that identifies and explores our clients’ needs. We are great listeners, creative thinkers, and adept problem-solvers who put the art and science of architecture to work on our clients’ behalf. We engage in a dynamic relationship with our clients, exploring what is possible and refining the architectural solution across a diverse range of styles and needs in order to create or recreate a home."
        ]


photoDimensions =
    { width = 635
    , height = 375
    }


photoRatio =
    photoDimensions.height / photoDimensions.width


profileCard : Html msg
profileCard =
    a
        [ href "#0"
        , css
            [ textDecoration none
            , display block
            , backgroundSize cover
            , backgroundPosition2 (pct 100) zero
            , backgroundImage (url "/images/photo-mark2.jpg")
            , width (pct 100)
            , paddingBottom (pct (photoRatio * 100))
            ]
        ]
        [ span
            [ css
                [ position absolute
                , left Style.spacing.small
                , top Style.spacing.small
                ]
            ]
            [ text "mark Demerly"
            ]
        ]
