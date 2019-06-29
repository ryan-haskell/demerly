module Data.Content exposing (Content(..), decoder)

import Data.GeneralContent exposing (GeneralContent)
import Data.Homepage exposing (Homepage)
import Data.ProfileDetail exposing (ProfileDetail)
import Data.ProfileLanding exposing (ProfileLanding)
import Data.ProjectsDetail exposing (ProjectsDetail)
import Data.ProjectsLanding exposing (ProjectsLanding)
import Data.Settings exposing (Settings)
import Json.Decode as D exposing (Decoder)


type Content
    = Homepage Settings Homepage
    | ProfileLanding Settings ProfileLanding
    | ProfileDetail Settings ProfileDetail
    | ProjectsLanding Settings ProjectsLanding
    | ProjectsDetail Settings ProjectsDetail
    | GeneralContent Settings GeneralContent
    | OnlySettings Settings


decoder : Decoder Content
decoder =
    D.oneOf
        [ page ProfileLanding Data.ProfileLanding.decoder
        , page ProfileDetail Data.ProfileDetail.decoder
        , page ProjectsDetail Data.ProjectsDetail.decoder
        , page ProjectsLanding Data.ProjectsLanding.decoder
        , page GeneralContent Data.GeneralContent.decoder
        , page Homepage Data.Homepage.decoder
        , D.map OnlySettings
            (D.field "settings" Data.Settings.decoder)
        ]


page : (Settings -> pageModel -> Content) -> Decoder pageModel -> Decoder Content
page ctr pageDecoder =
    D.map2 ctr
        (D.field "settings" Data.Settings.decoder)
        (D.field "page" pageDecoder)
