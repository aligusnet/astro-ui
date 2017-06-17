port module Geolocation exposing (..)

port getPosition : () -> Cmd msg

port getPositionSuccess : ({latitude: Float, longitude: Float} -> msg) -> Sub msg

port getPositionError : (String -> msg) -> Sub msg
