# Methods added to this helper will be available to all templates in the application.
include PublicModule
include LsbLib::PublicMethod

module ApplicationHelper

  def render_ad(id, remark="", type="afp")
    remark = "#{type}广告代码　" + remark + "　"
    if type=="afp"
      <<START
      
      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    elsif type=="openx"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type='text/javascript'><!--//<![CDATA[
      var m3_u = (location.protocol=='https:'?'https://a.51hejia.com/www/delivery/ajs.php':'http://a.51hejia.com/www/delivery/ajs.php');
      var m3_r = Math.floor(Math.random()*99999999999);
      if (!document.MAX_used) document.MAX_used = ',';
      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
      document.write ("?zoneid=#{id}");
      document.write ('&amp;cb=' + m3_r);
      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
      document.write ("&amp;loc=" + escape(window.location));
      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
      if (document.context) document.write ("&context=" + escape(document.context));
      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
      document.write ("'><\/scr"+"ipt>");
      //]]>--></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    end
  end

  def zhuangxiu?
    return true if request.env["SERVER_NAME"]=="d.51hejia.com"
    return false
  end

  def pinpai?
    server = request.env["SERVER_NAME"]
    return true if server=="prod.51hejia.com" || server=="b.51hejia.com" || server=="news.51hejia.com"
    return false
  end

  def render_brand_ga?
    return true if request.env["SERVER_NAME"]=="b.51hejia.com"
    return false
  end

  def ul(str, len, preview=0, replacer="...")
    if preview == 1
      str = ""
      99.times { str += "预览内容" }
    end
    str = strip_tags(str.to_s)
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  def get_zq_inner_link(keyword, classname="", showname=keyword, only_get_url=false) #取得专区内部链接
    keyword = keyword.to_s.strip
    url = zq_url(keyword)
    htmlclass = ""
    htmlclass = " class='#{classname}'" if classname.to_s.length > 0
    if only_get_url
      return url
    else
      return "<a href='#{url}' target='_blank' #{htmlclass}>#{showname}</a>"
    end
  end

  def get_tuku_link(keyword, classname="", v_name=keyword, only_get_url=false) #取得图库专区链接
    htmlclass = ""
    htmlclass = " class='#{classname}'" if classname.to_s.length > 0
    url = tuku_url(keyword)
    if only_get_url
      return url
    else
      return "<a href='#{url}' target='_blank' #{htmlclass}>#{v_name}</a>"
    end
  end

  def zq_url(keyword)
    @zq_url = {} if @zq_url.nil?
    if @zq_url[keyword].nil?
      kw = get_key("mk_zq_inner_url", keyword)
      @zq_url[keyword] = get_memcache(kw, 1.month) do
        prefix = ""
        if keyword.length == 0
          prefix = "http://tag.51hejia.com"
          url = "/"
        elsif !(redirect_key_url = get_redirect_key_url(keyword)).nil?
          url = redirect_key_url
        elsif !(s = ZhuanquSort.find_by_sort_name(keyword,:select=>"id, board_id")).nil?
          prefix = "http://#{ZHUANQU_BOARD_SPELL[s.board_id.to_i]}.51hejia.com"
          url = "/zq/#{keyword}/"
        elsif !(k =ZhuanquKw.find_by_kw_name(keyword,:select=>"id,sort_id")).nil?
          s = ZhuanquSort.find(k.sort_id,:select=>"id, board_id, sort_name")
          sort_name = s.sort_name rescue "栏目"
          board_id = s.board_id
          prefix = "http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com"
          url = "/zq/#{sort_name}-#{keyword}.html"
        else
          prefix = "http://tag.51hejia.com"
          url = "/#{keyword}.html"
        end
        url = prefix + url unless RAILS_ENV == "development"
        url
      end
    end
    return @zq_url[keyword]
  end

  def tuku_url(keyword)
    keyword = keyword.to_s.strip
    return "" if keyword.blank?
    @tuku_url = {} if @tuku_url.nil?
    if @tuku_url[keyword].nil?
      prefix = "http://tuku.51hejia.com"
      if keyword.include?("_")
        url = "/zhuanqu/#{keyword}.html"
      else
        dantu = ZhuanquDantu.get_dantu(keyword)
        if dantu.nil?
          url = "/zhuanqu/#{keyword}.html"
        else
          url = "/pic/#{keyword}.html"
        end
      end
      url = prefix + url unless RAILS_ENV == "development"
      @tuku_url[keyword] = url
    end
    return @tuku_url[keyword]
  end

  def get_case_tags_by_case_id(case_id)	 #获取与某一个案例有关联的标签
    case_id = case_id.to_i
    return '' if case_id == 0
    memkey = "case_tags_by_case_id_2_#{case_id}"
    CACHE.fetch(memkey, 3.days) do
      HejiaTag.find(:all,
        :select=>"t.TAGNAME",
        :conditions=>"t.TAGFATHERID <> 4401 and t.TAGID=l.TAGID and t.TAGESTATE='0' and l.ENTITYID=#{case_id} and t.TAGTYPE='case' and l.LINKTYPE='case'",
        :joins =>"t, HEJIA_TAG_ENTITY_LINK l",
        :limit => 15).collect { |result| [ result.TAGNAME ]}
    end
  end

  def get_re_dian_zhuan_qu(sort_id)
    @zq_mk = get_memcache_key_prefix("zq_mk") if @zq_mk.nil?    #取得专区相关缓存关键字前缀
    sort_id = 16 if sort_id.to_i == 0
    kw_type = "#{@zq_mk}_rdzq22_#{sort_id}" #热点专区缓存关键字
    rdzq = CACHE.get(kw_type)
    if rdzq.nil?
      rs = ZhuanquKw.find(:all,:select=>"kw_name",:conditions=>"sort_id = #{sort_id} and is_delete = 0 and is_published=1")
      rdzq = []
      for r in rs
        rdzq << r.kw_name
      end
      CACHE.set(kw_type, rdzq)
    end
    return rdzq
  end

  def get_articles_by_editor_keyword(keyword, limit=15)
    keyword_id = HejiaIndexKeyword.keyword_to_id(keyword)
    return [] if keyword_id == 0
    memkey = HejiaIndex.articles_memkey(keyword_id)
    rvs = CACHE.fetch(memkey, 1.day) do
      conditions = []
      conditions << "i.entity_id = r.entity_id"
      conditions << "r.keyword_id = #{keyword_id}"
      conditions << "i.entity_type_id = 1"
      conditions << "r.relation_type = 1"
      HejiaIndex.find(:all,:select=>"i.id, i.entity_id, i.title,i.url",
        :joins=>"i, relations r",
        :conditions=>conditions.join(" and "),
        :order=>"i.entity_updated_at desc",
        :limit=>15).collect{ |r| {"id"=>r["id"], "entity_id"=>r["entity_id"], "title"=>r["title"], "url"=>r["url"]} }
    end
    return rvs[0...limit]
  end

  def get_articles_by_ids(ids, limit=6)
    ids = ids.to_s.gsub(","," ").split(" ")
    return [] if ids.length == 0
    kw_mc = get_mc_kw("zq_mk", "articles_by_ids", ids.join("_"))
    HejiaIndex
    rvs = get_mc(kw_mc) do
      conditions = []
      conditions << "entity_id in (#{ids.join(",")})"
      conditions << "entity_type_id = 1"
      indexes = HejiaIndex.find(:all,:select=>"entity_id,title,url",:conditions=>conditions.join(" and "))
      rs=[]
      ids.each do |id|
        a = indexes.detect {|e| e.entity_id.to_i == id.to_i}
        rs << {"title"=>a["title"], "url"=>a["url"]} unless a.nil?
      end
      rs
    end
    return rvs[0..limit-1]
  end

  def get_photos_by_case_id(case_id)
    @taotu_mk = get_memcache_key_prefix("taotu_mk") if @taotu_mk.nil?    #取得专区相关缓存关键字前缀
    kw_mc = "#{@taotu_mk}gpbci3_#{case_id}"
    ps = mc(kw_mc)
    if ps.nil?
      ps = PhotoPhoto.find(:all,:select=>"type_id,filepath",:conditions=>"case_id = #{case_id}",:limit=>4).collect {|r| [get_tuku_photo_url(r.type_id, r.filepath)]}
      mc(kw_mc, ps) if ps.length > 0
    end
    return ps
  end

  def get_tuku_taotu_or_dantu(keyword, limit)
    #尝试取得套图记录
    taotus = HejiaCase.get_cases(keyword)[0...limit].map{ |r| {
        :title => r.title,
        :image_url => r.image_url,
        #:url => r.url
        :url => "http://tuku.51hejia.com/zhuangxiu/tuku-#{r.ID}"
      }
    }

    dantus = []
    if taotus.length < limit  #如果套图图片不足
      if get_tuku_link(keyword).include?("/pic/") #如果是单图专区关键字，尝试取得单图记录
        dantus = PhotoPhoto.get_dantus(keyword, 1).collect { |r| {
            :title => get_case_title_by_case_id(r.case_id),
            :image_url => get_tuku_photo_url(r.type_id, r.filepath),
            #:url => "http://tuku.51hejia.com/pic/#{keyword}/#{r.id}.html"
            :url => "http://tuku.51hejia.com/zhuangxiu/tuku-#{r.id}"
          }
        }
      end
    end
    return taotus.concat(dantus)[0...limit]
  end

  def get_about_list(type, keyword, limit=15)
    #type定义： 1.文章 2.博客 3.论坛 4.图片 5.产品 6.问吧
    kw_mc = get_key("mk_about_list_2", keyword, type)
    HejiaIndex
    rvs = get_memcache(kw_mc, 5.days) do
      kw = HejiaIndexKeyword.find_by_name(keyword, :select=>"id")
      if kw.nil?
        rs = []
      else
        conditions = []
        conditions << "i.id = k.index_id"
        conditions << "k.keyword_id = #{kw.id}"
        conditions << "i.entity_type_id = #{type}"
        if type.to_i == 1
          rs_limit = 30
        else
          rs_limit = 15
        end
        rs = HejiaIndex.find(:all,:select=>"i.id,i.title,i.url,i.image_url",
          :joins=>"i, hejia_indexes_keywords k",
          :conditions=>conditions.join(" and "),
          :order=>"entity_created_at desc",
          :limit=>rs_limit)
      end
      rs
    end
    return rvs[0...limit]
  end

  def get_about_list_have_images(type, keyword, limit)
    pics= get_about_list(type,keyword, limit*3)
    pics.delete_if {|pic| pic[:image_url].nil? }
    return  pics[0..limit-1]
  end

  def get_array_title_and_url(str, len=0)  #通过换行符切割文本后取得包含“title与url哈希组”的数组
    new = []
    old = str.to_s.split("\r")
    if old.length > 1
      j = 0
      0.step(old.length-1, 2) do |i|
        new << {"title" =>h(old[i]),"url" =>old[i+1]}
        j += 1
        return new if len != 0 && j == len
      end
    end
    return new
  end

  def get_case_tags_by_fahtertagid(fahtertagid)
    tags = HejiaTag.find(:all,:select=>"TAGID, TAGNAME",:conditions=>"TAGFATHERID = #{fahtertagid} and TAGESTATE='0' and TAGTYPE = 'case'")
    return tags
  end

  def get_pagelist_title(url_prefix, keyword, recordcount, pagesize, curpage)
    pagecount = (recordcount.to_f / pagesize.to_f).ceil
    return "没有任何数据记录" if pagecount == 0
    return "共1页 当前显示第1页" if pagecount == 1
    strs = ["当前显示第<b>#{curpage}</b>页"]
    if curpage != 1
      strs << "<a target=\"_self\" title=\"跳转至第#{curpage-1}页\" href=\"#{url_prefix}#{keyword}-#{curpage-1}-#{recordcount}.html\">上一页</a>"
    end
    if curpage != pagecount
      strs << "&nbsp;<a target=\"_self\" title=\"跳转至第#{curpage+1}页\" href=\"#{url_prefix}#{keyword}-#{curpage+1}-#{recordcount}.html\">下一页</a>"
    end
    return strs.join(" ")
  end

  def get_pagelist(url_prefix, keyword, recordcount, pagesize, curpage, cur_list, listsize)
    listsize_half = listsize / 2
    pagecount = (recordcount.to_f / pagesize.to_f).ceil
    return "没有任何数据记录" if pagecount == 0
    return "共1页 当前显示第1页" if pagecount == 1
    if curpage < (listsize_half)
      pages = 1..listsize
    elsif pagecount - curpage < (listsize_half)
      pages = (pagecount-listsize+1)..pagecount
    else
      pages = (curpage-listsize_half)..(curpage+listsize_half)
    end
    strs = []
    if curpage != 1
      strs << "<a target=\"_self\" title=\"跳转至首页\" href=\"#{url_prefix}#{keyword}-1-#{recordcount}.html\">首页</a>" + " <a target=\"_self\" title=\"跳转至第#{curpage-1}页\" href=\"#{url_prefix}#{keyword}-#{curpage-1}-#{recordcount}.html\">上一页</a> &nbsp;"
    end
    for page in pages
      if page > 0 && page <= pagecount
        if page == curpage
          strs << page.to_s
        else
          strs << "<a target=\"_self\" title=\"跳转至第#{page}页\" href=\"#{url_prefix}#{keyword}-#{page}-#{recordcount}.html\">#{page}</a>"
        end
      end
    end
    if curpage != pagecount
      strs << "&nbsp; <a target=\"_self\" title=\"跳转至第#{curpage+1}页\" href=\"#{url_prefix}#{keyword}-#{curpage+1}-#{recordcount}.html\">下一页</a> " + "<a target=\"_self\" title=\"跳转至第#{pagecount}页\" href=\"#{url_prefix}#{keyword}-#{pagecount}-#{recordcount}.html\">尾页</a>"
    end
    return strs.join(" ")
  end

end
