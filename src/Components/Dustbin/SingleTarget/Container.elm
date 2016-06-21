module Components.DustBin.SingleTarget.Container exposing (Model, Msg, init, view, update, subscriptions)

import Html exposing (..)
import Html.App as Html
import Dict exposing (Dict)
import List

import Components.DustBin.SingleTarget.Box as Box
import Components.DustBin.SingleTarget.Bin as Bin

type alias Model =
  { bin : Bin.Model
  , boxes : Dict String Box.Model
  }

type alias Position = { x : Int, y : Int }

-- Three boxes and one bin
init : (Model, Cmd Msg)
init =
  let
    (bin, _) = Bin.init
    boxNames = ["Box A", "Box B", "Box C"]
    positions = List.map (\(x, y) -> Position x y) [(20,30), (20,100), (20,170)]
    bs  = List.map2 Box.createWith boxNames positions
    dict = List.map2 (,) boxNames bs |> Dict.fromList
  in ({ bin = bin , boxes = dict}, Cmd.none)

type Msg =
  Bin Bin.Msg | Box Box.Msg

subscriptions : Model -> Sub Msg
subscriptions = \_ -> Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log "container msg" msg of
    Bin msg' ->
      let
        (bin, cmd) = Bin.update msg' model.bin
      in ({ model | bin = bin}, Cmd.map Bin cmd)
    Box msg' ->
      let
        boxName : String
        boxName = Box.name msg'

        maybeUpdate : Maybe (Box.Model)
        maybeUpdate =
          Dict.get boxName model.boxes

        updateBox = \box ->
          let
            (newBox, cmd) = Box.update msg' box
            updatedBoxes = Dict.insert boxName newBox model.boxes
          in ({model | boxes = updatedBoxes}, Cmd.map Box cmd)
      in
        Maybe.map updateBox maybeUpdate |> Maybe.withDefault (model, Cmd.none)


view : Model -> Html Msg
view {bin, boxes} =
  let
    binView = Html.map Bin <| Bin.view bin
    boxViews = List.map (Html.map Box << Box.view) (Dict.values boxes)
    children : List (Html Msg)
    children = binView :: boxViews
  in
    div [] children


main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


