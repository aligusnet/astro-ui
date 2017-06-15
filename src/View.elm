module View exposing (view)

import Html exposing (Html, div, text, program, button)
import Html.Events exposing (onClick)
import RemoteData
import DateTimePicker
import DateTimePicker.Config exposing (Config, DatePickerConfig
                                      , TimePickerConfig
                                      , defaultDateTimePickerConfig
                                      , defaultDateTimeI18n)
import Date.Extra.Format
import Date.Extra.Config.Config_en_gb exposing (config)
import DateParser


import Model
import Message

view : Model.Model -> Html Message.Message
view model =
    div []
        [ div []
              [ button [ onClick Message.FetchAstroData ]
                       [ text "Query" ]
              ]
        , div []
              [ button [ onClick Message.RequestCurrentDate ]
                       [ text "Now" ]
              ]
        , div []
              [ viewDateTimePicker model ]
        , div []
              [ viewRemoteAstroData model.astro ]
        ]


viewRemoteAstroData : Model.RemoteAstroData -> Html Message.Message
viewRemoteAstroData rad = case rad of
    RemoteData.NotAsked -> text "Please request for astro data"
    RemoteData.Loading -> text "Please wait, astro data is loading..."
    RemoteData.Failure err -> text ("Error: " ++ toString err)
    RemoteData.Success astro -> viewAstroData astro


viewAstroData : Model.AstroData -> Html Message.Message
viewAstroData astro = text (toString astro)


viewDateTimePicker : Model.Model -> Html Message.Message
viewDateTimePicker model =
  DateTimePicker.dateTimePickerWithConfig
    dateTimePickerConfig
    [ ]
    model.datePickerState
    (Just model.datetime)


dateTimePickerConfig : Config (DatePickerConfig TimePickerConfig) Message.Message
dateTimePickerConfig =
    let defaultDateTimeConfig =
            defaultDateTimePickerConfig Message.DateChange
    in { defaultDateTimeConfig
          | timePickerType = DateTimePicker.Config.Analog
          , allowYearNavigation = True
          , i18n = { defaultDateTimeI18n | inputFormat = customInputFormat }
       }


customDatePattern : String
customDatePattern = "%d/%m/%Y %H:%M"


customInputFormat : DateTimePicker.Config.InputFormat
customInputFormat =
    { inputFormatter = Date.Extra.Format.format config customDatePattern
    , inputParser = DateParser.parse config customDatePattern >> Result.toMaybe
    }
