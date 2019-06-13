module Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string, top)


type Route
    = Homepage
    | ProfileLanding
    | ProfileDetail String
    | NotFound


router : Parser (Route -> a) a
router =
    Parser.oneOf
        [ Parser.map Homepage top
        , Parser.map ProfileLanding (s "profile")
        , Parser.map ProfileDetail (s "profile" </> string)
        ]


fromUrl : Url -> Route
fromUrl =
    Parser.parse router >> Maybe.withDefault NotFound


toString : Route -> String
toString route =
    case route of
        Homepage ->
            "/"

        ProfileLanding ->
            "/profile"

        ProfileDetail slug ->
            "/profile/" ++ slug

        NotFound ->
            "/not-found"
