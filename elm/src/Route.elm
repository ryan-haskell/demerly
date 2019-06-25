module Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string, top)


type Route
    = Homepage
    | ProjectsLanding
    | ProjectsDetail String
    | ProcessLanding
    | ProfileLanding
    | ProfileDetail String
    | ContactLanding
    | NotFound


router : Parser (Route -> a) a
router =
    Parser.oneOf
        [ Parser.map Homepage top
        , Parser.map ProjectsLanding (s "projects")
        , Parser.map (always ProjectsDetail) (s "projects" </> string </> string)
        , Parser.map ProcessLanding (s "process")
        , Parser.map ProfileLanding (s "profile")
        , Parser.map ProfileDetail (s "profile" </> string)
        , Parser.map ContactLanding (s "contact")
        ]


fromUrl : Url -> Route
fromUrl =
    Parser.parse router >> Maybe.withDefault NotFound


toString : Route -> String
toString route =
    case route of
        Homepage ->
            "/"

        ProjectsLanding ->
            "/projects"

        ProjectsDetail slug ->
            "/projects/" ++ slug

        ProcessLanding ->
            "/process"

        ProfileLanding ->
            "/profile"

        ProfileDetail slug ->
            "/profile/" ++ slug

        ContactLanding ->
            "/contact"

        NotFound ->
            "/not-found"
