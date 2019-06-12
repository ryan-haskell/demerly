module Application.Document exposing
    ( Document
    , map
    )

import Html.Styled as Html exposing (Html)


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


map : (a -> b) -> Document a -> Document b
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }
