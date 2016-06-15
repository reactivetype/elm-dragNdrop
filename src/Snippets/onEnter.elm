import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, keyCode, targetValue, on)
import Json.Decode as Json
import Dict exposing (Dict)

type alias Input = String
type alias Model = List Input


model : Model
model = []

type Msg
  = AddItem String
  | NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddItem input -> input :: model
    NoOp -> model

-- EventListener function
onEnter fail success =
  let
    tagger : Int -> String -> msg
    tagger code val =
      if code == 13 then success val
      else fail
  in
    on "keyup" (Json.object2 tagger keyCode targetValue)

view : Model -> Html Msg
view model =
  let
    savedInputView : Input -> Html Msg
    savedInputView = \item ->
      input
        [ type' "text"
        , class "form-control input-sm col-xs-1"
        , placeholder "Enter a new one"
        , value item
        , style [
        ("margin-top", "10px")
        , ("margin-bottom", "5px")
        ]
        ] []

    newInputView : Html Msg
    newInputView =
      input
        [ type' "text"
        , class "form-control input-sm col-xs-1"
        , placeholder "New Task"
        , onEnter NoOp AddItem
        , style [
              ("margin-top", "10px")
            , ("margin-bottom", "5px")
          ]
        ] []

    items = newInputView :: (List.map savedInputView model)

  in div [class "container"]
      [ div [class "col-md-3"] items
      , text << toString <| model
      ]

main = Html.beginnerProgram { model = model, update = update, view = view }
