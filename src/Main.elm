import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick )

-- component import example
import Components.Card as Card
import Components.Mice as Mice
import Components.Square as Square

-- APP
main : Program Never
main =
  Html.program
    { init = Square.init
    , view = Square.view
    , update = Square.update
    , subscriptions = Square.subscriptions
    }

  --Html.beginnerProgram
  --  { model = Card.init
  --  , view = Card.view
  --  , update = Card.update
  --  }
