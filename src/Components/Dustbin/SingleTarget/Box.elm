module Components.DustBin.SingleTarget.Box exposing (Model, Msg(..), name, isDropped, isDragging, init, createWith, view, update)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on, onWithOptions)
import Json.Decode as Json exposing ((:=), string)
import Mouse exposing (Position)

-- Model
type Status = Idle | Dropped
type alias Drag =
  { start : Position
  , current: Position
  }
type alias Box =
  { name : String
  , status: Status
  , position: Position
  , drag: Maybe Drag
  }
type alias Model = Box
type alias Name = String
type alias Context = { name : String, position : Position}

-- Messages
name : Msg -> String
name msg = context msg |> .name

type Msg
    = DragStarted Context
    | DragAt Context
    | DragEnded Context
    | Drop Context

context : Msg -> Context
context msg = case msg of
  DragStarted ctx -> ctx
  DragAt ctx -> ctx
  DragEnded ctx -> ctx
  Drop ctx -> ctx

-- Init
init : (Model, Cmd Msg)
init =
  let
    box =
      { name = "A box"
      , status = Idle
      , position = Position 100 100
      , drag = Nothing
      }
  in (box, Cmd.none)

isDropped : Model -> Bool
isDropped model = model.status == Dropped

isDragging : Model -> Bool
isDragging model = model.drag /= Nothing

createWith : String -> Position -> Model
createWith name position =
  Box name Idle position Nothing


-- View
view : Model -> Html Msg
view model =
  let
    position =
      [ "left" => px model.position.x
      , "top" => px model.position.y
      ]
  in div
      [ onDragStart model.name, onDrag model.name
      , onDragEnd model.name
      , draggable "true"
      , style (styleSheet ++ position)
      ]
      [ text model.name ]

-- Update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = (updateModel msg model, Cmd.none)

updateModel : Msg -> Model -> Model
updateModel msg model =
  case (msg, model) of
    (DragStarted {name, position}, _) ->
      {model | drag = Just (Drag position position)}
    (DragAt {name, position}, _) ->
      if (position.x == 0 && position.y == 0) then model
      else
        let
          newDrag = Maybe.map (\{start} -> Drag start position) model.drag
        in {model | drag = newDrag }
    (DragEnded {name, position}, _)->
      if name == model.name
      then { model | position = getPosition model, drag = Nothing}
      else model
    (Drop _, _) -> { model | status = Dropped }

-- Subscriptions
subscriptions _ = Sub.none

-- Drag event handlers
dragCtx : String -> Json.Decoder Context
dragCtx name = Json.object2 Context (Json.succeed name) Mouse.position

onDrag : String -> Attribute Msg
onDrag name =
  on "drag" (Json.map DragAt <| dragCtx name)

onDragStart : String -> Attribute Msg
onDragStart name =
  on "mousedown" (Json.map DragStarted <| dragCtx name)

onDragEnd : String -> Attribute Msg
onDragEnd name =
  on "dragend" (Json.map DragEnded <| dragCtx name)

-- Helpers
(=>) = (,)

px : Int -> String
px number =
  toString number ++ "px"

getPosition : Model -> Position
getPosition {position, drag} =
  case drag of
    Nothing -> position
    Just {start, current} ->
      Position (current.x + position.x - start.x)
               (current.y + position.y - start.y)

-- CSS style
styleSheet =
  [ "border" => "1px dashed gray"
  , "backgroundColor" => "white"
  , "padding" => "0.5rem 1rem"
  , "marginRight" => "1.5rem"
  , "marginBottom" => "1.5rem"
  , "cursor" => "move"
  , "float" => "left"
  , "align-items" => "center"
  , "justify-content" => "center"
  , "font-size" => "12px"
  , "font-family" => "Comic Sans MS"
  , "cursor" => "move"
  , "position" => "absolute"
  ]

---- APP
--main : Program Never
--main =
--  Html.program
--    { init = init
--    , view = view
--    , update = update
--    , subscriptions = subscriptions
--    }
