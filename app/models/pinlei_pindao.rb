class PinleiPindao < ActiveRecord::Base
  # validates_presence_of :name,:spell
  # validates_uniqueness_of :name,:spell

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  def self.get_pinlei(spell)
    PinleiPindao.find(:first,:conditions=>["spell = ? and is_delete=0", spell])
  end

end
