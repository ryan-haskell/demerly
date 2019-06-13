module Data.Content exposing (Content(..), decoder)

import Data.Page.Homepage exposing (Homepage)
import Data.Page.ProfileDetail exposing (ProfileDetail)
import Data.Settings exposing (Settings)
import Json.Decode as D exposing (Decoder)


type Content
    = Homepage Settings Homepage
    | ProfileDetail Settings ProfileDetail



-- TODO: Remember the order matters!


decoder : Decoder Content
decoder =
    D.oneOf
        [ page ProfileDetail Data.Page.ProfileDetail.decoder
        , page Homepage Data.Page.Homepage.decoder
        ]


page : (Settings -> a -> b) -> Decoder a -> Decoder b
page ctr decoder_ =
    D.map2 ctr
        (D.field "settings" Data.Settings.decoder)
        (D.field "page" decoder_)
