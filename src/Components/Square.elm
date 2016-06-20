module Components.Square exposing (init, view, update, subscriptions)


import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on, onWithOptions)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)



-- MODEL


type alias Drag =
  { start : Position
  , current: Position
  }

type alias Model =
  { position : Position
  , drag : Maybe Drag
  , color : String
  }

init : ( Model, Cmd Msg )
init =
  ( Model (Position 25 20) Nothing "lightgrey", Cmd.none )



-- UPDATE


type Msg
    = DragStarted Position
    | DragAt Position
    | DragEnded Position
    | DraggedOver
    | DragLeft



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = (updateModel msg model, Cmd.none)

updateModel : Msg -> Model -> Model
updateModel msg ({ position, drag, color } as model ) =
  case Debug.log "message" (msg, model) of
    (DragStarted xy, _) ->
      Model position (Just (Drag xy xy)) color
    (DragAt xy, _) ->
      if (xy.x == 0 && xy.y == 0) then model else
      Model position (Maybe.map (\{start} -> Drag start xy) drag) color
    (DragEnded _, _)->
      { model | position = getPosition model
       , drag = Nothing}
    (DraggedOver, _) -> {model | color = "lightgreen" }
    (DragLeft, _) -> {model | color = "lightgrey" }


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
(=>) = (,)

view : Model -> Html Msg
view model =
  let
    card =
      div
      [
      onDragStart
      , onDrag
      , onDragEnd
      , draggable "true"
      , style
          [ "background-color" => "#f6f6f6"
          , "cursor" => "move"
          , "top" => "100px"
          , "width" => "100px"
          , "height" => "100px"
          , "border" => "solid 2px black"
          , "border-radius" => "10px"
          , "position" => "relative"
          , "left" => px model.position.x
          , "top" => px model.position.y
          , "color" => "black"
          , "display" => "flex"
          , "align-items" => "center"
          , "justify-content" => "center"
          , "font-size" => "20px"
          , "font-family" => "Comic Sans MS"
          ]
      ]
      [ text "Drag Me!" ]

    dropingZone bgColor =
      div
      [ dropzone "true"
      , onDragOver DraggedOver, onDragLeave DragLeft
      , style
          [ "position" => "absolute"
          , "left" => "300px"
          , "top" => "200px"
          , "width" => "200px"
          , "height" => "200px"
          , "border" => "dashed 2px white"
          , "align-items" => "center"
          , "justify-content" => "center"
          , "font-size" => "20px"
          , "font-family" => "Comic Sans MS"
          , "background-color" => bgColor
          ]
      ]
      [ text "Drop onto me.." ]
    modelView = text << toString <| model
  in div [] [ card, dropingZone model.color, modelView ]



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

-- Drag event handlers
onDrag : Attribute Msg
onDrag =
  on "drag" (Json.map DragAt Mouse.position)

onDragStart : Attribute Msg
onDragStart =
  on "mousedown" (Json.map DragStarted Mouse.position)

onDragEnd : Attribute Msg
onDragEnd =
  on "dragend" (Json.map DragEnded Mouse.position)

onDragOver : msg -> Attribute msg
onDragOver tagger =
  on "dragover" (Json.succeed tagger)

onDragLeave : msg -> Attribute msg
onDragLeave tagger =
  on "dragleave" (Json.succeed tagger)


-- APP
main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
