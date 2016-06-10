import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick )

-- component import example
import Components.Card as Card


-- APP
main : Program Never
main =
  Html.beginnerProgram { model = Card.model, view = Card.view, update = Card.update }
