module Data.Settings exposing (Link, Settings)


type alias Link =
    { label : String
    , url : String
    }


type alias Settings =
    { logo : String
    , links : List Link
    , address : String
    , phone : String
    , fax : String
    }
