module Message exposing (..)

import RemoteData exposing (WebData)

import Model exposing (AstroData)

type Message = OnFetchAstroData (WebData AstroData) | QueryAstroData
