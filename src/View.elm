module View exposing (view)

import Html exposing (Html, div, text, program, button)
import Html.Events exposing (onClick)
import RemoteData

import Model
import Message

view : Model.Model -> Html Message.Message
view model =
    div []
        [ button [ onClick Message.FetchAstroData ] [ text "Query" ]
        , case model.astro of
            RemoteData.NotAsked -> text "Please request for astro data"
            RemoteData.Loading -> text "Please wait, astro data is loading..."
            RemoteData.Failure err -> text ("Error: " ++ toString err)
            RemoteData.Success astro -> viewAstroData astro
      ]

viewAstroData : Model.AstroData -> Html Message.Message
viewAstroData astro = text (toString astro)
