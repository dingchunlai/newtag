module PublicModule

  #数据获取及处理
  def mc(keyword,value=nil,expire_hours=72)  #memorycache快捷存取方法
    keyword = keyword.to_s.gsub(" ","")
    if value.nil?
      return CACHE.get(keyword)
    else
      if expire_hours == 0
        CACHE.set(keyword, value)
      else
        CACHE.set(keyword, value, expire_hours * 60 * 60)
      end
    end
  end
  #将指定的url内容保存为静态文件
  def save_url_to_file(url, path="", filename="index.html")
    begin
      require 'open-uri'
      path = "/#{path}/".gsub("\\","/").gsub("//","/").gsub("//","/").sub("/public","")
      save_path = "#{RAILS_ROOT}/public#{path}"
      str = open(url) do |f|
        f.read
      end
      dirs = path.split("/")
      if dirs.length > 0
        dirs.shift if dirs[0].length == 0
        dirs.pop if dirs[dirs.length-1].length == 0
        0.upto(dirs.length-1) do |i|
          dir = "#{RAILS_ROOT}/public/#{dirs[0..i].join("/")}"
          Dir.mkdir(dir) unless File.exist?(dir)  #创建每个不存在的文件夹
        end
      end
      file = File.new("#{save_path}#{filename}", "w")
      file.print(str)
      file.close_write
      return "<a href='#{path}#{filename}' target='_blank'>#{path}#{filename}</a>"
    rescue Exception => e
      return e.to_s
    end
  end
  def get_case_id(kw) #通过关键词取得案例ID
    conditions = []
    conditions << "TAGESTATE='0' and TAGTYPE='case'"
    conditions << "TAGNAME='#{kw}'"
    tag_id = HejiaTag.find(:first,:select=>"TAGID",:conditions=>conditions.join(" and ")).TAGID rescue 0
    @case_keyword = kw if tag_id.to_i > 0
    return tag_id
  end
  def get_memcache_key_prefix(key_name)  #取得key_name相关缓存关键字前缀
    return "" if trim(key_name).length == 0
    rv = mc(key_name)
    if rv.nil?
      rv = "#{key_name}#{rand(5000)+1}"
      mc(key_name, rv)
    end
    return rv
  end
  def set_update_cache  #设置在某些环境则将更新缓存参数 @update_cache 设为 true
    if RAILS_ENV == "development" || request.env["SERVER_NAME"] == "tag.51hejia.com"
      @update_cache = true
    end
  end
  def get_mc_kw(sort, *kws)   #获取memcache关键词
    return [get_memcache_key_prefix(sort)].concat(kws).join("_").gsub(" ","")
  end
  def get_mc(kw_mc, update_cache=false, expire_hours=72)   #尝试获取相应关键字的memcache信息
    update_cache = false if update_cache == 0 || update_cache.nil?
    update_cache = true if update_cache == 1
    kw_mc = kw_mc.gsub(" ","")
    rv = mc(kw_mc)
    if rv.nil? || update_cache
      rv = yield
      mc(kw_mc, rv, expire_hours)
    end
    return rv
  end
  def get_rs_by_any_keywords(kws, limit)  #取得“通过多个关键字查询到的数据集合”，并返回其中指定记录数。
    ars = []
    for kw in kws.split(",")
      rs = yield(kw, limit)
      for r in rs
        ars << r
        return ars if ars.length == limit
      end
    end
    return ars
  end

  #解析api对应栏目的xml输出
  def parse_xml(xml, parameters, end_num = 999, expire_time = 2.hours)
    column_id = xml.to_s.gsub("http://api.51hejia.com/rest/build/xml/", "").gsub(".xml", "")
    key = "key_publish_article_right_column_#{column_id}"
    PUBLISH_CACHE.delete(key) if params[:no_cache].to_i == 1
    rst = PUBLISH_CACHE.fetch(key, expire_time) do
      rs = hejia_promotion_items(column_id, {:select=>parameters.map{|e| e.gsub("-","_")}.join(","),:limit=>100})
      results = []
      rs[0...end_num].each do |r|
        r["image-url"] = r["image_url"] = "http://img.51hejia.com/api#{r["image_url"]}"
        results << r
      end
      results
    end
    #为了兼容就代码和hejia_promotion_items取出的内容部一样而做以下处理
    results = []
    rst.each do |r|
      r["image_url"] = r["image-url"]
      results << r
    end
    return results
  end
  
  def get_redirect_key_url(name)
    if @redirect_key.nil?
      @redirect_key = Hash.new
      @redirect_key["新闻"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["行业"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["资讯"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["卖场"] = "http://www.51hejia.com/maichang/"
      @redirect_key["博客"] = "http://blog.51hejia.com/"
      @redirect_key["装修"] = "http://d.51hejia.com/"
      @redirect_key["地板"] = "http://www.51hejia.com/diban/"
      @redirect_key["涂料"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["油漆"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["瓷砖"] = "http://www.51hejia.com/cizhuan/"
      @redirect_key["布艺"] = "http://www.51hejia.com/buyi/"
      @redirect_key["家具"] = "http://www.51hejia.com/jiajuchanpin/"
      @redirect_key["家电"] = "http://www.51hejia.com/jiadian/"
      @redirect_key["灯具"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["灯饰"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["照明"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["采暖"] = "http://www.51hejia.com/cainuan/"
      @redirect_key["厨房橱柜"] = "http://www.51hejia.com/chuguipindao/"
      @redirect_key["卫生间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["洗手间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["中央空调"] = "http://www.51hejia.com/kongtiao/"
      @redirect_key["水处理"] = "http://www.51hejia.com/shuichuli/"
      @redirect_key["装饰"] = "http://www.51hejia.com/jushang/"
      @redirect_key["时尚家居"] = "http://www.51hejia.com/jushang/"
      @redirect_key["厨房"] = "http://www.51hejia.com/chufang/"
      @redirect_key["卫浴"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["卫生间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["洗手间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["客厅"] = "http://www.51hejia.com/keting/"
      @redirect_key["卧室"] = "http://www.51hejia.com/woshi/"
      @redirect_key["书房"] = "http://www.51hejia.com/shufang/"
      @redirect_key["花园"] = "http://www.51hejia.com/huayuanshenghuo/"
      @redirect_key["背景墙"] = "http://www.51hejia.com/beijingqiang/"
      @redirect_key["儿童房"] = "http://www.51hejia.com/ertongfang/"
      @redirect_key["小户型"] = "http://www.51hejia.com/xiaohuxing/"
      @redirect_key["公寓"] = "http://www.51hejia.com/gongyu/"
      @redirect_key["二手房"] = "http://www.51hejia.com/ershoufang/"
      @redirect_key["主妇"] = "http://www.51hejia.com/chaojizhufu/"
      @redirect_key["别墅"] = "http://www.51hejia.com/bieshu/"
      @redirect_key["品牌"] = "http://b.51hejia.com/"
    end
    return @redirect_key[name]
  end

  def tuku_photo_url_truncate(filepath,first,max)
    if filepath.nil? then return end
    cs = filepath.split(//)
    if cs.length>max
      str = cs[first.to_i,max.to_i].to_s

      return str
    else

      return filepath
    end
  end
    
  def get_tuku_photo_url(type_id, filepath)
    return nil if filepath.nil?
    way = tuku_photo_url_truncate(filepath,0,8)
    way1 = filepath[9..-5]
    if type_id.to_i == 5
      image = "http://image.51hejia.com#{filepath}"
    else
      if left(filepath,1) == "/"
        way = "small" + filepath
      elsif filepath.length > 35
        way = filepath
      else
        if way1 == "img201007271280161471"
          way = filepath
        else
          way = way + "/tn/" + way1 + "_s" + filepath[-4..-1]
        end
      end
      image = "http://image.51hejia.com/files/hekea/case_img/#{way}"
    end
    return image
  end

  def get_tuku_big_photo_url(path)
    if path.include?("UserFiles/") || path.include?("binary/")
      return "http://image.51hejia.com#{path}"
    else
      return "http://image.51hejia.com/files/hekea/case_img/#{path}"
    end
  end

  def get_photo_tag_id(name)
    pt = PhotoTag.find(:first,:select=>"id",:conditions=>["name = ?", name])
    if pt.nil?
      tag_id = 0
    else
      tag_id = pt.id
    end
    return tag_id
  end

  def get_case_title_by_case_id(case_id)
    kw_mc = get_mc_kw("dantu_mk","case_title",case_id)
    return get_mc(kw_mc) do
      HejiaCase.find(:first,:select => "ID, NAME",:conditions=>["ID = ?", case_id]).NAME rescue ""
    end
  end

  def paging_record_for_hejia_indexs(h) #生成分页记录集函数，反馈参数 params[:page] 和 params[:recordcount]
    @pagesize = h["pagesize"].to_i if @pagesize.nil?
    @listsize = h["listsize"].to_i if @listsize.nil?
    @curpage = params[:page].to_i if @curpage.nil?
    @recordcount = params[:recordcount].to_i if @recordcount.nil?

    @pagesize = 12 if @pagesize.to_i < 1
    @listsize = 10 if @listsize.to_i < 1
    @curpage = 1 if @curpage.to_i < 1
        
    if h["primary_key"].nil?
      primary_key = "id"
    else
      primary_key = h["primary_key"]
    end
    if h["conditions"].nil? || h["conditions"] == ""
      conditions = nil
    else
      conditions = h["conditions"]
    end
    if @recordcount.to_i < 1
      @recordcount = h["model"].count(primary_key, :conditions => conditions, :group => h["group"], :joins => h["joins"])
    end
    @pagecount = (@recordcount.to_f / @pagesize.to_f).ceil
    if @recordcount.to_i < 1
      return []
    else
      return h["model"].find(:all,
        :select => h["select"],
        :conditions => conditions,
        :order => h["order"],
        :group => h["group"],
        :joins => h["joins"],
        :offset => @pagesize * (@curpage - 1),
        :limit => @pagesize)
    end
    
  end

  def iconv(str)
    if ENV['RAILS_ENV'] == "development"
      return iconv_utf8(str)
    else
      return iconv_gb2312(str)
    end
  end
  def r_iconv(str)
    if ENV['RAILS_ENV'] == "development"
      return iconv_gb2312(str)
    else
      return iconv_utf8(str)
    end
  end

  #数据库相关
  def dosql(str)
    return ActiveRecord::Base.connection.execute(str)
  end

  #字符串相关
  def strip(str)
    return trim(str)
  end
  def trim(str)
    str = str.to_s
    if str.length > 0
      return str.lstrip.rstrip
    else
      return ""
    end
  end
  def left(str, length)
    str = trim(str)
    if str.length > 0
      return str[0, length]
    else
      return ""
    end
  end
  def right(str, length)
    str = trim(str)
    if str.length > 0
      if str.length > length
        return str[str.length - length, length]
      else
        return str
      end
    else
      return ""
    end
  end
  def replace(str, str1, str2)
    return str.gsub(str1, str2) if str
  end
  def ne(param) #not_empty 判断一个变量是否可转换为有内容的字符串
    str = param.to_s
    if str.length == 0
      return false
    elsif str.gsub(" ","").gsub("　","").length == 0
      return false
    else
      return true
    end
  end
  def fp(v) #format_params 格式化参数
    if v.is_a?(Array)
      str = ""
      0.upto(v.size-1) do |i|
        str += trim(v[i])
        str += "," if i < v.size-1
      end
      return str
    else
      return trim(v)
    end
  end
  def iconv_gb18030(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb18030", str).join("") : str;
    rescue
      str;
    end
  end
  def iconv_gb2312(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb2312", str).join("") : str;
    rescue
      str;
    end
  end
  def iconv_utf8(str)
    begin
      str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
    rescue
      str;
    end
  end

  #客户端相关
  def auto_redirecting(url, max_age=99999)
    return "<html><head><meta http-equiv='Cache-Control' content='max-age=#{max_age}' /><script language='javascript'>location.replace('#{url}');</script></head></html>"
  end
  def alert(str, *p)
    return js("alert(\"#{str}\")")
  end
  def alert_error(str, *p)
    return js("alert(\"#{str}\")")
  end
  def js(str, *p)
    return "<script type=\"text/javascript\">#{str.to_s}</script>"
  end
  def top_load(url)
    if ne(url) && url != "self"
      url = "\"" + url + "\""
      return "top.location.href = " + url.to_s
    else
      return "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
    end
  end

  #其它功能
  def get_error(exception)
    if SHOW_ERROR
      return exception.to_s
    else
      return "程序出现了异常，您可以通过设置 SHOW_ERROR 参数为 true 来显示详细的异常信息。"
    end
  end
  def show_notice(str) #显示布告
    render :text => "<div style='line-height:30px; padding:30px'><b>#{str}</b><br /><br />\
  <a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a>"
  end
  def getnow()
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  def datediff(time1, time2)
    return ((time2 - time1)/(60*60*24)).to_i
  end
  def dateadd(time1, days)
    return time1 + days * (60*60*24)
  end
  
end
