module Model exposing (..)

import RemoteData exposing (WebData)

type alias SetRise =
  { rise: Maybe String
  , set: Maybe String
  }

type alias AstroData =
  { sun: SetRise }

type alias Model =
  { astro : WebData AstroData
  }

initialModel : Model
initialModel = Model RemoteData.NotAsked
