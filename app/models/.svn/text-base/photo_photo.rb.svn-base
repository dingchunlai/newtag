class PhotoPhoto < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  belongs_to :hejia_case, :class_name => 'HejiaCase', :foreign_key => 'case_id'

  def self.get_dantus(keyword, page=1)
    page = 1 if page.to_i < 1
    memkey = "memcache_photo_dantusss_#{keyword}_#{page}"
    CACHE.fetch(memkey, 1.day) do
      self.dantus(keyword, page)
    end
  end

  def self.dantus(keyword, page=1)
    PhotoPhoto.paginate(:select => "pp.id,pp.case_id,pp.type_id, pp.filepath",
      :conditions => self.dantus_conditions(keyword),
      :joins => "pp, photo_photos_tags ppt",
      :order => "id desc",
      :total_entries => self.dantus_counter(keyword),
      :page => page.to_i)
  end

  def self.dantus_counter(keyword)
    kw = get_key("mk_dantusss_counter", keyword)
    return get_memcache(kw, RAILS_ENV=="production" ? 1.hour : 1.second) do
      PhotoPhoto.count("pp.id", :conditions=>self.dantus_conditions(keyword), :joins=>"pp, photo_photos_tags ppt")
    end
  end
  
  def self.dantus_conditions(keyword)
    keywords = ZhuanquDantu.get_dantu_keywords(keyword)
    conditions = []
    if keywords.length > 1 #如果是复合词，则使用分词子搜索条件
      photo_ids = PhotoPhoto.find(:all, :select => "pp.id",
        :conditions => "ppt.tag_id = #{get_photo_tag_id(keywords[0].gsub("|","/"))} and pp.id = ppt.photo_id and pp.type_id in (3,5)",
        :joins => "pp, photo_photos_tags ppt", :limit => 30000).collect{ |r| r.id }.join(",")
      tag_id = get_photo_tag_id(keywords[1].gsub("|","/"))
      conditions << "pp.id in (#{photo_ids})" if photo_ids.to_s.length > 0
    else  #如果是单词
      tag_id = get_photo_tag_id(keyword.gsub("|","/"))
    end
    conditions << "ppt.tag_id = #{tag_id}"
    conditions << "pp.id = ppt.photo_id and pp.type_id in (3,5)"
    conditions.join(" and ")
  end



end
