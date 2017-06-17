module Update exposing (update)

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
        Message.LatitudeChange strLat ->
            case parseLatitude strLat of
              Ok latitude -> ( { model | latitude = latitude }, Cmd.none)
              Err _ -> ( model, Cmd.none )
        Message.LongitudeChange strLong ->
            case parseLongitude strLong of
              Ok longitude -> ( { model | longitude = longitude }, Cmd.none)
              Err _ -> ( model, Cmd.none )
        Message.GetGeolocation ->
              ( model, Command.getGeolocation )
        Message.GetGeolocationSuccess location ->
          ( { model | latitude = location.latitude, longitude = location.longitude }, Cmd.none )
        Message.GetGeolocationError error ->
          ( model, Cmd.none )


parseLatitude : String -> Result String Float
parseLatitude str =
  case String.toFloat str of
    Ok value -> if (value <= 90) && (value >= -90)
                then Ok value
                else Err "latitude mast be between -90 and 90"
    Err error -> Err error


parseLongitude : String -> Result String Float
parseLongitude str =
  case String.toFloat str of
    Ok value -> if (value <= 180) && (value >= -180)
                then Ok value
                else Err "longitude mast be between -180 and 180"
    Err error -> Err error
