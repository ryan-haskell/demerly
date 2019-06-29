module Data.GeneralContent exposing (GeneralContent, decoder)

import Json.Decode as D exposing (Decoder)


-- TODO: 1. Implement the type
type alias GeneralContent =
    { name : String
    }

-- TODO: 2. Implement the decoder
decoder : Decoder GeneralContent
decoder =
    D.succeed
        (GeneralContent "Rene")
