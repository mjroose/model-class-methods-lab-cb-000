class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    limit(5)
  end

  def self.dinghy
    where("length < 20")
  end

  def self.ship
    where("length >= 20")
  end

  def self.without_a_captain
    where({ captain_id: nil })
  end

  def self.last_three_alphabetically
    order(name: :desc).limit(3)
  end

  def self.sailboats
    sailboat = Classification.find_by(name: "Sailboat")
    self.joins(:boat_classifications).where({:boat_classifications => {classification: sailboat} })
  end

  def self.with_three_classifications
    Boat.joins(:boat_classifications).group("boats.id").having("COUNT(boat_classifications.boat_id) >= 3")
  end
end

# SELECT boats.id, name, COUNT(boat_classifications.boat_id) AS count FROM boats
# JOIN boat_classifications ON boat_classifications.boat_id = boats.id
# GROUP BY boats.id
# HAVING (count) >= 3;
