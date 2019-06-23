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
        [ viewSlides content.page
        ]
    }


viewSlides : Page.Homepage -> Html msg
viewSlides page =
    div
        [ css
            []
        ]
        (List.map viewSlide page.slides)


viewSlide : Page.Slide -> Html msg
viewSlide slide =
    div
        [ css
            [ height (vh 70)
            , position relative
            , backgroundColor Style.colors.dark
            , color Style.colors.white
            , backgroundPosition center
            , backgroundSize cover
            , backgroundImage (url slide.image)
            ]
        ]
        [ div
            [ css
                [ position absolute
                , top zero
                , left zero
                , right zero
                , bottom zero
                , zIndex (int 1)
                , backgroundImage
                    (linearGradient2 toBottom (stop (rgba 0 0 0 0)) (stop (rgba 0 0 0 0.7)) [])
                ]
            ]
            []
        , div
            [ css
                [ position absolute
                , bottom (rem 1)
                , left (rem 1)
                , zIndex (int 2)
                ]
            , css Style.typography.link
            ]
            [ text slide.title ]
        ]
