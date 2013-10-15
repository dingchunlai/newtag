module ConnProduct
  def self.included(c)  
    c.establish_connection "product_#{ENV['RAILS_ENV']}".to_sym
  end
end