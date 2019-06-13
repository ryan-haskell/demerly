module Page.NotFound exposing (view)

import Html.Styled exposing (..)


view =
    { title = "Not Found | Demerly Architects"
    , body = [ h1 [] [ text "Page not found." ] ]
    }
