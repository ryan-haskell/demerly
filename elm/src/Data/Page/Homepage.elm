module Data.Page.Homepage exposing (Homepage, decoder)

import Json.Decode as D exposing (Decoder)


type alias Homepage =
    { name : String
    }


decoder : Decoder Homepage
decoder =
    D.map Homepage
        (D.field "name" D.string)
