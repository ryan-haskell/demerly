module Data.ProfileDetail exposing (ProfileDetail, decoder)

import Json.Decode as D exposing (Decoder)


type alias ProfileDetail =
    { name : String
    , image : Maybe String
    , credentials : Maybe String
    , position : Maybe String
    , email : Maybe String
    , phone : Maybe String
    , fax : Maybe String
    , bio : String
    }


decoder : Decoder ProfileDetail
decoder =
    D.map8 ProfileDetail
        (D.field "name" D.string)
        (D.maybe (D.field "image" D.string))
        (D.maybe (D.field "credentials" D.string))
        (D.maybe (D.field "position" D.string))
        (D.maybe (D.field "email" D.string))
        (D.maybe (D.field "phone" D.string))
        (D.maybe (D.field "fax" D.string))
        (D.field "bio" D.string)
