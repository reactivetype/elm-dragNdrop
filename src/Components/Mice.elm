module Components.Mice exposing (init, update, view, subscriptions)

import Html exposing (Html, label, div, text, button)
import Html.App exposing (program)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position, clicks, moves)
import String exposing (join)
import Time exposing (Time, every, now)
import Date exposing (fromTime, millisecond, second, minute, hour)
import Task exposing (Task, perform)
import Debug exposing (log)

type alias Model =
  { mousePosition : Position
  , numberClicks: Int
  , time: Float
  , timestamp: Float
  }

type Msg
 = NoOp
 | MouseMove Position
 | MouseClick Position
 | Reset
 | TicToc Float
 | TimeNow Float

model : Model
model =
  { mousePosition = { x = 0, y = 0 }
  , numberClicks = 0
  , time = 0
  , timestamp = 0
  }

init : (Model, Cmd Msg)
init = (model, getCurrentTime)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    MouseMove position ->
      ({ model | mousePosition = position }, Cmd.none)
    MouseClick _ ->
      ({ model | numberClicks = model.numberClicks + 1 }, Cmd.none )
    TicToc time' ->
        ({ model | time = time' }, Cmd.none )
    TimeNow time' ->
        ({ model | time = time', timestamp = time' }, Cmd.none)
    Reset ->
      ({ model | numberClicks = -1 }, getCurrentTime )


subscriptions : Model -> Sub Msg
subscriptions model =
  let
    mouseMoves = moves MouseMove
    mouseClicks = clicks MouseClick
    milliSeconds = every Time.millisecond TicToc
  in Sub.batch [ mouseMoves, mouseClicks, milliSeconds ]

view : Model -> Html Msg
view model =
  let
    lapse = timeDiff model.timestamp model.time |> timeLapse
  in div
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
        , label [ id "stop-watch-sec", class "col-sm-1 text-left"] [ text lapse ]
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

-- Helpers
getCurrentTime =
  let
    fail err = NoOp
    success = TimeNow
  in perform fail success now


timeDiff : Time -> Time -> Time
timeDiff t1 t2 = t2 - t1

timeLapse : Time -> String
timeLapse t =
  let
    norm = \sc' -> if sc' < 10 then "0" ++ toString sc'
                     else toString sc'
    date =  t |> fromTime
    ms = date |> millisecond |> norm
    sc = date |> second |> norm
    mn = date |> minute |> norm
    hr = "00"
  in
    join "" [ hr, ":", mn, ":", sc, ".", ms]




--main = program { init = init , update = update, view = view, subscriptions = subscriptions }


