module View exposing (view)

import Html exposing (Html, div, text, program, button, input, h1, h2)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attr
import RemoteData
import Date
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
    div []
        [ h1 [] [ text "Astro" ]
        , div []
              [ button [ onClick Message.RequestCurrentDate ]
                       [ text "Now" ]
              ]
        , div []
              [ viewDateTimePicker model ]
        , div []
              [ text "latitude:"
              , input [ Attr.type_ "number"
                      , Attr.max "90.0"
                      , Attr.min "-90.0"
                      , Attr.value (toString model.latitude)
                      , onInput Message.LatitudeChange
                      ]
                      [ text (toString model.latitude) ]
              ]
          , div []
                [ text "longitude:"
                , input [ Attr.type_ "number"
                        , Attr.max "180.0"
                        , Attr.min "-180.0"
                        , Attr.value (toString model.longitude)
                        , onInput Message.LongitudeChange
                        ]
                        [ text (toString model.latitude) ]
                ]
        , div []
              [ button [ onClick Message.FetchAstroData ]
                       [ text "Query" ]
              ]
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
viewAstroData astro =
  div []
      [ h2 [] [ text "Sun" ]
      , viewSetRise astro.sun
      ]


viewSetRise : Model.SetRise -> Html Message.Message
viewSetRise setRise =
  div []
      [ div []
            [ text "Rise: "
            , text (formatMaybeDateTime setRise.rise) ]
      , div []
            [ text "Set: "
            , text (formatMaybeDateTime setRise.set) ]
      , div []
            [ text "Please note that rise and set are shown in your local time for the given date."]
      ]


formatMaybeDateTime : Maybe Date.Date -> String
formatMaybeDateTime mbDT =
  case mbDT of
    Just dt -> DateFormatter.format config customDatePattern dt
    Nothing -> "--"


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
    { inputFormatter = DateFormatter.format config customDatePattern
    , inputParser = DateParser.parse config customDatePattern >> Result.toMaybe
    }
