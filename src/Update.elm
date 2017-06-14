module Update exposing (update)

import RemoteData

import AWS.Lambda
import Message
import Model
import Model.Json as Json

update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    case msg of
        Message.FetchAstroData ->
            ( { model | astro = RemoteData.Loading }
              , AWS.Lambda.fetchAstroData (Json.encodeRequest model.request) )
        Message.FetchAstroDataSuccess strData ->
            case Json.decodeAstroData strData of
              Ok astroData -> ( { model | astro = RemoteData.Success astroData }, Cmd.none )
              Err error -> ( { model | astro = RemoteData.Failure (Model.BadPayload error) }, Cmd.none )
        Message.FetchAstroDataError error ->
            ( { model | astro = RemoteData.Failure (Model.BadStatus error) }, Cmd.none )
