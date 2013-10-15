class HejiaCountKeyword < ActiveRecord::Base

  include ConnIndex
  
  def self.get_keywords(limit)
#    kw = get_key("hejia_count_keywords_1")
#    keywords = get_memcache(kw, 2.days) do
    keywords =  HejiaCountKeyword.find(:all, :select=>"name",:order=>"counter desc",:limit=>120).map{|r| r["name"]}
#    end
    return keywords[0..limit-1]
  end

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
