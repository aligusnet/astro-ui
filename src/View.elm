module View exposing (view)

import Html exposing (Html, div, text, program, button, input, h1, h2, h3, p, section)
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
    div [ Attr.class "wrapper" ]
        [ h1 [] [ text "Astro" ]
        , viewControlBlock model

        , div []
              [ viewRemoteAstroData model.astro ]
        ]

viewControlBlock : Model.Model -> Html Message.Message
viewControlBlock model =
  div [ Attr.class "control-block" ]
      [ viewDateTimeControl model
      , viewLatitudeControl model
      , viewLongitudeControl model
      , viewGeoLocationControl
      , div [ Attr.id "query-data" ]
            [ button [ onClick Message.FetchAstroData ]
                     [ text "Query" ]
            ]
      ]


viewDateTimeControl : Model.Model -> Html Message.Message
viewDateTimeControl model =
  div [ Attr.class "property-row", Attr.id "datetime-control" ]
      [ div [ Attr.class "property-name"]
            [ text "Date & Time" ]
      , div [ Attr.class "property-value"]
            [ viewDateTimePicker model ]
      ]

viewLatitudeControl : Model.Model -> Html Message.Message
viewLatitudeControl model =
  div [ Attr.class "property-row" ]
      [ div [ Attr.class "property-name"]
            [ text "Latitude" ]
      , div [ Attr.class "property-value"]
            [ input [ Attr.type_ "number"
                    , Attr.max "90.0"
                    , Attr.min "-90.0"
                    , Attr.value (toString model.latitude)
                    , onInput Message.LatitudeChange
                    ]
                    [ text (toString model.latitude) ]
            ]
      ]


viewLongitudeControl : Model.Model -> Html Message.Message
viewLongitudeControl model =
  div [ Attr.class "property-row" ]
      [ div [ Attr.class "property-name" ]
            [ text "Longitude" ]
      , div [ Attr.class "property-value" ]
            [ input [ Attr.type_ "number"
                    , Attr.max "180.0"
                    , Attr.min "-180.0"
                    , Attr.value (toString model.longitude)
                    , onInput Message.LongitudeChange
                    ]
                    [ text (toString model.longitude) ]
            ]
      ]


viewGeoLocationControl : Html Message.Message
viewGeoLocationControl =
  div [ Attr.id "geo-location" ]
      [ div [ ]
            [ button [ onClick Message.GetGeolocation ]
                     [ text "Get current geolocation" ]
            ]
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
      [ viewSunMoon astro
      , viewPlanets astro
      , viewStars astro
      ]


viewSunMoon : Model.AstroData -> Html Message.Message
viewSunMoon astro =
  div []
          [ div [ Attr.class "astro-list wrapper" ]
                [ viewPlanetai "Sun" astro.sun
                , viewPlanetai "Moon" astro.moon
                ]
          ]

viewPlanets : Model.AstroData -> Html Message.Message
viewPlanets astro =
  div []
          [ div [ Attr.class "astro-list-name" ]
                [ h2 [] [ text "Planets" ] ]
          , div [ Attr.class "astro-list wrapper" ]
                [ viewPlanetai "Mercury" astro.mercury
                , viewPlanetai "Venus" astro.venus
                , viewPlanetai "Mars" astro.mars
                , viewPlanetai "Jupiter" astro.jupiter
                , viewPlanetai "Saturn" astro.saturn
                , viewPlanetai "Uranus" astro.uranus
                , viewPlanetai "Neptune" astro.neptune
                ]
          ]

viewStars : Model.AstroData -> Html Message.Message
viewStars astro =
  div []
          [ div [ Attr.class "astro-list-name" ]
                [ h2 [] [ text "Stars" ] ]
          , div [ Attr.class "astro-list wrapper" ]
                [ viewStar "Polaris" astro.polaris
                , viewStar "Alpha Crucis" astro.alphaCrucis
                , viewStar "Sirius" astro.sirius
                , viewStar "Betelgeuse" astro.betelgeuse
                , viewStar "Rigel" astro.rigel
                , viewStar "Vega" astro.vega
                , viewStar "Antares" astro.antares
                , viewStar "Canopus" astro.canopus
                , viewStar "Pleiades" astro.pleiades
                ]
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


type alias Property =
  { name : String
  , value : String
  }


viewPlanetai : String -> Model.Planetai -> Html Message.Message
viewPlanetai caption planetai =
  let props = appendPlanetaiProperties planetai []
      formattedProps = List.map formatProperty props
      formattedCaption = formatPropertyListCaption caption
  in  div [ Attr.class "astro-item" ]
          (formattedCaption :: formattedProps)


viewStar : String -> Model.Star -> Html Message.Message
viewStar caption star  =
  let props = appendStarProperties star []
      formattedProps = List.map formatProperty props
      formattedCaption = formatPropertyListCaption caption
  in  div [ Attr.class "astro-item" ]
          (formattedCaption :: formattedProps)


formatPropertyListCaption : String -> Html Message.Message
formatPropertyListCaption caption =
  div [ Attr.class "property-caption" ]
      [ h3 [] [ text caption ] ]

formatProperty : Property -> Html Message.Message
formatProperty prop =
  div [ Attr.class "property-row" ]
      [ div [ Attr.class "property-name"]
            [ text prop.name ]
      , div [ Attr.class "property-value"]
            [ text prop.value ]
      ]

appendPlanetaiProperties : Model.Planetai -> List Property -> List Property
appendPlanetaiProperties planetai props = props
  |> appendHorizonCoordinatesProperties planetai.position
  |> appendAngularSizeProperties planetai.angularSize
  |> appendDistanceProperties planetai.distance
  |> appendRiseSetProperties planetai.riseSet


appendStarProperties : Model.Star -> List Property -> List Property
appendStarProperties star props = props
  |> appendHorizonCoordinatesProperties star.position
  |> appendRiseSetProperties star.riseSet


appendRiseSetProperties : Model.SetRise -> List Property -> List Property
appendRiseSetProperties setRise props =
  Property "Rise" (formatMaybeDateTime setRise.rise)
  :: Property "Rise Azimuth" (formatMaybeDecimalDegrees setRise.riseAzimuth "--")
  :: Property "Set" (formatMaybeDateTime setRise.set)
  :: Property "Set Azimuth" (formatMaybeDecimalDegrees setRise.setAzimuth "--")
  :: Property "State" setRise.state
  :: props


appendDistanceProperties : Model.Distance -> List Property -> List Property
appendDistanceProperties distance props =
  Property "Distance" (formatNumber distance.value distance.units)
  :: props


appendAngularSizeProperties : Float -> List Property -> List Property
appendAngularSizeProperties size props =
  Property "Angular Size" (formatDecimalDegrees size)
  :: props


appendHorizonCoordinatesProperties : Model.HorizonCoordinates -> List Property -> List Property
appendHorizonCoordinatesProperties hc props =
  Property "Altitude" (formatDecimalDegrees hc.altitude)
  :: Property "Azimuth" (formatDecimalDegrees hc.azimuth)
  :: props
