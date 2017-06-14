module Model.Json exposing (encodeRequest, decodeAstroData)

import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline exposing (decode, required, optional)
import Model


encodeRequest : Model.AstroRequest -> String
encodeRequest request = Encode.encode 0 (requestEncoder request)


requestEncoder : Model.AstroRequest -> Encode.Value
requestEncoder request = Encode.object
  [ ("coordinates", coordinatesEncoder request.coordinates)
    , ("datetime", dateTimeEncoder request.datetime)
  ]


coordinatesEncoder : Model.Coordinates -> Encode.Value
coordinatesEncoder coords = Encode.object
  [ ("latitude", Encode.float coords.latitude)
  , ("longitude", Encode.float coords.longitude)
  ]


dateTimeEncoder : String -> Encode.Value
dateTimeEncoder dt = Encode.string dt


decodeAstroData : String -> Result String Model.AstroData
decodeAstroData str = Decode.decodeString astroDataDecoder str


astroDataDecoder : Decode.Decoder (Model.AstroData)
astroDataDecoder = decode Model.AstroData
  |> required "sun" setRiseDecode


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable DecodeExtra.date) Nothing
  |> optional "set" (Decode.nullable DecodeExtra.date) Nothing
