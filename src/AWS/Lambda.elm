port module AWS.Lambda exposing (..)

import Model

port fetchAstroData : Model.AstroRequest -> Cmd msg

port fetchAstroDataSuccess : (Model.AstroData -> msg) -> Sub msg

port fetchAstroDataError : (String -> msg) -> Sub msg
