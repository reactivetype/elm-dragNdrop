module Components.Card exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, keyCode, targetValue, on)
import Json.Decode as Json
import Dict exposing (Dict)

type alias Task =
  { name : String
  }
type alias Model =
  { tasks : Dict Int Task
  , nextId : Int
  , field : String
  }


model : Model
model =
  { tasks = Dict.empty
  , nextId = 0
  , field = ""
  }

type Msg
  = AddItem String
  | UpdateField String
  | NoOp

update : Msg -> Model -> Model
update msg model =
  case (msg, model) of
    (AddItem taskName, { tasks, nextId, field }) ->
      let
        newTasks = Dict.insert nextId { name = taskName } tasks
      in { tasks = newTasks, nextId = nextId + 1, field = "" }
    (UpdateField newField, _) -> { model | field = newField }
    (NoOp, model) -> model

view : Model -> Html Msg
view model =
  let
    cardStyle =
      style <| List.concatMap identity
                [ backColor, size, alignment, misc ]

    itemView : Task -> Html Msg
    itemView =
      \entity ->
        input
          [
            type' "text"
          , class "form-control input-sm col-xs-1"
          , placeholder "Enter task name"
          , value entity.name
          , style [
                ("margin-top", "10px")
              , ("margin-bottom", "5px")
            ]
          ] []

    newItemInput =
      input
        [ type' "text"
        , class "form-control input-sm col-xs-1"
        , placeholder "New Task"
        , value model.field
        , autofocus True
        , onEnter NoOp AddItem
        , onInputChange UpdateField
        , style [("margin-top", "10px"), ("margin-bottom", "10px")]
        ] []

    taskList = Dict.values model.tasks

    items = (newItemInput) :: (List.map itemView taskList)

  in div []
      [ div [cardStyle, class "col-md-3"] (items)
      , text << toString <| model
      ]

-- EventListener function
onEnter fail success =
  let
    tagger : Int -> String -> msg
    tagger code val =
      if code == 13 then success val
      else fail
  in
    on "keyup" (Json.object2 tagger keyCode targetValue)

onInputChange success =
  on "input" (Json.map success targetValue)

-- CSS styles
backColor = [ ("background-color", "lightblue") ]
noBorder = [ ("border", "none") ]
size =
  [ ("width" , "150px")
  ]
position =
  [
    ("left" , "10px")
  , ("top" , "10px")
  ]
alignment =
  [ ("align-items" , "center")
  , ("justify-content" , "center")
  , ("margin-left", "5px")
  , ("margin-right", "5px")
  , ("margin-top", "5px")
  , ("margin-bottom", "5px")
  , ("padding", "10px")
  ]
misc =
  [ ("border-radius" , "10px")
  , ("color" , "black") ]
