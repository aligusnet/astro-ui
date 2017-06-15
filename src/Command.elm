module Command exposing (..)

import Date
import Task
import DateTimePicker

import AWS.Lambda
import Message
import Model
import Model.Json as Json


fetchAstroData : Model.Model -> Cmd Message.Message
fetchAstroData model = AWS.Lambda.fetchAstroData (Json.encodeRequest model)


receiveCurrentDate : Cmd Message.Message
receiveCurrentDate = Task.perform Message.ReceiveCurrentDate Date.now


initDateTimePicker : Cmd Message.Message
initDateTimePicker = DateTimePicker.initialCmd Message.DateChange DateTimePicker.initialState


init : Cmd Message.Message
init = Cmd.batch [ receiveCurrentDate, initDateTimePicker ]
