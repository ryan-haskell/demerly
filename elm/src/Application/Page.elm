module Application.Page exposing (static)

import Html.Styled exposing (Html)


type Page
    = Page


static :
    { title : content -> String
    , view : content -> Html msg
    }
    -> Page
static { title, view } =
    Page
