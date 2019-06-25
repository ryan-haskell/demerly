module Data.ProjectDetail exposing (ProjectDetail, decoder)

import Json.Decode as D exposing (Decoder)


type alias ProjectDetail =
    { title : String
    , type_ : String
    , images : List String
    , details : String
    , year : String
    , location : String
    }


decoder : Decoder ProjectDetail
decoder =
    D.map6 ProjectDetail
        (D.field "title" D.string)
        (D.field "type" D.string)
        (D.field "images" (D.list D.string))
        (D.field "details" D.string)
        (D.field "year" D.string)
        (D.field "location" D.string)
