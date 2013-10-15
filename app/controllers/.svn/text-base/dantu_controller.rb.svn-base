class DantuController < ApplicationController

  def list
    @kw = params[:keyword].to_s.strip
    return false if @kw.to_s.length == 0
    @rs = PhotoPhoto.get_dantus(@kw, params[:page].to_i)
    @dantu_info = ZhuanquDantu.get_dantu(@kw)
  end

  def detail
    @kw = params[:keyword].to_s.strip
    @photo_id = params[:photo_id].to_i
    if @kw.length == 0 || @photo_id == 0
      render_404; return false
    end
    @dantu_info = ZhuanquDantu.get_dantu(@kw)
    if @dantu_info.nil?
      render_404
    else
      @ls = get_dantu_ls  # @获取图片列表
      cpp = PhotoPhoto.find(@photo_id, :select => "case_id, filepath") rescue nil
      @cur_case = cpp && cpp.hejia_case
      @cur_case_image_url = cpp && get_tuku_big_photo_url(cpp.filepath)
    end
  end

  def get_dantu_ls
    kw_mc = "dantu_ls_#{@kw}_#{@photo_id}"
    @s_kws = trim(@dantu_info["split"]).split(",") rescue []
    PhotoPhoto
    return get_mc(kw_mc) do   #尝试获取相应关键字的memcache信息
      ls = []
      con = []
      if @s_kws.length > 1 #如果是复合词，则使用分词子搜索条件
        p_ids = PhotoPhoto.find(:all, :select => "pp.id",
          :conditions => "ppt.tag_id = #{get_photo_tag_id(@s_kws[0])} and pp.id = ppt.photo_id and pp.type_id in (3,5)",
          :joins => "pp, photo_photos_tags ppt", :limit => 30).collect{ |r| r.id }.join(",")
        tag_id = get_photo_tag_id(@s_kws[1])
        con = ["pp.id in (#{p_ids})"] if p_ids.to_s.length > 1
      else  #如果是单词
        tag_id = get_photo_tag_id(@kw.gsub("|","/"))
      end
      con << "ppt.tag_id = #{tag_id}"
      con << "pp.id = ppt.photo_id and pp.type_id in (3,5)"

      ls = PhotoPhoto.find(:all,
        :select => "pp.id,pp.case_id,pp.type_id, pp.filepath",
        :conditions => con.join(" and "),
        :joins => "pp, photo_photos_tags ppt",
        :order => "rand()",
        :limit => 60
      )
      ls
    end
  end

  def dantu_pingfen   #type等于0时候显示评分，其它值的话就是评分操作。
    kw = trim(params[:kw])
    type = params[:type].gsub("s","-").to_i
    dantu_info = ZhuanquDantu.find(:first,
      :select=>"id,name,haoping,chaping",
      :conditions=>["name = ? and is_delete = ?", kw, 0])
    if type == 0
      render :text => "document.write(\"<li class='li01'><span id='haoping'>#{dantu_info.haoping rescue 0}</span>好评</li><li class='li02'><span id='chaping'>#{dantu_info.chaping rescue 0}</span>差评</li>\");"
    else
      if dantu_info.nil?
        dantu_info = ZhuanquDantu.new
        dantu_info.name = kw
        if type > 0
          dantu_info.haoping = type
        else
          dantu_info.chaping = type.abs
        end
      else
        if type > 0
          dantu_info.haoping += type
        else
          dantu_info.chaping += type.abs
        end
      end
      dantu_info.save
      render :text => js("document.domain = '51hejia.com';top.document.getElementById('haoping').innerHTML='#{dantu_info.haoping}';top.document.getElementById('chaping').innerHTML='#{dantu_info.chaping}';")
    end
  end

end
