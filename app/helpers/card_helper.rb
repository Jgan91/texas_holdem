module CardHelper
  def card_converter(cards)
    cards.map do |card|
      case card.value
      when "ACE"
        ace_low?(cards) ? Card.new(value: 1, suit: card.suit) : Card.new(value: 14, suit: card.suit)
      when "KING"
        Card.new(value: 13, suit: card.suit)
      when "QUEEN"
        Card.new(value: 12, suit: card.suit)
      when "JACK"
        Card.new(value: 11, suit: card.suit)
      else
        Card.new(value: card.value.to_i, suit: card.suit)
      end
    end
  end

  def ace_low?(cards)
    card_values = cards.map { |card| card.value.to_i }
    [card_values.include?(2),
      card_values.include?(3),
      card_values.include?(4),
      card_values.include?(5)].all?
  end

  def sorted_card_values(cards)
    card_converter(cards).sort_by do |card|
      card.value.to_i
    end
  end

  def find_best(cards)
    hand = find_hand(cards).class
    return sorted_card_values(cards).reverse[0..4] if hand == HighCard
    
    remaining = sorted_card_values(cards).reject do |card|
      essential_cards(cards, hand).map(&:value).include?(card.value)
    end.reverse
    (essential_cards(cards, hand).reverse + remaining)[0..4]
  end

  def essential_cards(cards, hand)
    sorted_cards = sorted_card_values(cards)
    essential_cards = []
    place_holder = 0
    sorted_cards.each do |card|
      if find_hand(sorted_cards.reject { |match| match == card }).class != hand
        essential_cards << card
      else
        sorted_cards[sorted_cards.index(card)] = Card.new(value: place_holder, suit: place_holder)
      end
      place_holder -= 1
    end
    essential_cards
  end
end
