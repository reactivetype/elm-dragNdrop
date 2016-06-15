module Components.Slider exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.App as Html
import Html.Attributes as Attributes exposing (style, width, class)
import Html.Events exposing (..)
import Json.Decode as Json
import Dict exposing (Dict)


type alias Model =
  { minValue : Float
  , maxValue : Float
  , current : Float
  }


model : Model
model =
  { minValue = 0
  , maxValue = 100
  , current = 0
  }

type Msg
  = NoOp

update : Msg -> Model -> Model
update _ model = model

view : Model -> Html a
view model =
  let
    min' = toString model.minValue
    max' = toString model.maxValue
    slider = input [ Attributes.type' "range", Attributes.min min', Attributes.max max' ] []
  in
    div [ style [("margin", "1px 0px 0 0")] ] [ slider ]