module Page.ProjectsDetail exposing (Content, view)

import Application.Document exposing (Document)
import Css exposing (..)
import Data.ProjectsDetail as Page
import Data.Settings exposing (Settings)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, css, src)
import Style


type alias Content =
    { settings : Settings
    , page : Page.ProjectsDetail
    }


view : Content -> Document msg
view { page } =
    { title = "Some Project | Projects | Demerly Architects"
    , body =
        [ div
            [ css Style.styles.container
            , css [ padding2 zero Style.spacing.small ]
            ]
            [ h1 [] [ text page.title ]
            , p []
                [ text page.year
                , text " – "
                , text page.type_
                , text ", "
                , text page.location
                ]
            , div []
                (List.map (\url -> img [ src url, alt page.title ] [])
                    page.images
                )
            ]
        ]
    }
