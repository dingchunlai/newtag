module ConnIndex
  def self.included(c)  
    c.establish_connection "index_#{ENV['RAILS_ENV']}".to_sym
  end
end