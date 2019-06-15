module Page.ContactLanding exposing (Content, view)

import Css exposing (..)
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Style


type alias Content =
    { settings : Settings
    }


view =
    { title = "Contact | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text "Contact Landing" ] ]
        ]
    }
