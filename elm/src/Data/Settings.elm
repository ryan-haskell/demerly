module Data.Settings exposing (Settings, decoder, fallback)

import Json.Decode as D exposing (Decoder)


type alias Settings =
    { header : Header
    , footer : Footer
    }


type alias Header =
    { brand : String
    , logos : Logos
    , linkLabels : LinkLabels
    }


type alias Logos =
    { mobile : String
    , desktop : String
    }


type alias LinkLabels =
    { projects : String
    , process : String
    , profile : String
    , contact : String
    }


type alias Footer =
    { address : String
    , phone : String
    , fax : String
    }


decoder : Decoder Settings
decoder =
    D.map2 Settings
        (D.field "header" headerDecoder)
        (D.field "footer" footerDecoder)


headerDecoder : Decoder Header
headerDecoder =
    D.map3 Header
        (D.field "brand" D.string)
        (D.field "logos" logosDecoder)
        (D.field "linkLabels" linkLabelsDecoder)


logosDecoder : Decoder Logos
logosDecoder =
    D.map2 Logos
        (D.field "mobile" D.string)
        (D.field "desktop" D.string)


linkLabelsDecoder : Decoder LinkLabels
linkLabelsDecoder =
    D.map4 LinkLabels
        (D.field "projects" D.string)
        (D.field "process" D.string)
        (D.field "profile" D.string)
        (D.field "contact" D.string)


footerDecoder : Decoder Footer
footerDecoder =
    D.map3 Footer
        (D.field "address" D.string)
        (D.field "phone" D.string)
        (D.field "fax" D.string)



-- Fallback


fallback : Settings
fallback =
    Settings
        (Header
            "Demerly Architects"
            (Logos "/images/logo-mobile.svg" "/images/logo-desktop.png")
            (LinkLabels "Projects" "Process" "Profile" "Contact")
        )
        (Footer
            "6500 Westfield Boulevard / Indianapolis, IN 46220"
            "317.847.0724"
            "888.895.2811"
        )
