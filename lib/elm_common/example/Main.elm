module Main exposing (..)

import RouteUrl
import Example as App


main : Program Never
main =
    RouteUrl.program
        { delta2url = App.delta2url
        , location2messages = App.location2messages
        , init = App.init
        , update = App.update
        , view = App.view
        , subscriptions = App.subscriptions
        }
