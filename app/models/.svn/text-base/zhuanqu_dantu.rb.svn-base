class ZhuanquDantu < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  def self.get_dantu(keyword)
    kw = get_key("dantu_1", keyword)
    ZhuanquDantu
    return get_memcache(kw, 1.day) do
      ZhuanquDantu.find(:first,
        :select=>"id,name,sort_id,split,haoping,chaping,description,about_links,html_title,html_keywords,html_description,is_delete",
        :conditions=>["name = ? and is_delete = 0", keyword])
    end
  end

  def self.get_dantu_keywords(keyword)
    dantu = self.get_dantu(keyword)
    if dantu.nil?
      return []
    else
      return dantu["split"].to_s.strip.split(",")
    end
  end

end
