import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick )

-- component import example
import Components.Card as Card
import Components.Mice as Mice
import Components.Square as Square
import Components.DustBin.SingleTarget.Container as MyProg

-- APP
main : Program Never
main =
  Html.program
    { init = MyProg.init
    , view = MyProg.view
    , update = MyProg.update
    , subscriptions = MyProg.subscriptions
    }

--Html.beginnerProgram
--  { model = Card.init
--  , view = Card.view
--  , update = Card.update
--  }
