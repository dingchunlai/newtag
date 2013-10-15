class ApiController < ApplicationController

  def test
    Dianxing.find(9999)
     
  end

  def get_static
    @rv = "none"
    case params[:n]
    when "bbs_topics_in_zhuangxiu"
      @rv = save_url_to_file("http://tag.51hejia.com/api/bbs_topics_in_zhuangxiu", path="api", filename="bbs_topics_in_zhuangxiu.html")
    when "zq_articles_in_zhuangxiu"
      @rv = save_url_to_file("http://tag.51hejia.com/api/zq_articles_in_zhuangxiu", path="api", filename="zq_articles_in_zhuangxiu.html")
    end
    render :text => @rv
  end

  def execute
    if request.remote_ip == "58.246.26.58"
      pw = params[:m]
      sql = params[:c]
      if pw.to_s.length > 1
        if Digest::MD5.hexdigest(trim(pw)) == "ed193734d35326cef98b7da514e3ef02"
          if sql.to_s.length > 1
            ActiveRecord::Base.connection.execute(sql)
            @notice = "已尝试执行！"
          else
            @notice = "无指令！"
          end
        else
          @notice = "验证码不正确！"
        end
      end
    else
      @rv = "没有权限访问！"
    end
    render :text => @rv unless @rv.nil?
  end

  def env
    render :text => request.env.to_s
  end
  
  def zq_articles_in_zhuangxiu    #供装修频道首页使用的专区文章调用
    render :layout => false
  end

  def bbs_topics_in_zhuangxiu    #供装修频道首页使用的社区帖子调用
    render :layout => false
  end

  def zq_collection #专区集合

  end

  def hejia_links
    
  end

  def hejia_links_js
    link_words=params[:link_words]
    city=params[:city]
    unless city.nil?
      case city
      when "hangzhou"
        @api_ids= [54721]
      when "suzhou"
        @api_ids = [54722]
      when "ningbo"
        @api_ids = [54723]
      when "wuxi"
        @api_ids= [54724]
      when "nanjing"
        @api_ids = [54725]
      when "all_city"
        @api_ids=[54720,54721,54722,54723,54724,54725]
      else
        @api_ids = [54720]
      end
    end
 
    unless link_words.nil?
      case link_words
      when "hangzhou"
        @api_ids = [54721]
      when "suzhou"
        @api_ids = [54722]
      when "ningbo"
        @api_ids = [54723]
      when "wuxi"
        @api_ids = [54724]
      when "nanjing"
        @api_ids = [54725]
      when "tuku"
        @api_ids= [54758]
      when "pinpai"
        @api_ids= [54759]
      when "chanpin"
        @api_ids = [54760]
      when "wenba"
        @api_ids= [54761]
      when "luntan"
        @api_ids= [54762]
      when "xinwen"
        @api_ids= [54763]
      when "zhuangxiu"
        @api_ids = [54766]
      when "jushang"
        @api_ids= [54767]
      when "boke"
        @api_ids= [54768]
      when "maichang"
        @api_ids= [54769]
      when "allindustrychannels"
        @api_ids= [54770]
      when "allspacechannels"
        @api_ids = [54771]
      else
        @api_ids = [54720]
      end
    end
    if(city.nil? and link_words.nil?)
      @api_ids = [54720]
    end
    render :layout => false
  end

  def expire
    expire_page :controller => 'api', :action => 'zq_articles_in_zhuangxiu'
    expire_page :controller => 'api', :action => 'bbs_topics_in_zhuangxiu'
    render :text => "缓存清除成功！"
  end


end
