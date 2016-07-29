require "rails_helper"

RSpec.describe CardAnalyzer do
  it "determines a high_card" do
    cards = [
      Card.new(value: "10", suit: "diamonds"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "2", suit: "hearts")
    ]

    expect(CardAnalyzer.new.find_hand(cards).class).to eq HighCard

    pair = [
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "3", suit: "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(pair).class).to_not eq HighCard
  end

  it "determines a pair" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoOfKind
  end

  it "determins two pair" do
    cards = [
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "2", suit: "clubs"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq TwoPair
  end

  it "determines three of a kind" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts"),
      Card.new(value: "2", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq ThreeOfKind
  end

  it "determines a straight" do
    cards = [
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "6", suit: "clubs"),
      Card.new(value: "9", suit: "diamonds"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "8", suit: "spades"),
      Card.new(value: "7", suit: "spades"),
      Card.new(value: "2", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a straight with face cards" do
    cards = [
      Card.new(value: "9", suit: "clubs"),
      Card.new(value: "10", suit: "hearts"),
      Card.new(value: "JACK", suit: "hearts"),
      Card.new(value: "KING", suit: "hearts"),
      Card.new(value: "QUEEN", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace low straight" do
    cards = [
      Card.new(value: "ACE", suit: "clubs"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "4", suit: "hearts"),
      Card.new(value: "2", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines an ace high straight" do
    cards = [
      Card.new(value: "ACE", suit: "clubs"),
      Card.new(value: "10", suit: "hearts"),
      Card.new(value: "JACK", suit: "hearts"),
      Card.new(value: "KING", suit: "spades"),
      Card.new(value: "KING", suit: "hearts"),
      Card.new(value: "QUEEN", suit: "spades"),
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Straight
  end

  it "determines a flush" do
    cards = [
      Card.new(value: "5", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "3", suit: "clubs"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq Flush
  end

  it "determines a full house" do
    cards = [
      Card.new(value: "2", suit: "diamonds"),
      Card.new(value: "2", suit: "hearts"),
      Card.new(value: "2", suit: "clubs"),
      Card.new(value: "3", suit: "hearts"),
      Card.new(value: "3", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FullHouse
  end

  it "determines four of a kind" do
    cards = [
      Card.new(value: "5", suit: "hearts"),
      Card.new(value: "5", suit: "clubs"),
      Card.new(value: "5", suit: "diamonds"),
      Card.new(value: "7", suit: "hearts"),
      Card.new(value: "5", suit: "spades")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to eq FourOfKind
  end

  it "determines a straight flush" do
    cards = [
      Card.new(value: "9", suit: "clubs"),
      Card.new(value: "8", suit: "clubs"),
      Card.new(value: "7", suit: "clubs"),
      Card.new(value: "6", suit: "clubs"),
      Card.new(value: "10", suit: "clubs")
    ]

    not_a_straight_flush = [
      Card.new(value: "9", suit: "clubs"),
      Card.new(value: "8", suit: "clubs"),
      Card.new(value: "7", suit: "Hearts"),
      Card.new(value: "6", suit: "clubs"),
      Card.new(value: "10", suit: "spades"),
      Card.new(value: "JACK", suit: "clubs"),
      Card.new(value: "QUEEN", suit: "clubs")
    ]

    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).not_to eq StraightFlush
    expect(CardAnalyzer.new.find_hand(not_a_straight_flush).class).to eq Flush
  end

  it "determines a royal flush" do
    cards = [
      Card.new(value: "KING", suit: "clubs"),
      Card.new(value: "ACE", suit: "clubs"),
      Card.new(value: "QUEEN", suit: "clubs"),
      Card.new(value: "JACK", suit: "clubs"),
      Card.new(value: "10", suit: "clubs")
    ]
    expect(CardAnalyzer.new.find_hand(cards).class).to_not eq StraightFlush
    expect(CardAnalyzer.new.find_hand(cards).class).to eq RoyalFlush
  end

  it "determines a winner between two high card hands" do
    game = Game.create
    frank = game.ai_players.create(username: "Frank")
    jannet = game.ai_players.create(username: "Jannet")
    game.update(ordered_players: [frank.id, jannet.id])


    jannet.cards = [
      Card.create(value: "5", suit: "Clubs"),
      Card.create(value: "4", suit: "Clubs"),
      Card.create(value: "QUEEN", suit: "Diamonds"),
      Card.create(value: "7", suit: "Spades"),
      Card.create(value: "10", suit: "Clubs"),
      Card.create(value: "2", suit: "Hearts"),
      Card.create(value: "3", suit: "Hearts")
    ]

    frank.cards = [
      Card.create(value: "KING", suit: "Clubs"),
      Card.create(value: "5", suit: "Clubs"),
      Card.create(value: "QUEEN", suit: "Diamonds"),
      Card.create(value: "7", suit: "Spades"),
      Card.create(value: "10", suit: "Clubs"),
      Card.create(value: "2", suit: "Hearts"),
      Card.create(value: "3", suit: "Hearts")
    ]
    winner = CardAnalyzer.new.determine_winner([jannet, frank])
    expect(winner).to eq frank
  end

  # it "determines a winner between multiple two of a kind hands" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "5", suit: "Clubs"],
  #     [value: "5", suit: "Hearts"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "5", suit: "spades"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player3_cards = [
  #     [value: "KING", suit: "Clubs"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #   pair_winner = CardAnalyzer.new
  #   winner = pair_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between multiple two pair hands" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "3", suit: "Spades"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player3_cards = [
  #     [value: "7", suit: "Clubs"],
  #     [value: "3", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #   two_pair_winner = CardAnalyzer.new
  #   winner = two_pair_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end

  # it "determines the winner between same two pair" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "9", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "3", suit: "Spades"],
  #     [value: "QUEEN", suit: "Spades"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player3_cards = [
  #     [value: "7", suit: "Clubs"],
  #     [value: "3", suit: "Diamonds"],
  #     [value: "5", suit: "Diamonds"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   two_pair_winner = CardAnalyzer.new
  #   winner = two_pair_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between multiple three of a kind hands" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "3", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player3_cards = [
  #     [value: "9", suit: "Spades"],
  #     [value: "9", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #   high_card_winner = CardAnalyzer.new
  #   winner = high_card_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{bob.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between multiple of the same three of a kind hand" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "3", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"]
  #   ]
  #
  #   three_of_a_kind_winner = CardAnalyzer.new
  #   winner = three_of_a_kind_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards
  #     })
  #   expect("#{frank.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between multiple of the same high three of a kind hand" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "KING", suit: "Clubs"],
  #     [value: "KING", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "ACE", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "ACE", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "KING", suit: "Clubs"],
  #     [value: "ACE", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "ACE", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "ACE", suit: "Hearts"]
  #   ]
  #   player3_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "ACE", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "ACE", suit: "Hearts"]
  #   ]
  #
  #   three_of_a_kind_winner = CardAnalyzer.new
  #   winner = three_of_a_kind_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between straights" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "7", suit: "Clubs"],
  #     [value: "8", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "ACE", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "JACK", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "KING", suit: "Clubs"],
  #     [value: "JACK", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "8", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "JACK", suit: "Hearts"]
  #   ]
  #   player3_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "5", suit: "Hearts"],
  #     [value: "4", suit: "Hearts"]
  #   ]
  #
  #   straight_winner = CardAnalyzer.new
  #   winner = straight_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between flushes" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "6", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"],
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "ACE", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "9", suit: "Hearts"],
  #     [value: "JACK", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "KING", suit: "Diamonds"],
  #     [value: "10", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "8", suit: "Spades"],
  #     [value: "10", suit: "Diamonds"],
  #     [value: "9", suit: "Diamonds"],
  #     [value: "6", suit: "Hearts"]
  #   ]
  #   player3_cards = [
  #     [value: "2", suit: "Clubs"],
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "6", suit: "Clubs"],
  #     [value: "4", suit: "Clubs"]
  #   ]
  #
  #   flush_winner = CardAnalyzer.new
  #   winner = flush_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{bob.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between full houses" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "6", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"],
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "3", suit: "Spades"],
  #     [value: "6", suit: "Clubs"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "2", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "8", suit: "Spades"],
  #     [value: "2", suit: "Clubs"],
  #     [value: "9", suit: "Diamonds"],
  #     [value: "2", suit: "Hearts"]
  #   ]
  #   player3_cards = [
  #     [value: "9", suit: "Clubs"],
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "9", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "10", suit: "Hearts"],
  #     [value: "10", suit: "Spades"]
  #   ]
  #
  #   full_house_winner = CardAnalyzer.new
  #   winner = full_house_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between multiple four of a kind hands" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "6", suit: "Hearts"],
  #     [value: "6", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "3", suit: "Spades"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "6", suit: "Spades"],
  #     [value: "6", suit: "Clubs"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "2", suit: "Diamonds"],
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "8", suit: "Spades"],
  #     [value: "2", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Spades"],
  #     [value: "QUEEN", suit: "Hearts"]
  #   ]
  #   player3_cards = [
  #     [value: "10", suit: "Clubs"],
  #     [value: "ACE", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "9", suit: "Spades"],
  #     [value: "10", suit: "Diamonds"],
  #     [value: "10", suit: "Hearts"],
  #     [value: "10", suit: "Spades"]
  #   ]
  #
  #   four_of_kind_winner = CardAnalyzer.new
  #   winner = four_of_kind_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "determines a winner between straight flushes" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "6", suit: "Hearts"],
  #     [value: "5", suit: "Hearts"],
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"],
  #     [value: "4", suit: "Hearts"],
  #     [value: "ACE", suit: "Hearts"],
  #     [value: "2", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "2", suit: "Diamonds"],
  #     [value: "JACK", suit: "Clubs"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Clubs"],
  #     [value: "9", suit: "Clubs"],
  #     [value: "8", suit: "Clubs"]
  #   ]
  #   player3_cards = [
  #     [value: "10", suit: "Spades"],
  #     [value: "9", suit: "Spades"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "8", suit: "Spades"],
  #     [value: "7", suit: "Spades"],
  #     [value: "10", suit: "Hearts"],
  #     [value: "6", suit: "Spades"]
  #   ]
  #
  #   straight_flush_winner = CardAnalyzer.new
  #   winner = straight_flush_winner.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{jannet.id} ai_player").to eq winner
  # end
  #
  # it "handles a tie game" do
  #   game = Game.create
  #   frank = game.ai_players.create(username: "Frank")
  #   jannet = game.ai_players.create(username: "Jannet")
  #   bob = game.ai_players.create(username: "bob")
  #
  #   player1_cards = [
  #     [value: "6", suit: "Hearts"],
  #     [value: "5", suit: "Hearts"],
  #     [value: "QUEEN", suit: "Hearts"],
  #     [value: "3", suit: "Hearts"],
  #     [value: "4", suit: "Hearts"],
  #     [value: "ACE", suit: "Hearts"],
  #     [value: "2", suit: "Hearts"]
  #   ]
  #
  #   player2_cards = [
  #     [value: "6", suit: "Clubs"],
  #     [value: "5", suit: "Clubs"],
  #     [value: "QUEEN", suit: "Clubs"],
  #     [value: "3", suit: "Clubs"],
  #     [value: "4", suit: "Clubs"],
  #     [value: "10", suit: "Clubs"],
  #     [value: "2", suit: "Clubs"]
  #   ]
  #   player3_cards = [
  #     [value: "2", suit: "Spades"],
  #     [value: "4", suit: "Spades"],
  #     [value: "QUEEN", suit: "Diamonds"],
  #     [value: "9", suit: "Spades"],
  #     [value: "5", suit: "Spades"],
  #     [value: "3", suit: "Spades"],
  #     [value: "6", suit: "Spades"]
  #   ]
  #   tie = CardAnalyzer.new
  #   winner = tie.determine_winner({
  #     frank => player1_cards,
  #     jannet => player2_cards,
  #     bob => player3_cards
  #     })
  #   expect("#{frank.id} ai_player, #{jannet.id} ai_player, #{bob.id} ai_player").to eq winner
  # end
end
