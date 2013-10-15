module ListHelper
  
  def get_wen_zhang_dian_ji_pai_hang(limit)
    kw_type = "wzdjph" #分类记录缓存关键字
    #CACHE.set(kw_type, nil) #开发环境
    ars = CACHE.get(kw_type)
    if ars.nil?
          conditions = []
          conditions << "entity_type_id = 1"
          conditions << "id < #{rand(100000)+5000}"
          ars = HejiaIndex.find(:all,:select=>"title,url",
            :conditions=>conditions.join(" and "),
            :order=>"id desc",
            :limit=>limit)
          ars = 2 if ars.length == 0 #2代表没有找到相应数据记录
          CACHE.set(kw_type, ars)
    end
    return ars
  end

  def get_tu_pian_xiang_guan(keyword, limit)
    kw_type = get_key("mk_tu_pian_xiang_guan", keyword)
    ars = CACHE.get(kw_type)
    if ars.nil?
      kw = HejiaIndexKeyword.find_by_name(keyword)
      if kw.nil?
          ars = 1 #1代表没有找到相应标签
      else
         conditions = []
          conditions << "i.id = k.index_id"
          conditions << "k.keyword_id = #{kw.id}"
          conditions << "i.entity_type_id = 4"
          ars = HejiaIndex.find(:all,:select=>"i.title,i.url,i.image_url",
            :joins=>"i, hejia_indexes_keywords k",
            :conditions=>conditions.join(" and "),
            :order=>"entity_created_at desc",
            :limit=>limit)
          ars = 2 if ars.length == 0 #2代表没有找到相应数据记录
      end
      CACHE.set(kw_type, ars)
    end
    return ars
  end

  def hot_keywords(limit)
      #CACHE.set("hot_keywords", nil)  #开发环境
      #HejiaCountKeyword
      HejiaIndexKeyword
      kws = CACHE.get("hot_keywords")
      if kws.nil?
        #如果没有缓存
        #kws = HejiaCountKeyword.find(:all, :select=>"name",:order=>"counter desc",:limit=>110)
        kws = HejiaIndexKeyword.find(:all, :select=>"name",:order=>"entity_counter desc", :limit => limit)
        CACHE.set("hot_keywords", kws) unless kws.nil?
      end
      return kws
  end

  
  
end
