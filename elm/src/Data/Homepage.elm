module Data.Homepage exposing (Homepage, Slide, decoder)

import Json.Decode as D exposing (Decoder)


type alias Homepage =
    { slides : List Slide
    }


type alias Slide =
    { title : String
    , slug : String
    , image : String
    , details : String
    }


decoder : Decoder Homepage
decoder =
    D.map Homepage
        (D.field "slides" (D.list slideDecoder))


slideDecoder : Decoder Slide
slideDecoder =
    D.map4 Slide
        (D.field "title" D.string)
        (D.field "slug" D.string)
        (D.field "image" D.string)
        (D.field "details" D.string)
