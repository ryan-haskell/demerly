port module Ports exposing (jumpToTop)


port outgoing : () -> Cmd msg


jumpToTop : Cmd msg
jumpToTop =
    outgoing ()
