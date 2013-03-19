class Monopoly
  def run(players)
  end
end

class Board
  attr_reader :players
end

class Player
  attr_reader :name, :piece, :money, :properties

  def in_jail?
  end

  def add_money(money)
  end

  def dec_money(money)
  end

  def buy_property?(property)
  end

  def roll_the_dice(dices)
  end
end

class HumanPlayer < Player
end

class ComputerPlayer < Player
end

class Dice
  def roll
  end
end

class Bank
  def give(money)
  end
  def take(money)
  end
end

class Square
  attr_reader :name
  def do_something(landing_player)
  end
end

class Property < Square
  attr_reader
    :purchase_price,
    :mortgage_value,
    :owner,
    :chain

  def do_something(landing_player)
  end

  #buyable
  def buy(player)
  end

  def mortgage
  end

  def mortgaged?
  end

  def monopolized?
  end

  def rent(victim)
  end

  def sell(buyer, price)
  end


end

class RealEstate < Property
  attr_reader :buildings, :house_cost, :hotel_cost
  #buildable

  def build_house
  end

  def build_hotel
  end

  def rent(victim)
  end

  def mortgage
  end

  def sell_house
  end

  def sell_hotel
  end
end

class RailRoads < Property
end

class Utilities < Property
end

class Jail < Square
  attr_reader :inmates, :visitors
  def do_something(landing_player)
    incarcerate(landing_player)
  end
  def incarcerate(player, turns)
  end
end

class Taxes < Square
  def do_something(landing_player)
    incarcerate(landing_player)
  end

  def taxable_amount(player)
  end
end

class ChanceSquare < Square
  def draw_card(player)
  end
end

class Cards
  attr_reader :description
end

class Chance < Cards
end

class CommunityChest < Cards
end