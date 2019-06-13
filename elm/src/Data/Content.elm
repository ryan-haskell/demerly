module Data.Content exposing (Content(..), decoder)

import Data.Homepage exposing (Homepage)
import Data.ProfileDetail exposing (ProfileDetail)
import Data.Settings exposing (Settings)
import Json.Decode as D exposing (Decoder)


type Content
    = Homepage Settings Homepage
    | ProfileDetail Settings ProfileDetail



-- TODO: Remember the order matters!


decoder : Decoder Content
decoder =
    D.oneOf
        [ page ProfileDetail Data.ProfileDetail.decoder
        , page Homepage Data.Homepage.decoder
        ]


page : (Settings -> a -> b) -> Decoder a -> Decoder b
page ctr decoder_ =
    D.map2 ctr
        (D.field "settings" Data.Settings.decoder)
        (D.field "page" decoder_)
