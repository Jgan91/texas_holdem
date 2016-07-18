App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $("#messages").append data["message"]

  speak: (message)->
    @perform 'speak', message: message

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  # if event.keyCode is 13 # return = send
  if event.target.id is "bet"
    # App.room.speak event.target.value
    App.room.speak "Bet $#{$("#bet-amount").val()}"
    # $("#this").value = ""
    event.preventDefault()

$(document).on "keypress", "[data-behavior~=room_speaker]", (event) ->
  if event.keyCode is 13
    App.room.speak event.target.value
    event.target.value = ""
    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "check"
    App.room.speak "Check"
    # event.target.value = ""
    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "fold"
    App.room.speak "Fold"

    event.preventDefault()
