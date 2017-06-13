module Update exposing (update)

import RemoteData

import Command
import Message
import Model

update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    case msg of
        Message.OnFetchAstroData response ->
            ( { model | astro = response }, Cmd.none )
        Message.QueryAstroData ->
            ( { model | astro = RemoteData.Loading }, Command.fetchAstroData model )
