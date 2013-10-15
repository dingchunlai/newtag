class HejiaIndexKeyword < ActiveRecord::Base
  include ConnIndex

  def self.keyword_to_id(keyword)
    return 0 if keyword.blank?
    return 29835 if keyword == "装修"
    memkey = "hejia_index_keyword_to_id_#{keyword}"
    CACHE.fetch(memkey, 2.weeks) do
      kw = HejiaIndexKeyword.find(:first, :select=>"id", :conditions=>["name = ?", keyword])
      kw && kw.id || 0
    end
  end

  def self.get_keywords_by_index_id(index_id, limit=15)
    kw = get_key("hejia_index_keywords_by_index_id_1", index_id)
    keywords = get_memcache(kw, 5.days) do
      HejiaIndexKeyword.find(:all, :select=>"k.name", :joins=>"k, hejia_indexes_keywords ik", :conditions=>"k.id = ik.keyword_id and ik.index_id = #{index_id}", :limit => 15).map{|r| r["name"]}.uniq
    end
    return keywords[0..limit-1]
  end

  def self.get_keywords(limit)
#    kw = get_key("hejia_index_keywords_1")
#    keywords = get_memcache(kw, 2.days) do
     keywords = HejiaIndexKeyword.find(:all, :select=>"name",:order=>"entity_counter desc", :limit => 232).map{|r| r["name"]}
#    end
    return keywords[0..limit-1]
  end

end
