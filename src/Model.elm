module Model exposing (..)

import Date
import RemoteData
import DateTimePicker


type Error = BadStatus String
            | BadPayload String


type alias SetRise =
  { rise: Maybe Date.Date
  , set: Maybe Date.Date
  , state: String
  }


type alias AstroData =
  { sun: SetRise
  , moon: SetRise
  , mercury: SetRise
  , venus: SetRise
  , mars: SetRise
  , jupiter: SetRise
  , saturn: SetRise
  , uranus: SetRise
  , neptune: SetRise
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
