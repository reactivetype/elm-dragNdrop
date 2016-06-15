module Components.Mice exposing (model, update, view, subscriptions)

import Html exposing (Html, label, div, text)
import Html.App exposing (program)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position, clicks, moves)


type alias Model =
  { mousePosition : Position
  , numberClicks: Int
  }

type Msg
 = NoOp
 | MouseMove Position
 | MouseClick Position

model : Model
model =
  { mousePosition = { x = 0, y = 0 }
  , numberClicks = 0
  }

-- Upon receiving a message of type Msg
-- and given its current Model state
-- updates the model and emits a Cmd message
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    MouseMove position ->
      ({ model | mousePosition = position }, Cmd.none)
    MouseClick _ ->
      ({ model | numberClicks = model.numberClicks + 1 }, Cmd.none )


view : Model -> Html Msg
view model =
  div []
    [
      div
        [ class "row" ]
        [ label [ class "col-sm-2" ] [ text "Mouse x-position: " ]
        , label [ id "x-pos", class "col-sm-1 text-left"] [ text <| toString model.mousePosition.x ]
        ]
    , div
        [ class "row" ]
        [ label [ class "col-sm-2"] [ text "Mouse y-position: "]
        , label [ id "y-pos", class "col-sm-1 text-left" ] [ text <| toString model.mousePosition.y ]
        ]
    , div
        [ class "row" ]
        [ label [ class "col-sm-2" ] [ text "Number of clicks: "]
        , label [ id "num-clicks", class "col-sm-1 text-left"] [ text <| toString model.numberClicks ]
        ]
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
  let
    mouseMove = moves MouseMove
    mouseClick = clicks MouseClick
  in Sub.batch [ mouseMove, mouseClick ]

--main = program { init = (model, Cmd.none) , update = update, view = view, subscriptions = subscriptions }


