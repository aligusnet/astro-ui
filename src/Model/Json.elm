module Model.Json exposing (encodeRequest, decodeAstroData)

import Date
import Date.Extra.Format as DateFormat
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline exposing (decode, required, optional)

import Model


encodeRequest : Model.Model -> String
encodeRequest request = Encode.encode 0 (requestEncoder request)


requestEncoder : Model.Model -> Encode.Value
requestEncoder model = Encode.object
  [ ("coordinates", coordinatesEncoder model)
    , ("datetime", dateTimeEncoder model.datetime)
  ]


coordinatesEncoder : Model.Model -> Encode.Value
coordinatesEncoder model = Encode.object
  [ ("latitude", Encode.float model.latitude)
  , ("longitude", Encode.float model.longitude)
  ]


dateTimeEncoder : Date.Date -> Encode.Value
dateTimeEncoder date = Encode.string (DateFormat.isoString date)


decodeAstroData : String -> Result String Model.AstroData
decodeAstroData str = Decode.decodeString astroDataDecoder str


astroDataDecoder : Decode.Decoder (Model.AstroData)
astroDataDecoder = decode Model.AstroData
  |> required "request" requestDecoder
  |> required "sun" planetaiDecoder
  |> required "moon" planetaiDecoder
  |> required "mercury" planetaiDecoder
  |> required "venus" planetaiDecoder
  |> required "mars" planetaiDecoder
  |> required "jupiter" planetaiDecoder
  |> required "saturn" planetaiDecoder
  |> required "uranus" planetaiDecoder
  |> required "neptune" planetaiDecoder
  |> required "polaris" starDecoder
  |> required "alphaCrucis" starDecoder
  |> required "sirius" starDecoder
  |> required "betelgeuse" starDecoder
  |> required "rigel" starDecoder
  |> required "vega" starDecoder
  |> required "antares" starDecoder
  |> required "canopus" starDecoder
  |> required "pleiades" starDecoder


planetaiDecoder : Decode.Decoder (Model.Planetai)
planetaiDecoder = decode Model.Planetai
  |> required "riseSet" setRiseDecode
  |> required "distance" distanceDecoder
  |> required "angularSize" Decode.float
  |> required "position" horizontalCoordinatesDecoder


starDecoder : Decode.Decoder (Model.Star)
starDecoder = decode Model.Star
  |> required "starRiseSet" setRiseDecode
  |> required "starPosition" horizontalCoordinatesDecoder


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable DecodeExtra.date) Nothing
  |> optional "riseAzimuth" (Decode.nullable Decode.float) Nothing
  |> optional "set" (Decode.nullable DecodeExtra.date) Nothing
  |> optional "setAzimuth" (Decode.nullable Decode.float) Nothing
  |> required "state" Decode.string


distanceDecoder : Decode.Decoder (Model.Distance)
distanceDecoder = decode Model.Distance
  |> required "value" Decode.float
  |> required "units" Decode.string


horizontalCoordinatesDecoder : Decode.Decoder (Model.HorizonCoordinates)
horizontalCoordinatesDecoder = decode Model.HorizonCoordinates
  |> required "altitude" Decode.float
  |> required "azimuth" Decode.float


requestDecoder : Decode.Decoder (Model.Request)
requestDecoder = decode Model.Request
  |> required "coordinates" geoCoordinatesDecoder
  |> required "datetime" DecodeExtra.date


geoCoordinatesDecoder : Decode.Decoder (Model.GeoCoordinates)
geoCoordinatesDecoder = decode Model.GeoCoordinates
  |> required "latitude" Decode.float
  |> required "longitude" Decode.float
