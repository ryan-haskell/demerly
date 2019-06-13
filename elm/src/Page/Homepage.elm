module Page.Homepage exposing (Content, view)

import Application.Document exposing (Document)
import Data.Homepage as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Style


type alias Content =
    { page : Page.Homepage
    , settings : Settings
    }


view : Content -> Document msg
view content =
    { title = "Demerly Architects"
    , body =
        [ h1 [] [ text content.page.name ]
        , a [ Attr.href "/profile/mark-demerly" ] [ text "Mark Demerly" ]
        ]
    }
