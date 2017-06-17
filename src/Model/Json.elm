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
  |> required "sun" planetaiDecoder
  |> required "moon" planetaiDecoder
  |> required "mercury" planetaiDecoder
  |> required "venus" planetaiDecoder
  |> required "mars" planetaiDecoder
  |> required "jupiter" planetaiDecoder
  |> required "saturn" planetaiDecoder
  |> required "uranus" planetaiDecoder
  |> required "neptune" planetaiDecoder


planetaiDecoder : Decode.Decoder (Model.Planetai)
planetaiDecoder = decode Model.Planetai
  |> required "riseSet" setRiseDecode
  |> required "distance" distanceDecoder
  |> required "angularSize" Decode.float
  |> required "position" horizontalCoordinatesDecoder


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable DecodeExtra.date) Nothing
  |> optional "set" (Decode.nullable DecodeExtra.date) Nothing
  |> required "state" Decode.string


distanceDecoder : Decode.Decoder (Model.Distance)
distanceDecoder = decode Model.Distance
  |> required "value" Decode.float
  |> required "units" Decode.string

horizontalCoordinatesDecoder : Decode.Decoder (Model.HorizonCoordinates)
horizontalCoordinatesDecoder = decode Model.HorizonCoordinates
  |> required "altitude" Decode.float
  |> required "azimuth" Decode.float
