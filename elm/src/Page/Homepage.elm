module Page.Homepage exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.Homepage as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Style


type alias Content =
    { page : Page.Homepage
    , settings : Settings
    }


view : Content -> Document msg
view content =
    { title = "Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text "Pages" ]
            , ul []
                [ li []
                    [ a [ Attr.href "/profile/mark-demerly" ] [ text "Profile Detail - Mark Demerly" ]
                    ]
                ]
            ]
        ]
    }
