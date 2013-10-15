class SortController < ApplicationController
  include IpHelper
  helper_method :hangye, :sort

  def index
    city = remote_city
    @city_code = city[:number].to_i
    @city_code = 11910 unless [11910,12117,12118,12122,12306,12301,11921].include?(@city_code)
    @kw = params[:sort_name].to_s.strip
    return false if domain_redress(ZHUANQU_BOARD_SPELL[sort("board_id").to_i])
    return false if add_slash_at_url_tail
    return false if @kw.length == 0
#    render :template => "sort/index_hangye" if sort("board_id") == 4
  end

  protected

  def hangye(cn)  #取得行业专区信息
    return "" if cn.blank? || @kw.blank?
    @hangye = ZhuanquHangye.find(:first,:select=>"*",:conditions=>["name = ?", @kw]) if @hangye.nil?
    return @hangye[cn] rescue ""
  end

  def sort(cn)  #取得栏目专区信息
    return "" if cn.blank? || @kw.blank?
    @sort = ZhuanquSort.find(:first,:select=>"*",:conditions=>["sort_name = ?", @kw]) if @sort.nil?
    return @sort[cn] rescue ""
  end

end
