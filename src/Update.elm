module Update exposing (update)

import Date
import RemoteData

import Command
import Message
import Model
import Model.Json as Json

update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    case msg of
        Message.FetchAstroData ->
            ( { model | astro = RemoteData.Loading }
            , Command.fetchAstroData model )
        Message.FetchAstroDataSuccess strData ->
            case Json.decodeAstroData strData of
              Ok astroData -> ( { model | astro = RemoteData.Success astroData }, Cmd.none )
              Err error -> ( { model | astro = RemoteData.Failure (Model.BadPayload error) }, Cmd.none )
        Message.FetchAstroDataError error ->
            ( { model | astro = RemoteData.Failure (Model.BadStatus error) }, Cmd.none )
        Message.DateChange datePickerState selectedDate ->
          case selectedDate of
            Just date -> ( { model | datetime = date, datePickerState = datePickerState }, Cmd.none )
            Nothing -> ( model, Cmd.none )
        Message.RequestCurrentDate ->
            ( model, Command.receiveCurrentDate )
        Message.ReceiveCurrentDate date ->
            ( { model | datetime = date }, Cmd.none)
