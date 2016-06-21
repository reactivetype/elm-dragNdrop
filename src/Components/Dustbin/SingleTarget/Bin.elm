module Components.DustBin.SingleTarget.Bin exposing (Model, Msg, init, view, update, subscriptions)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (on, onWithOptions)
import Json.Decode as Json
import Mouse exposing (Position)
import Dict exposing (Dict)


-- Model
type alias Order = Int
type alias Model =
  { content : Dict Order String
  , color : String
  }

-- Messages
type Msg
    = DraggedOver
    | DragLeft
    | InsertBox String

-- Init
init : (Model, Cmd Msg)
init = ( Model Dict.empty "lightgrey", Cmd.none )

-- View
view : Model -> Html Msg
view model =
  let
    labelView : String -> Html Msg
    labelView = \name -> div [] [ text name ]
    backgroundColor = ["background-color" => model.color]
    labels = List.map labelView (Dict.values model.content)
  in
    div
      [ onDragOver DraggedOver
      , onDragLeave DragLeft
      , onDrop (InsertBox "Box inserted")
      , dropzone "true"
      , style (styleSheet ++ backgroundColor)
      ] (text "Drop it like it's hot!" :: labels)


-- Update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = (updateModel msg model, Cmd.none)

updateModel : Msg -> Model -> Model
updateModel msg model =
  case Debug.log "message" msg of
    InsertBox box ->
      let
        numBoxes = Dict.size model.content
      in
        { model | content = Dict.insert (numBoxes+1) box model.content }
    DraggedOver -> { model | color = "lightgreen" }
    DragLeft -> { model | color = "lightgrey" }

-- Subscriptions
subscriptions _ = Sub.none

-- Drag event handlers
onDragOver : msg -> Attribute msg
onDragOver tagger =
  onWithOptions "dragover" { preventDefault = True, stopPropagation = False } (Json.succeed tagger)

onDragLeave : msg -> Attribute msg
onDragLeave tagger =
  on "dragleave" (Json.succeed tagger)

onDrop : msg -> Attribute msg
onDrop tagger =
  on "drop" (Json.succeed tagger)

-- Helpers
(=>) = (,)

px : Int -> String
px number =
  toString number ++ "px"

-- CSS style
styleSheet =
  [ "top" => "2em"
  , "left" => "20em"
  , "height" => "12rem"
  , "width" => "12rem"
  , "marginRight" => "1.5rem"
  , "marginBottom" => "1.5rem"
  , "color" => "white"
  , "padding" => "1rem"
  , "textAlign" => "center"
  , "fontSize" => "1rem"
  , "lineHeight" => "normal"
  , "position" => "relative"
  , "float" => "left"
  , "border" => "4px solid gray"
  , "align-items" => "center"
  , "justify-content" => "center"
  , "font-size" => "12px"
  , "font-family" => "Comic Sans MS"
  ]


-- APP
main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
