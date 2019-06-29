module Data.ProjectsLanding exposing
    ( FilterSettings
    , ProjectLink
    , ProjectsLanding
    , decoder
    )

import Json.Decode as D exposing (Decoder)


type alias ProjectsLanding =
    { title : String
    , description : String
    , filters : FilterSettings
    , projects : List ProjectLink
    }


type alias FilterSettings =
    { label : String
    , allLabel : String
    }


type alias ProjectLink =
    { name : String
    , image : String
    , url : String
    }


decoder : Decoder ProjectsLanding
decoder =
    D.map4 ProjectsLanding
        (D.field "title" D.string)
        (D.field "description" D.string)
        (D.field "filters" filterSettingsDecoder)
        (D.field "projects" (D.list projectLinkDecoder))


filterSettingsDecoder =
    D.map2 FilterSettings
        (D.field "label" D.string)
        (D.field "allLabel" D.string)


projectLinkDecoder =
    D.map3 ProjectLink
        (D.field "name" D.string)
        (D.field "image" D.string)
        (D.field "url" D.string)
