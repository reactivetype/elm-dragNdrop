module Components.Card exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

type alias Task = 
  { name : String
  }
type alias Model = List Task


model : Model
model = []

type Msg 
  = AddItem String

update : Msg -> Model -> Model
update msg model =
  case msg of 
    AddItem task -> { name = task } :: model

view : Model -> Html Msg
view model = 
  let 
    cardStyle = 
      style <| List.concatMap identity
                [ backColor, size, alignment, misc ]
    itemView = 
      \entity -> 
        input 
          [
            type' "text"
          , class "form-control input-sm col-xs-1"
          , value entity.name
          , style [
                ("margin-top", "10px")
              , ("margin-bottom", "5px")
            ]
          ] []

    newItem = 
      input 
        [
          type' "text"
        , class "form-control input-sm col-xs-1"
        , placeholder "New Task"
        , onInput AddItem
        , style [
              ("margin-top", "10px")
            , ("margin-bottom", "5px")
          ]
        ] []

    items = newItem :: (List.map itemView model)

  in div [cardStyle, class "col-md-3"] items

-- CSS styles
backColor = [ ("background-color", "lightblue") ]
noBorder = [ ("border", "none") ]
size = 
  [ ("width" , "150px")
  , ("height" , "150px")
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
  ]
misc = 
  [ ("border-radius" , "10px")
  , ("color" , "black") ]
