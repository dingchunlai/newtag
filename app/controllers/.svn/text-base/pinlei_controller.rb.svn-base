class PinleiController < ApplicationController

  caches_page :detail, :community
  
  def test
    render :layout => false
  end

  def index
    return false if add_slash_at_url_tail
    @spell = get_spell_by_url
    @ci = PinleiPindao.get_pinlei(@spell)  #取得频道信息
    if @ci.nil?
      render :text => "无此频道：#{@spell}"
    else
      @kw = @ci["name"]
      @about_kws = "#{@kw},#{@ci["tw_kw"]},#{@ci["tj_kw"]},装修"  #相关关键字
      @text_ad_links = {}
      @text_ad_links["jiadian"] = [547,548,549]
      
      render :layout => false
    end
  end

  def detail
    @keyword = params[:keyword].to_s
    expire_fragment :action=>"detail" if rand(200) == 0
    if read_fragment :action=>"detail"

    else
      @pinlei = Pinlei.find_by_name(@keyword)
      if @pinlei.nil?
        render :text => "没有找到关键字: #{@keyword}"
      else
        @title_color = "#FFFFFF"
        @intro_color = "#FFFFFF"
        @title_color = @pinlei.title_color if ne(@pinlei.title_color)
        @intro_color = @pinlei.intro_color if ne(@pinlei.intro_color)
      end
    end
  end

  def community
    @sort_id = params[:sort_id].to_i
    @sort_id = 1 if @sort_id == 0
    render :layout => false
  end

  def expire_keyword
    kw = params[:kw]
    if ne(kw)
      expire_page :controller => 'pinlei', :action => 'detail', :keyword => kw
      render :text => "OK"
    else
      render :text => "no"
    end
  end

  def ep  #使静态缓存页面过期
    1.upto(11) do |i|
      expire_page :controller => 'pinlei', :action => 'community', :sort_id => i.to_s
    end
    render :text => "ok..."
  end


end
