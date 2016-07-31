class Flush
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.group_by(&:suit)
    .values.any? { |suits| suits.size > 4 }
  end
end

class FourOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value)
      .values.any? { |cards| cards.size == 4 }
  end
end

class FullHouse
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    full_house = cards.group_by(&:value).values.select do |cards|
      cards.size > 1
    end
    full_house.size > 1 &&
    full_house.any? { |cards| cards.size == 3 }
  end
end

class HighCard
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.size > 0
  end
end

class RoyalFlush
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    return false if cards.size < 5
    potential_royal = cards.group_by(&:suit)
    suited_cards = potential_royal.values.max_by do |cards|
      cards.size
    end.map(&:value)

    ["ACE", "KING", "QUEEN", "JACK", "10"].all? do |value|
      suited_cards.include?(value)
    end
  end
end

class StraightFlush
  include CardHelper

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    return false if cards.size < 5
    sorted_values = sorted_card_values(cards)

    all_cards = [sorted_values[0..4], sorted_values[1..5], sorted_values[2..6]]
    all_cards.any? do |five_cards|
      [Flush.new(five_cards), Straight.new(five_cards)].all?(&:match?)
    end
  end
end

class Straight
  include CardHelper
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    return false if cards.size < 5
    straight = []
    sorted_values = card_converter(cards).sort_by do |card|
      card.value.to_i
    end.map { |card| card.value.to_i }.uniq

    while sorted_values.size > 0 do
      if sorted_values[1].nil? || sorted_values.first + 1 == sorted_values[1]
        straight << sorted_values.first
      else
        straight = [] if straight.size < 4
      end
      sorted_values.shift
    end
    straight.size > 4
  end
end

class ThreeOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value)
      .values.any? { |cards| cards.size == 3 }
  end
end

class TwoOfKind
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards
      .group_by(&:value)
      .values.any? { |cards| cards.size == 2 }
  end
end

class TwoPair
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def match?
    cards.group_by(&:value)
    .values.select { |values| values.size == 2 }.size > 1
  end
end

class CardAnalyzer
  include CardHelper
  # the order of this collection is important. it is in order by hands' values
  HANDS = [RoyalFlush, StraightFlush, FourOfKind, FullHouse, Flush, Straight, ThreeOfKind, TwoPair, TwoOfKind, HighCard]

  def find_hand(cards)
    HANDS
      .map { |hand| hand.new(cards) }
      .detect(&:match?)
  end

  def determine_winner(players)
    top_hand = players.min_by do |player|
      HANDS.index(find_hand(player.cards).class)
    end.cards
    players_with_top_hands = players.select do |player|
      find_hand(player.cards).class == find_hand(top_hand).class
    end
    best_hand(players_with_top_hands)
  end

  def best_hand(players)
    if players.size == 1
      players.first
    else
      players_best_five_cards = players.map { |player| [player, find_best(player.cards)] }
        .sort_by do |player_hand|
        player_hand.last.map { |card| card.value.to_i }
      end
      check_tie(players_best_five_cards)
    end
  end

  def check_tie(players_with_hands)
    return players_with_hands.last.first if players_with_hands.one? do |player|
      player.last.map(&:value) == players_with_hands.last.last.map(&:value)
    end
    players_with_hands.select do |player|
      player.last.map(&:value) == players_with_hands.last.last.map(&:value)
    end.map(&:first)
  end

  def index_hand(cards)
    HANDS.index(find_hand(cards).class)
  end
end
