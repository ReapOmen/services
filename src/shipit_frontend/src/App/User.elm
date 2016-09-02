port module App.User exposing (..)

import Dict exposing ( Dict )
import Json.Decode as JsonDecode exposing ( (:=) )
import Json.Encode as JsonEncode
import App.Utils exposing ( eventLink )



type alias Certificate =
    { version : Int
    , scopes : List String
    , start : Int
    , expiry : Int
    , seed : String
    , signature : String
    , issuer : String
    }


type alias Model =
    { clientId : Maybe String
    , accessToken : Maybe String
    , certificate : Maybe Certificate
    , hawkHeader : Maybe String
    }


type alias LoginUrl =
    { url : String
    , target : Maybe (String, String)
    }


type Msg
    = Login LoginUrl
    | LoggingIn Model
    | LoggedIn (Maybe Model)
    | LocalUser
    | ReceivedHawkHeader String
    | Logout 


update : Msg -> (Maybe Model) -> ((Maybe Model), Cmd Msg)
update msg model =
    case msg of
        Login url ->
            ( model, redirect url )

        LoggingIn user ->
            ( model, localstorage_set { name = "shipit-credentials"
                                      , value = Just user
                                      }
            )
        LoggedIn user ->
            case user of
              Just user' ->
                -- Build hawk header
                ( user,  hawk_build {
                  user = user',
                  method = "GET",
                  url = "http://demo.mozilla.org" -- is this url used ??
                })
              Nothing ->
                ( Nothing, Cmd.none)

        LocalUser ->
            -- Fetch local user from localstorage
            ( model, localstorage_load True )

        Logout ->
            ( model, localstorage_remove True )

        ReceivedHawkHeader header ->
            -- Store hawk header
            case model of
              Just user ->
                ( Just { user | hawkHeader = Just header }, Cmd.none )
              Nothing ->
                ( Nothing, Cmd.none )


decodeCertificate : String -> Result String Certificate
decodeCertificate text =
    JsonDecode.decodeString
        (JsonDecode.object7 Certificate
            ( "version"     := JsonDecode.int )
            ( "scopes"      := JsonDecode.list JsonDecode.string )
            ( "start"       := JsonDecode.int )
            ( "expiry"      := JsonDecode.int )
            ( "seed"        := JsonDecode.string )
            ( "signature"   := JsonDecode.string )
            ( "issuer"      := JsonDecode.string )
        ) text


convertUrlQueryToModel : Dict String String -> Model
convertUrlQueryToModel query =
    { clientId = Dict.get "clientId" query
    , accessToken = Dict.get "accessToken" query
    , certificate =
             case Dict.get "certificate" query of
                 Just certificate ->
                     Result.toMaybe <| decodeCertificate certificate
                 Nothing -> Nothing
    , hawkHeader = Nothing
     }


-- PORTS

-- XXX: until https://github.com/elm-lang/local-storage is ready

type alias LocalStorage =
    { name : String
    , value : Maybe Model 
    }

port localstorage_get : (Maybe Model -> msg) -> Sub msg
port localstorage_load : Bool -> Cmd msg
port localstorage_remove : Bool -> Cmd msg
port localstorage_set : LocalStorage -> Cmd msg

type alias HawkRequest = {
  url : String,
  method : String,
  user : Model
}
port hawk_get : (String -> msg )-> Sub msg
port hawk_build : HawkRequest -> Cmd msg

-- XXX: we need to find elm implementation for redirect

port redirect : LoginUrl -> Cmd msg
