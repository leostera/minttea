open Riot

type Message.t += Input of Event.t | Render of string
