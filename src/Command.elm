module Command exposing (fetchAstroData)

import Http
import RemoteData
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Message
import Model

import Model

fetchAstroData : Cmd Message.Message
fetchAstroData =
  Http.post astroUrl (Http.jsonBody request) astroDataDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Message.OnFetchAstroData


request : Encode.Value
request = Encode.object
  [ ("coordinates", Encode.object
    [ ("latitude", Encode.float 51)
    , ("longitude", Encode.float 0)
    ])
    , ("datetime", Encode.string "2017-05-10T12:12:12.111111+01:00")
  ]

astroUrl : String
astroUrl = "https://nzribavfdd.execute-api.us-east-1.amazonaws.com/dev/astro/"


astroDataDecoder : Decode.Decoder (Model.AstroData)
astroDataDecoder = decode Model.AstroData
  |> required "sun" setRiseDecode


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable Decode.string) Nothing
  |> optional "set" (Decode.nullable Decode.string) Nothing
