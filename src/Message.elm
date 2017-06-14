module Message exposing (..)

import RemoteData exposing (WebData)

import Model exposing (AstroData)

type Message = FetchAstroData
              | FetchAstroDataSuccess String
              | FetchAstroDataError String
