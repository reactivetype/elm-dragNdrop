module Components.Mice exposing (model, update, view, subscriptions)

import Html exposing (Html, label, div, text, button)
import Html.App exposing (program)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position, clicks, moves)
import Time exposing (Time, millisecond, every)

type alias Model =
  { mousePosition : Position
  , numberClicks: Int
  , time: Float
  }

type Msg
 = NoOp
 | MouseMove Position
 | MouseClick Position
 | Reset
 | TicToc Float

model : Model
model =
  { mousePosition = { x = 0, y = 0 }
  , numberClicks = 0
  , time = 0
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
    TicToc time ->
      ({ model | time = time }, Cmd.none )
    Reset ->
      ({ model | numberClicks = -1, time = 0 }, Cmd.none )


view : Model -> Html Msg
view model =
  div
    [ style
        [ ("min-width", "100px")
        , ("margin", "20px 20px 10px 10px")
        ]
    ]
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
    , div
        [ class "row" ]
        [ label [ class "col-sm-2" ] [ text "StopWatch: "]
        , label [ id "stop-watch-sec", class "col-xs-1 text-left"] [ text << toString <| rem (truncate model.time) 1000 ]
        , label [ id "stop-watch-tenth", class "col-xs-1 text-left"] [ text <| toString (truncate model.time // 1000) ]
        ]
    , div
        [ class "row"]
        [ button
            [ class "col-sm-2"
            , style [("margin", "10px 0px 0px 15px")]
            , onClick Reset
            ]
            [ text "Reset"]
        ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  let
    mouseMoves = moves MouseMove
    mouseClicks = clicks MouseClick
    tenthSeconds = every (10 * millisecond) TicToc
  in Sub.batch [ mouseMoves, mouseClicks, tenthSeconds ]

--main = program { init = (model, Cmd.none) , update = update, view = view, subscriptions = subscriptions }


