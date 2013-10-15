class TaotuController < ApplicationController

  helper DecorationDiaryHelper
  include IpHelper

  def search
    kw = trim(params[:keyword])
    if kw.length == 0
      redirect_to "/"
    else
      if HejiaTag.get_about_tags(kw).length == 0
        redirect_to "http://tag.51hejia.com/#{kw}.html"
      else
        redirect_to "http://tuku.51hejia.com/zhuanqu/#{kw}.html"
      end
    end
  end

  def keyword
    expires_now
    tui_api = {
        '上海' => {'日记' =>55241,'案例' =>55242},
        '杭州' => {'日记' =>55157,'案例' =>55159},
        '宁波' => {'日记' =>55071,'案例' =>55243},
        '苏州' => {'日记' =>55188,'案例' =>55160},
        '无锡' => {'日记' =>55218,'案例' =>55217},
        '武汉' => {'日记' =>54580,'案例' =>54581},
        '南京' => {'日记' =>54588,'案例' =>54582},
        '青岛' => {'日记' =>55141,'案例' =>55396}
    }
    @keyword1, @keyword2, @keywords = analyse_keyword(params[:keyword])
    render_404 if @keyword1.blank?
    @cases = HejiaCase.get_cases(@keyword1, @keyword2, params[:page] && params[:page].to_i || 1)
    @sort = ZhuanquSort.find(:first,:select=>"*",:conditions=>["sort_name = ?", @keyword1]) if @sort.nil?
    @city_name = remote_city[:name]
    tui_api.keys.include?(@city_name) ? @city_name : @city_name = '上海'
    city_id = CITIES.invert[@city_name]
    city_id ? city_id : city_id = 11910
    @city = TAGURLS[city_id]

    DecorationDiary
    Picture
    HejiaKeywordToTag
    @diary_api = hejia_promotion_items(tui_api[@city_name]['日记'], :select =>'title,url,image_url', :limit =>2)

    @diaries = CACHE.fetch("get_tag_diaries/city/#{@city}/#{params[:keyword]}", 10.minutes) do
        @tuku_tag = HejiaKeywordToTag.find(:first,:conditions =>["fatherid = 1 and keyword = ?",params[:keyword]]) #图库标签风格
        if [11910,11905,11887,11908].include? city_id.to_i
          city_sql = "deco_firms.city = #{city_id}"
        else
          city_sql = "deco_firms.district = #{city_id}"
        end
        if @tuku_tag
          tag_diaries = DecorationDiary.find(:all,:select =>'decoration_diaries.id,decoration_diaries.title',:joins =>"join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",:conditions =>"#{city_sql} and decoration_diaries.status = 1 and decoration_diaries.style = #{STYLES.invert[@tuku_tag.tag]}",:order =>'decoration_diaries.updated_at desc',:limit =>5)
        else
          tag_diaries = DecorationDiary.find(:all,:select =>'decoration_diaries.id,decoration_diaries.title',:joins =>"join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id",:conditions =>"#{city_sql} and decoration_diaries.is_verified = 1",:order =>'decoration_diaries.updated_at desc',:limit =>5)
        end
        tag_diaries
    end

    @new_cases = CACHE.fetch("get_tag_cases/city/#{@city}/#{params[:keyword]}", 10.minutes) do
       hejia_promotion_items(tui_api[@city_name]['案例'], :select =>'title,url,image_url', :limit =>7)
    end
    @kv = @keywords.sub('_','')
  end

  private

  def analyse_keyword(keyword)  #分析关键词
    keywords = keyword.to_s.strip.split("_")
    if keywords.length == 1
      return keyword, '', keyword
    elsif keywords.length == 2
      return keywords[0], keywords[1], keywords[0] + '_' + keywords[1]
    else
      return '', '', ''
    end
  end

end
