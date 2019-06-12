module Data.Content exposing (Content(..), decoder)

import Data.Page.ProfileDetail exposing (ProfileDetail)
import Data.Settings exposing (Settings)
import Json.Decode as D exposing (Decoder)


type Content
    = ProfileDetail Settings ProfileDetail


decoder : Decoder Content
decoder =
    D.oneOf
        [ profileDetailDecoder
        ]


profileDetailDecoder : Decoder Content
profileDetailDecoder =
    D.map2 ProfileDetail
        (D.field "settings" Data.Settings.decoder)
        (D.field "page" Data.Page.ProfileDetail.decoder)
