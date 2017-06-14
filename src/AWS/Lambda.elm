port module AWS.Lambda exposing (..)

import Model

port fetchAstroData : String -> Cmd msg

port fetchAstroDataSuccess : (String -> msg) -> Sub msg

port fetchAstroDataError : (String -> msg) -> Sub msg
