port module AWS.Lambda exposing (..)

port fetchAstroData : String -> Cmd msg

port fetchAstroDataSuccess : (String -> msg) -> Sub msg

port fetchAstroDataError : (String -> msg) -> Sub msg
