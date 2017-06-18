module View.PropertyList exposing (format, formatCaption
                                  , appendPlanetai, appendStar)


import Html exposing (Html, div, h2, h3, text)
import Html.Attributes exposing (class)

import Model
import View.Format as Format


type alias Property =
  { name : String
  , value : String
  }


format : List Property -> List (Html msg)
format props = List.map formatProperty props


formatCaption : String -> Html msg
formatCaption caption =
  div [ class "property-caption" ]
      [ h3 [] [ text caption ] ]


formatProperty : Property -> Html msg
formatProperty prop =
  div [ class "property-row" ]
      [ div [ class "property-name"]
            [ text prop.name ]
      , div [ class "property-value"]
            [ text prop.value ]
      ]

appendPlanetai : Model.Planetai -> List Property -> List Property
appendPlanetai planetai props = props
  |> appendHorizonCoordinates planetai.position
  |> appendAngularSize planetai.angularSize
  |> appendDistance planetai.distance
  |> appendRiseSet planetai.riseSet


appendStar : Model.Star -> List Property -> List Property
appendStar star props = props
  |> appendHorizonCoordinates star.position
  |> appendRiseSet star.riseSet


appendRiseSet : Model.SetRise -> List Property -> List Property
appendRiseSet setRise props =
  Property "Rise" (Format.maybeDateTime setRise.rise)
  :: Property "Rise Azimuth" (Format.maybeDecimalDegrees setRise.riseAzimuth "--")
  :: Property "Set" (Format.maybeDateTime setRise.set)
  :: Property "Set Azimuth" (Format.maybeDecimalDegrees setRise.setAzimuth "--")
  :: Property "State" setRise.state
  :: props


appendDistance : Model.Distance -> List Property -> List Property
appendDistance distance props =
  Property "Distance" (Format.number distance.value distance.units)
  :: props


appendAngularSize : Float -> List Property -> List Property
appendAngularSize size props =
  Property "Angular Size" (Format.decimalDegrees size)
  :: props


appendHorizonCoordinates : Model.HorizonCoordinates -> List Property -> List Property
appendHorizonCoordinates hc props =
  Property "Altitude" (Format.decimalDegrees hc.altitude)
  :: Property "Azimuth" (Format.decimalDegrees hc.azimuth)
  :: props
