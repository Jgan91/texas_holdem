# README

## Texas Holdem with Rails 5 Action Cable!
One of the defining features of Rails Five is Action Cable. Action Cable allows one to integrate web sockets into a rails app for realtime updates. Most examples of Action Cable that I came across were chat applications. I wondered what it would be like to build a real-time Texas Holdem application. Texas Holdem requires several components that are available to all players (i.e. the flop, turn, river, blinds, pot, etc.) as well as components that are unique to each particular user(i.e. the pocket cards). See this blog post for
more details: [Rails 5 Action Cable]("http://chadellison.github.io/").

Users can play with other users, Ai Players, or both-- users can even just watch Ai Players play. Feature testing was very difficult and I was not able to find very many resources for feature testing with sockets.

### Game Play
[Texas Holdem Rules]("http://www.pokerlistings.com/poker-rules-texas-holdem")
Each player sees their own pocket cards, while all players see the game cards (flop, turn, and river). Action buttons appear only for the player whose turn it is, and the player's name is highlighted in red. After each winning round, the blinds rotate clockwise. A chat box on the announces game stage and player actions, as well as allows players to talk to one another. Here is an example:

![Example Game](assets/game_play.png)
![Example Game](https://raw.githubusercontent.com/chadellison/texas_holdem/master/app/assets/images/game_play.png)

When a player initiates a bet, a box opens like so:
![Bet](https://raw.githubusercontent.com/chadellison/texas_holdem/master/app/assets/images/bet.png)

At the end of each showdown the winner and the winner's hand is revealed:
![Bet](https://raw.githubusercontent.com/chadellison/texas_holdem/master/app/assets/images/winner.png)

* Ruby version 2.3.0

* Rails version 5.0.0

* Database initialization
  Be sure to run the seed file in order to load Ai Players
  Rails db:reset or rails db:create, rails db:migrate, rails db:seed

* How to run the test suite
  Run rspec for the test suite
