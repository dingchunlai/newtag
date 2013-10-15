class HejiaSearchTag < ActiveRecord::Base
  include ConnIndex
  def self.step(name, num)
    num = num.to_i
    if ne(name) && num != 0
      kw = self.find_by_name(name)
      if kw.nil?
        self.create({:name=>name,:counter=>num})
      else
        kw.counter = kw.counter + num
        kw.save
      end
    end
  end


end
