import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick )

-- component import example
import Components.Card as Card
import Components.Mice as Mice


-- APP
main : Program Never
main =
  Html.program
    { init = (Mice.model, Cmd.none)
    , view = Mice.view
    , update = Mice.update
    , subscriptions = Mice.subscriptions
    }
