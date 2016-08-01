App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $("#winning-cards").append data["winning_card"]
    $("#notifications").html data["notification"]
    $("#messages").prepend data["message"]
    $("#players").html data["player"]
    $("#game_cards").append data["game_card"]
    $("#pot").text data["pot"]
    $("##{data["turn"]}").addClass("highlight")
    $("#user-#{data["user_id"]}").fadeIn()
    if data["new_game"]
      $(".pocket-cards").fadeOut()
      $(".game-cards").fadeOut()
      $(".pregame").fadeIn()
      $("#join").fadeIn()

    if data["start_game"]
      $("#pocket_cards").fadeIn()
      $(".pregame").fadeOut()
      $(".winner").fadeOut()

    if data["clear_table"]
      $(".pocket-cards").fadeOut()
      $(".game-cards").fadeOut()
      $(".winning-cards").fadeOut()
      $(".winner").fadeOut()

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", "[data-behavior~=room_speaker]", (event) ->
  if event.keyCode is 13 && $("#chat").val() isnt ""
    App.room.speak {"chat": event.target.value}
    event.target.value = ""
    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  # if event.keyCode is 13 # return = send
  if event.target.id is "current-bet"
    App.room.speak {"user_action": {"bet": "#{$("#bet-amount").val()}"}}
    $("#bet-amount").value = ""
    event.preventDefault()


$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "check"
    App.room.speak {"user_action":"check"}

    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "fold"
    App.room.speak {"user_action": "fold"}

    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "join"
    App.room.speak {"join": "join"}

    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "add-ai-player"
    App.room.speak {"add-ai-player": 1}

    event.preventDefault()

$(document).on "click", "[data-behavior~=room_speaker]", (event) ->
  if event.target.id is "start-game"
    App.room.speak "start-game"

    event.preventDefault()
