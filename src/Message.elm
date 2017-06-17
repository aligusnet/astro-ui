module Message exposing (..)

import DateTimePicker
import Date

type Message = FetchAstroData
              | FetchAstroDataSuccess String
              | FetchAstroDataError String
              | DateChange DateTimePicker.State (Maybe Date.Date)
              | RequestCurrentDate
              | ReceiveCurrentDate Date.Date
              | LatitudeChange String
              | LongitudeChange String
              | GetGeolocation
              | GetGeolocationSuccess {latitude: Float, longitude: Float}
              | GetGeolocationError String
