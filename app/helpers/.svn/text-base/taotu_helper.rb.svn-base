module TaotuHelper
  
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
  
  #案例图片地址
  def case_img_url id
    "http://img.51hejia.com/files/hekea/case_img/tn/#{id}.jpg"
  end
  #案例URL
  def case_url(city, firm_id, case_id)
    "http://z.#{city}.51hejia.com/gs-#{firm_id}/cases-#{case_id}"
  end
  #日记URL
  def get_diary_url(city, firm_id, diary_id)
    "http://z.#{city}.51hejia.com/gs-#{firm_id}/zhuangxiugushi/#{diary_id}"
  end
  
  
 
end
