class ZhuanquController < ApplicationController

  def keyword
    return false if p_to_prod
    @entity_type_id = (params[:entity_type] == 'diaries' ? 7 : 1)
    @keyword = @keyword_v = params[:keyword].to_s.strip
    @zhuanqu = ZhuanquKw.info(@keyword)
    return render_404 if @zhuanqu.nil?
    @about_kws = [@keyword, @zhuanqu.sort_name] #相关关键词
    @keyword_id =  get_keyword_id(@keyword)
    return render_404 unless @keyword_id > 0
    @is_has_diaries = (HejiaIndex.get_zhuanqu_list_counter(@keyword_id, 7) > 0) if @zhuanqu.board_id.to_i == 1
    @ars = HejiaIndex.get_zhuanqu_list(@keyword_id, @zhuanqu.board_id, @entity_type_id, params[:page], 10)
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
      @ppl_kws << w
      kw_id = find_keyword_id(w)
      if kw_id != 0
        kw = w
        break
      end
    end
    return kw_id, kw
  end

  def get_keyword_id(kw)
    @keyword = kw.to_s.strip
    return 0 if @keyword.blank?
    find_keyword_id(@keyword)
  end

  def find_keyword_id(kw)
    kw = HejiaIndexKeyword.find_by_name(kw)
    if kw.nil?
      return 0
    else
      return kw.id
    end
  end

  def view
    @graph = open_flash_chart_object(500,250, '/zhuanqu/bar_3d', true, '/')
    render :layout => false
  end

  def bar_3d
    bar_red = Bar3d.new(75, '#D54C78')
    bar_red.key('2006', 10)
    bar_blue = Bar3d.new(75, '#3334AD')
    bar_blue.key('2007', 10)

    10.times do |t|
      bar_red.data << rand(3) + 2
      bar_blue.data << rand(4) + 5
    end

    g = Graph.new
    g.title("3D Bar Chart", "{font-size:20px; color: #FFFFFF; margin: 5px;background-color: #505050; padding:5px; padding-left: 20px; padding-right: 20px;}")
    g.data_sets << bar_red
    g.data_sets << bar_blue

    g.set_x_axis_3d(12)
    g.set_x_axis_color('#ffffff', '#fDB5C7')
    g.set_y_axis_color('#ffffff', '#fDB5C7')

    g.set_x_labels(%w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct))
    g.set_y_max(10)
    g.set_y_label_steps(5)
    g.set_y_legend("OPEN FLASH CHART", 12, "#736AFF")
    render :text => g.render
  end

end
