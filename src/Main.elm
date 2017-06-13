module Main exposing (..)

import Html

import Model
import Message
import View
import Update


init : ( Model.Model, Cmd Message.Message )
init = ( Model.initialModel, Cmd.none )


subscriptions : Model.Model -> Sub Message.Message
subscriptions model = Sub.none


main : Program Never Model.Model Message.Message
main =
    Html.program
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = subscriptions
        }
