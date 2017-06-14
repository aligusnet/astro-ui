module Model exposing (..)

import RemoteData
import Date


type Error = BadStatus String
            | BadPayload String


type alias SetRise =
  { rise: Maybe String
  , set: Maybe String
  }


type alias AstroData =
  { sun: SetRise }


type alias Model =
  { astro : RemoteData.RemoteData Error AstroData
  , request : AstroRequest
  }


type alias Coordinates =
  { latitude: Float
  , longitude: Float
  }


type alias AstroRequest =
  { coordinates: Coordinates
  , datetime: String
  }


defaultRequest : AstroRequest
defaultRequest =
  { coordinates = {latitude=51, longitude=0}
  , datetime = "2017-05-10T12:12:12.111111+01:00"
  }


initialModel : Model
initialModel = Model RemoteData.NotAsked defaultRequest
