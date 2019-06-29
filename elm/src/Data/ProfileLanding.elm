module Data.ProfileLanding exposing
    ( PeopleLink
    , ProfileLanding
    , TeamSection
    , decoder
    )

import Json.Decode as D exposing (Decoder)


type alias ProfileLanding =
    { title : String
    , description : String
    , team : TeamSection
    }


type alias TeamSection =
    { title : String
    , people : List PeopleLink
    }


type alias PeopleLink =
    { name : String
    , url : String
    , image : String
    }


decoder : Decoder ProfileLanding
decoder =
    D.map3 ProfileLanding
        (D.field "title" D.string)
        (D.field "description" D.string)
        (D.field "team" teamSectionDecoder)


teamSectionDecoder : Decoder TeamSection
teamSectionDecoder =
    D.map2 TeamSection
        (D.field "title" D.string)
        (D.field "people" (D.list peopleLinkDecoder))


peopleLinkDecoder : Decoder PeopleLink
peopleLinkDecoder =
    D.map3 PeopleLink
        (D.field "name" D.string)
        (D.field "url" D.string)
        (D.field "image" D.string)
