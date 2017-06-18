module View exposing (view)

import Html exposing (Html, div, text, program, button, input, h1, h2)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attr
import RemoteData

import Model
import Message
import View.PropertyList as Properties
import View.DateTimePicker as DateTimePicker


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
      , viewCurrentTimeControl
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
            [ DateTimePicker.view model ]
      ]


viewCurrentTimeControl : Html Message.Message
viewCurrentTimeControl =
  div [ Attr.class "control-block-button" ]
      [ div [ ]
            [ button [ onClick Message.RequestCurrentDate ]
                     [ text "Get current time" ]
            ]
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
  div [ Attr.class "control-block-button" ]
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


viewPlanetai : String -> Model.Planetai -> Html Message.Message
viewPlanetai caption planetai =
  let props = Properties.appendPlanetai planetai []
      formattedProps = Properties.format props
      formattedCaption = Properties.formatCaption caption
  in  div [ Attr.class "astro-item" ]
          (formattedCaption :: formattedProps)


viewStar : String -> Model.Star -> Html Message.Message
viewStar caption star  =
  let props = Properties.appendStar star []
      formattedProps = Properties.format props
      formattedCaption = Properties.formatCaption caption
  in  div [ Attr.class "astro-item" ]
          (formattedCaption :: formattedProps)
