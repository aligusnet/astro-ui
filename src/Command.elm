module Command exposing (..)

import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Message
import Model

import Model

fetchAstroData : Cmd Message.Message
fetchAstroData =
  Http.get astroUrl astroDataDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Message.OnFetchAstroData


astroUrl : String
astroUrl = "https://nzribavfdd.execute-api.us-east-1.amazonaws.com/dev/astro/"


astroDataDecoder : Decode.Decoder (Model.AstroData)
astroDataDecoder = decode Model.AstroData
  |> required "sun" setRiseDecode


setRiseDecode : Decode.Decoder (Model.SetRise)
setRiseDecode = decode Model.SetRise
  |> optional "rise" (Decode.nullable Decode.string) Nothing
  |> optional "set" (Decode.nullable Decode.string) Nothing
