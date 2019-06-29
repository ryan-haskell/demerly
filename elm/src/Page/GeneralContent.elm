module Page.GeneralContent exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.GeneralContent as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Style


type alias Content =
    { settings : Settings
    , page : Page.GeneralContent
    }


view : Content -> Document msg
view { page } =
    { title = page.title ++ " | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text page.title ] ]
        ]
    }
