module Components.DustBin.SingleTarget.App exposing (..)

import Html.App as Html

import Components.DustBin.SingleTarget.Container exposing (init, update, view, subscriptions)

main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

