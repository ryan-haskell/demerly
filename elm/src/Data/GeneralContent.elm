module Data.GeneralContent exposing (GeneralContent, decoder)

import Json.Decode as D exposing (Decoder)


type alias GeneralContent =
    { title : String
    , description : String
    , content : String
    , image : String
    }


decoder : Decoder GeneralContent
decoder =
    D.map4 GeneralContent
        (D.field "title" D.string)
        (D.field "description" D.string)
        (D.field "content" D.string)
        (D.field "image" D.string)
