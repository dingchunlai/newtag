class ListController < ApplicationController

  def index

  end

  def search
    require 'open-uri'
    kw = trim(params[:keyword])
    kw = trim(params[:tag_keyword]) if kw.length == 0
    if kw.length == 0
      redirect_to "http://tag.51hejia.com"
    elsif !(redirect_key_url = get_redirect_key_url(kw)).nil?
      redirect_to redirect_key_url
    elsif !(s = ZhuanquSort.find_by_sort_name(kw,:select=>"id, board_id")).nil?
      redirect_to "http://#{ZHUANQU_BOARD_SPELL[s.board_id.to_i]}.51hejia.com/zq/#{kw}"
    elsif !(k =ZhuanquKw.find_by_kw_name(kw,:select=>"id,sort_id")).nil?
      s = ZhuanquSort.find(k.sort_id,:select=>"id, board_id, sort_name")
      sort_name = s.sort_name rescue "栏目"
      board_id = s.board_id
      redirect_to "http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com/zq/#{sort_name}-#{kw}.html"
    else
      redirect_to "http://tag.51hejia.com/#{kw}.html"
    end
  end
  
  def keyword
    #logout_staff!
    #login_staff!(HejiaStaff.find(:first))
    #render :text => current_staff.inspect.to_s
    @keyword = params[:keyword].to_s.strip
    @keyword_v = @keyword
    key_len = @keyword_v.split(//u).length
    if key_len > 0 && key_len < 10
      keyword_id =  get_keyword_id(@keyword_v)
      if keyword_id > 0
        @lists = HejiaIndex.get_tag_lists(keyword_id, params[:page])
      end
    end
    @lists = [] if @lists.nil?
    render_404 if @lists.length == 0
  end

  def save_havenot_result_keyword(kw, ppl_kws)
    return false unless ne(kw)
    begin
      hrk = HavenotResultKeyword.find_by_keyword(kw)
      if hrk.nil?
        HavenotResultKeyword.create(:keyword=>kw,:ppl_kws=>ppl_kws)
      end
    rescue Exception => e
    end
  end

  def tag_view_count(keyword)
    step = 5  #设定积累step次统计才保存数据库
    kw_vc = keyword + "_vc" #view_counter 缓存关键字
    num = CACHE.get(kw_vc).to_i
    num += 1
    if num == step
      HejiaCountKeyword.step(keyword, num)
      num = 0
      #      if rand(10)==1
      #        #有一定的几率执行的代码
      #        CACHE.set("hot_keywords", nil)
      #        CACHE.set("about_keywords", nil)
      #      end
    end
    CACHE.set(kw_vc, num)
  end

  def ppl(keyword)  #执行分词操作
    begin
      kw = "tag_ppl2_#{keyword}"
      return get_mc(kw) do
        require 'open-uri'
        require 'net/http'
        require 'rexml/document'
        str = ""
        Net::HTTP.version_1_2
        open("http://api.51hejia.com/rest/format?kw=#{URI.escape(keyword)}&format=;") do |http|
          doc = REXML::Document.new(http.read)
          doc.root.each_element do |item|
            str = item.text if item.name == "result"
          end
        end
        kw = ""
        kw_id = 0
        @ppl_kws = []
        for w in str.split(";")
          @ppl_kws << w #保存分词结果供分析
          if w.split(//u).length > 1
            kw = w if kw == ""
            kw_id = find_keyword_id(w, 0)
            if kw_id != 0
              kw = w
              break
            end
          end
        end
        [kw_id, kw]
      end
    rescue
      return [89, "家居"]
    end
  end

  def get_keyword_id(kw)
    if kw.split(//u).length > 1
      kw_mc = get_key("mk_tag_keyword_id", kw)
      if (keyword_id = CACHE.get(kw_mc).to_i) > 0 #如果缓存中已存在这个关键字
      elsif (keyword_id = find_keyword_id(kw, 0)) > 0 #如果数据库中存在这个关键字
        CACHE.set(kw_mc, keyword_id)
      elsif kw.split(//u).length <= 3 #如果是短词
        kws = short_keyword_operation(kw) #短词处理
        keyword_id = kws[0].to_i
        kw = kws[1].to_s
        CACHE.set(kw_mc, keyword_id)
      else  #如果是其它情况则需要分词处理
        arr_ppl = ppl(kw)
        keyword_id = arr_ppl[0].to_i
        kw = arr_ppl[1].to_s
        if keyword_id == 0 && trim(kw).length > 0  #如果分词后还是没有结果，进行短词处理。
          kws = short_keyword_operation(kw) #短词处理
          keyword_id = kws[0].to_i
          kw = kws[1].to_s
        end
        #CACHE.set(kw_mc, keyword_id)
      end
    else
      kw = ""
      keyword_id = 0
    end
    @keyword = kw
    return keyword_id
  end

  def short_keyword_operation(kw) #短词处理
    kws = HejiaIndexKeyword.find(:all,:select=>"id, name",:conditions=>"name like '%%#{kw}%%'")
    if kws.length == 0
      return 0, ""
    else
      begin
        nkw = HejiaIndexKeyword.new
        nkw.name = kw
        nkw.entity_counter = 6
        nkw.save
        ids = []
        for r in kws
          ids << r.id.to_i
        end
        ids = ids.join(",")
        if ids.length > 0
          indexes = HejiaIndexesKeyword.find(:all,:select=>"index_id", :conditions=>"keyword_id in (#{ids})")
          for i in indexes
            HejiaIndexesKeyword.create(:index_id => i.index_id, :keyword_id => nkw.id)
          end
        end
        return nkw.id, nkw.name
      rescue Exception => e
        return 0, ""
      end
    end
  end

  def find_keyword_id(kw , entity_counter)
    kw = HejiaIndexKeyword.find(:first,:select=>"id",:conditions=>["name = ? and entity_counter >= ?", kw, entity_counter])
    if kw.nil?
      return 0
    else
      return kw.id
    end
  end

  def flush_all
    CACHE.flush_all
    render :text => "flush_all_ok!"
  end

  def banben
    render :text => "1.0"
  end

end
