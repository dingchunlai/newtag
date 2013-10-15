class ProductCategory < ActiveRecord::Base
  include ConnProduct
  self.table_name = "product_categories"
end
