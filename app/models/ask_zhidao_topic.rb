class AskZhidaoTopic < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  def self.get_asks(keyword, limit=3)
    keyword.to_s.strip!
    return [] if keyword.empty?
    kw = get_key("mk_asks_2", keyword)
    asks = get_memcache(kw, 3.days) do
      conditions = []
      conditions << "is_delete = 0"
      conditions << "subject like ?"
      AskZhidaoTopic.find(:all,:select=>"id,subject",:conditions=>[conditions.join(" and "), "%#{keyword}%"], :order=>"created_at desc", :limit=>3)
    end
    return asks[0...limit]
  end

end
