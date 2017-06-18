module View.Format exposing (..)

import Date
import Date.Extra.Format as DateFormatter
import Date.Extra.Config.Config_en_gb exposing (config)
import FormatNumber
import FormatNumber.Locales as NumberLocales


number : Float -> String -> String
number n units =
  let str = FormatNumber.format NumberLocales.usLocale n
  in str ++ units



decimalDegrees : Float -> String
decimalDegrees df =
  let di = floor df
      mf = 60 * (df - toFloat di)
      mi = floor mf
      sf = 60 * (mf - toFloat mi)
  in (toString di) ++ "°"
      ++ (toString mi) ++ "′"
      ++ (number sf "″")


maybeDecimalDegrees : Maybe Float -> String -> String
maybeDecimalDegrees mbdd default =
  case mbdd of
    Just dd -> decimalDegrees dd
    Nothing -> default


maybeDateTime : Maybe Date.Date -> String
maybeDateTime mbDT =
  case mbDT of
    Just dt -> DateFormatter.format config "%d/%m/%Y %H:%M %z" dt
    Nothing -> "--"
