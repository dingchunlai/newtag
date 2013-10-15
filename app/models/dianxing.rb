class Dianxing < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  def self.get_dianxing(spell)
    Dianxing.find(:first,:conditions=>["spell = ? and is_delete=0", spell])
  end

end
