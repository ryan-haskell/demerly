module Page.NotFound exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Style


view =
    { title = "Not Found | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text "Page not found" ] ]
        ]
    }
