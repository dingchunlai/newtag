class ZhuanquKw < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  def self.get_kw_names_by_sort_id(sort_id)
    kw = get_key("kw_names_by_sort_id_2", sort_id)
    return get_memcache(kw, 15.days) do
      ZhuanquKw.find(:all,:select=>"id, kw_name",:conditions=>"sort_id = #{sort_id} and is_delete = 0 and is_published = 1").map{|r| r.kw_name}
    end
  end

  #获取关键字专区相关信息
  def self.info(keyword)
    keyword.to_s.strip!
    key = "zhuanqu_kw_info_#{keyword}"
    CACHE.fetch(key, 3.hours) do
      (keyword.blank?) ? nil : ZhuanquKw.find(:first,:select=>"k.*, s.board_id, s.sort_name",:joins=>"k, zhuanqu_sorts s",
        :conditions=>["k.sort_id=s.id and k.kw_name = ?", keyword])
    end
  end

  def board
    begin
      sort = ZhuanquSort.find(sort_id, :select => 'board_id')
    rescue
      sort = nil
    end
    ZHUANQU_BOARD_SPELL[sort && sort.board_id || 0]
  end

  def self.baoming_qita_kwywords(sort_id)
    key = "baoming_qita_kwywords_#{sort_id}"
    CACHE.fetch(key, 12.hours) do
      all_keywords = ZhuanquKw.find(:all, :select => "id,sort_id,kw_name", :conditions => "is_delete = 0 and sort_id = #{sort_id}").map{|zk| zk.kw_name}
      qita_keywords = all_keywords - ["现代简约婚房","简约小户型","现代简约公寓","现代简约风格装修","简约风格装修","简约设计","现代简约风格","简约风格"]
      qita_keywords = qita_keywords - ["简约田园风格装修","田园风格婚房","田园小户型","韩式田园风格装修","田园风格设计","田园风格装修","韩式田园风格"]
      qita_keywords = qita_keywords - ["欧式田园风格装修","欧式公寓","现代欧式风格","欧式风格装修","简约欧式风格","欧式古典风格","欧式田园风格"]
      qita_keywords = qita_keywords - ["明清中式风格","中式古典风格装修","中式小户型","新中式风格","中式家具","中式设计","新中式风格装修","现代中式风格装修","中式风格装修","中式古典风格","现代中式风格"]
      qita_keywords = qita_keywords - ["地中海小户型","地中海风格装修","地中海田园风格装修"]
      qita_keywords = qita_keywords - ["宜家风格装修","宜家样板房","宜家样板间","上海宜家","宜家家居"]
      qita_keywords
    end
  end

  def baoming_keyword_links
    baoming_key = ""
    baoming_keywords = [
      ["jy",["现代简约婚房","简约小户型","现代简约公寓","现代简约风格装修","简约风格装修","简约设计","现代简约风格","简约风格"]],
      ["ty",["简约田园风格装修","田园风格婚房","田园小户型","韩式田园风格装修","田园风格设计","田园风格装修","韩式田园风格"]],
      ["os",["欧式田园风格装修","欧式公寓","现代欧式风格","欧式风格装修","简约欧式风格","欧式古典风格","欧式田园风格"]],
      ["zs",["明清中式风格","中式古典风格装修","中式小户型","新中式风格","中式家具","中式设计","新中式风格装修","现代中式风格装修","中式风格装修","中式古典风格","现代中式风格"]],
      ["dzh",["地中海小户型","地中海风格装修","地中海田园风格装修"]],
      ["yj",["宜家风格装修","宜家样板房","宜家样板间","上海宜家","宜家家居"]],
      ["qt",ZhuanquKw.baoming_qita_kwywords(169)]
    ]
    for baoming_keyword in baoming_keywords
      if baoming_keyword[1].include?(self.kw_name)
        baoming_key = baoming_keyword[0]
        break;
      end
      unless baoming_key.blank?
        break;
      end
    end

    baoming_key
  end

end
