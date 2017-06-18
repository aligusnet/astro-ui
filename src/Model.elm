module Model exposing (..)

import Date
import RemoteData
import DateTimePicker


type Error = BadStatus String
            | BadPayload String


type alias Planetai =
  { riseSet: SetRise
  , distance: Distance
  , angularSize: Float
  , position: HorizonCoordinates
  }


type alias Star =
  { riseSet: SetRise
  , position: HorizonCoordinates
  }

type alias Distance =
  { value: Float
  , units: String
  }


type alias HorizonCoordinates =
  { altitude: Float
  , azimuth: Float
  }

type alias SetRise =
  { rise: Maybe Date.Date
  , riseAzimuth: Maybe Float
  , set: Maybe Date.Date
  , setAzimuth: Maybe Float
  , state: String
  }

type alias GeoCoordinates =
  { latitude: Float
  , longitude: Float
  }

type alias Request =
  { coordinates: GeoCoordinates
  , datetime: Date.Date
  }

type alias AstroData =
  { request: Request
  , sun: Planetai
  , moon: Planetai
  , mercury: Planetai
  , venus: Planetai
  , mars: Planetai
  , jupiter: Planetai
  , saturn: Planetai
  , uranus: Planetai
  , neptune: Planetai
  , polaris: Star
  , alphaCrucis: Star
  , sirius: Star
  , betelgeuse: Star
  , rigel: Star
  , vega: Star
  , antares: Star
  , canopus: Star
  , pleiades: Star
  }


type alias RemoteAstroData = RemoteData.RemoteData Error AstroData


type alias Model =
  { astro : RemoteAstroData
  , latitude: Float
  , longitude: Float
  , datetime : Date.Date
  , datePickerState : DateTimePicker.State
  }


initialModel : Model
initialModel =
  { astro = RemoteData.NotAsked
  -- coordinates of Royal Observatory, Greenwich:
  , latitude=51.4769
  , longitude=0.0005
  -- Grandma's birthday
  , datetime = Date.fromTime (-1563105600000)
  , datePickerState = DateTimePicker.initialState
  }
