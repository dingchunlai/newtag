class ZhuanquCw < ActiveRecord::Base
  #compound word 图库复合词

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

end