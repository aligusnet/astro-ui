module View exposing (view)

import Html exposing (Html, div, text, program, button, input, h1, h2, h3, p)
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
import FormatNumber
import FormatNumber.Locales as NumberLocales

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
              [ button [ onClick Message.GetGeolocation ]
                       [ text "Get current geolocation" ]
              , p []
                  [text "Please use secure connection (https) to obtain your coordinates, otherwise it might not work"]
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
      [ h3 [] [ text "Sun" ], viewPlanetai astro.sun
      , h3 [] [ text "Moon" ], viewPlanetai astro.moon
      , h2 [] [ text "Planets" ]
      , h3 [] [ text "Mercury" ], viewPlanetai astro.mercury
      , h3 [] [ text "Venus" ], viewPlanetai astro.venus
      , h3 [] [ text "Mars" ], viewPlanetai astro.mars
      , h3 [] [ text "Jupiter" ], viewPlanetai astro.jupiter
      , h3 [] [ text "Saturn" ], viewPlanetai astro.saturn
      , h3 [] [ text "Uranus" ], viewPlanetai astro.uranus
      , h3 [] [ text "Neptune" ], viewPlanetai astro.neptune
      , h2 [] [ text "Stars" ]
      , h3 [] [ text "Polaris" ], viewStar astro.polaris
      , h3 [] [ text "Alpha Crucis" ], viewStar astro.alphaCrucis
      , h3 [] [ text "Sirius" ], viewStar astro.sirius
      ]


viewPlanetai : Model.Planetai -> Html Message.Message
viewPlanetai planetai =
  div []
      [ viewSetRise planetai.riseSet
      , viewDistance planetai.distance
      , viewAngularSize planetai.angularSize
      , viewHorizontalCoordinates planetai.position
      ]


viewStar : Model.Star -> Html Message.Message
viewStar star =
  div []
      [ viewSetRise star.riseSet
      , viewHorizontalCoordinates star.position
      ]


viewSetRise : Model.SetRise -> Html Message.Message
viewSetRise setRise =
  div []
      [ div []
            [ text "Rise: "
            , text (formatMaybeDateTime setRise.rise) ]
      , div []
            [ text "Rise Azimuth: "
            , text (formatMaybeDecimalDegrees setRise.riseAzimuth "--") ]
      , div []
            [ text "Set: "
            , text (formatMaybeDateTime setRise.set) ]
      , div []
            [ text "Set Azimuth: "
            , text (formatMaybeDecimalDegrees setRise.setAzimuth "--") ]
      , div []
            [ text "State: "
            , text setRise.state ]
      ]


viewDistance : Model.Distance -> Html Message.Message
viewDistance distance =
  div []
      [ text "Distance: "
      , text (formatNumber distance.value distance.units)
      ]


viewAngularSize : Float -> Html Message.Message
viewAngularSize = viewDecimalDegrees "Angular Size"


viewHorizontalCoordinates : Model.HorizonCoordinates -> Html Message.Message
viewHorizontalCoordinates hc =
  div []
      [ viewDecimalDegrees "Altitude" hc.altitude
      , viewDecimalDegrees "Azimuth" hc.azimuth
      ]


viewDecimalDegrees : String -> Float -> Html Message.Message
viewDecimalDegrees name dd =
  div []
      [ text (name ++ ": ")
      , text (formatDecimalDegrees dd)
      ]

formatMaybeDateTime : Maybe Date.Date -> String
formatMaybeDateTime mbDT =
  case mbDT of
    Just dt -> DateFormatter.format config "%d/%m/%Y %H:%M %z" dt
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
          , firstDayOfWeek = Date.Mon
          , autoClose = True
          , i18n = { defaultDateTimeI18n | inputFormat = customInputFormat }
       }


customDatePattern : String
customDatePattern = "%d/%m/%Y %H:%M"


formatNumber : Float -> String -> String
formatNumber n units =
  let str = FormatNumber.format NumberLocales.usLocale n
  in str ++ units



formatDecimalDegrees : Float -> String
formatDecimalDegrees df =
  let di = floor df
      mf = 60 * (df - toFloat di)
      mi = floor mf
      sf = 60 * (mf - toFloat mi)
  in (toString di) ++ "°"
      ++ (toString mi) ++ "′"
      ++ (formatNumber sf "″")


formatMaybeDecimalDegrees : Maybe Float -> String -> String
formatMaybeDecimalDegrees mbdd default =
  case mbdd of
    Just dd -> formatDecimalDegrees dd
    Nothing -> default


customInputFormat : DateTimePicker.Config.InputFormat
customInputFormat =
    { inputFormatter = DateFormatter.format config customDatePattern
    , inputParser = DateParser.parse config customDatePattern >> Result.toMaybe
    }
