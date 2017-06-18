module View.DateTimePicker exposing (view)

import Date
import Html exposing (Html)
import DateTimePicker
import DateTimePicker.Config exposing (Config, DatePickerConfig
                                      , TimePickerConfig
                                      , defaultDateTimePickerConfig
                                      , defaultDateTimeI18n)
import Date.Extra.Format as DateFormatter
import Date.Extra.Config.Config_en_gb exposing (config)
import DateParser

import Model
import Message


view : Model.Model -> Html Message.Message
view model =
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
          , firstDayOfWeek = Date.Mon
          , autoClose = True
          , i18n = { defaultDateTimeI18n | inputFormat = customInputFormat }
       }


customDatePattern : String
customDatePattern = "%d/%m/%Y %H:%M"


customInputFormat : DateTimePicker.Config.InputFormat
customInputFormat =
    { inputFormatter = DateFormatter.format config customDatePattern
    , inputParser = DateParser.parse config customDatePattern >> Result.toMaybe
    }
