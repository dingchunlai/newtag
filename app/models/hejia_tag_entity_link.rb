class HejiaTagEntityLink < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "HEJIA_TAG_ENTITY_LINK"

end
