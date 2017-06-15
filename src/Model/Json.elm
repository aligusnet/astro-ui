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
  |> required "sun" setRiseDecode


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable DecodeExtra.date) Nothing
  |> optional "set" (Decode.nullable DecodeExtra.date) Nothing
