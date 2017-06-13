module Update exposing (update)

import RemoteData

import AWS.Lambda
import Message
import Model

update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    case msg of
        Message.FetchAstroData ->
            ( { model | astro = RemoteData.Loading }, AWS.Lambda.fetchAstroData model.request )
        Message.FetchAstroDataSuccess astroData ->
            ( { model | astro = RemoteData.Success astroData }, Cmd.none )
        Message.FetchAstroDataError error ->
            ( { model | astro = RemoteData.Failure error }, Cmd.none )
