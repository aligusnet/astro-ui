module Command exposing (fetchAstroData)

import Http
import RemoteData
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Message
import Model


fetchAstroData : Model.Model -> Cmd Message.Message
fetchAstroData model =
  Http.post astroUrl (Http.jsonBody (encodeRequest model.request)) astroDataDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Message.OnFetchAstroData


encodeRequest : Model.AstroRequest -> Encode.Value
encodeRequest request = Encode.object
  [ ("coordinates", encodeCoordinates request.coordinates)
    , ("datetime", encodeDateTime request.datetime)
  ]


encodeCoordinates : Model.Coordinates -> Encode.Value
encodeCoordinates coords = Encode.object
  [ ("latitude", Encode.float coords.latitude)
  , ("longitude", Encode.float coords.longitude)
  ]


encodeDateTime : String -> Encode.Value
encodeDateTime dt = Encode.string dt


astroUrl : String
astroUrl = "https://nzribavfdd.execute-api.us-east-1.amazonaws.com/dev/astro/"


astroDataDecoder : Decode.Decoder (Model.AstroData)
astroDataDecoder = decode Model.AstroData
  |> required "sun" setRiseDecode


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable Decode.string) Nothing
  |> optional "set" (Decode.nullable Decode.string) Nothing
