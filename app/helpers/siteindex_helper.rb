module SiteindexHelper

  def get_siteindex_rs    #取得siteindex终端页所需要的24条文章记录@rs和4条含图文章记录@irs
    @rs = []
    @irs = []

    if @keywords != @kw1
      for r in get_about_list(1, @keywords, 30)
        if trim(r["image_url"]).length > 1 && @irs.length < 4
          @irs << r
        elsif @rs.length < 24
          @rs << r
        end
      end
      return 0 if @rs.length >= 24 && @irs.length >= 4
    end

    for r in get_about_list(1, @kw1, 30)
      if trim(r["image_url"]).length > 1 && @irs.length < 4
        @irs << r
      elsif @rs.length < 24
        @rs << r
      end
    end

    return 0 if @rs.length >= 24 && @irs.length >= 4

    if trim(@kw2).length > 0
      for r in get_about_list(1, @kw2, 30)
        if trim(r["image_url"]).length > 1 && @irs.length < 4
          @irs << r
        elsif @rs.length < 24
          @rs << r
        end
      end
    end

    return 0 if @rs.length >= 24 && @irs.length >= 4

    for r in get_about_list(1, "装修", 30)
      if trim(r["image_url"]).length > 1 && @irs.length < 4
        @irs << r
      elsif @rs.length < 24
        @rs << r
      end
    end

  end

  def get_siteindex_tuku_rs
    @trs = []
    if @keywords != @kw1
      for r in HejiaCase.get_cases(@keywords)
        @trs << r if @trs.length < 12
      end
      return 0 if @trs.length >= 12
    end
    for r in HejiaCase.get_cases(@kw1)
      @trs << r if @trs.length < 12
    end
    return 0 if @trs.length >= 12
    if trim(@kw2).length > 0
      for r in HejiaCase.get_cases(@kw2)
        @trs << r if @trs.length < 12
      end
    end
    return 0 if @trs.length >= 12
    for r in HejiaCase.get_cases("小户型装修")
      @trs << r if @trs.length < 12
    end
  end

  def get_siteindex_bbs_rs
    @bbsrs = []
    if @keywords != @kw1
      for r in get_about_list(3, @keywords, 11)
        @bbsrs << r if @bbsrs.length < 11
      end
      return 0 if @bbsrs.length >= 11
    end
    for r in get_about_list(3, @kw1, 11)
      @bbsrs << r if @bbsrs.length < 11
    end
    return 0 if @bbsrs.length >= 11
    if trim(@kw2).length > 0
      for r in get_about_list(3, @kw2, 11)
        @bbsrs << r if @bbsrs.length < 11
      end
    end
    return 0 if @bbsrs.length >= 11
    for r in get_about_list(3, "装修", 11)
      @bbsrs << r if @bbsrs.length < 11
    end
  end

  def get_siteindex_wenba_rs
    @wenbars = []
    if @keywords != @kw1
      for r in get_about_list(2, @keywords, 11)
        @wenbars << r if @wenbars.length < 11
      end
      return 0 if @wenbars.length >= 11
    end
    for r in get_about_list(2, @kw1, 11)
      @wenbars << r if @wenbars.length < 11
    end
    return 0 if @wenbars.length >= 11
    if trim(@kw2).length > 0
      for r in get_about_list(2, @kw2, 11)
        @wenbars << r if @wenbars.length < 11
      end
    end
    return 0 if @wenbars.length >= 11
    for r in get_about_list(2, "装修", 11)
      @wenbars << r if @wenbars.length < 11
    end
  end

  def get_zq_sort_id_by_siteindex_keywords(keywords, kw1, kw2)
      kw_mc = get_mc_kw("siteindex", "sort_id",keywords)
      sort_id = mc(kw_mc)
      if sort_id.nil?
          sort_id = 0
          if keywords != kw1
              sort_id = ZhuanquKw.find(:first,:select=>"sort_id",:conditions=>"kw_name = '#{keywords}'")["sort_id"] rescue 0 if sort_id == 0
              sort_id = ZhuanquSort.find(:first,:select=>"id",:conditions=>"sort_name = '#{keywords}'")["id"] rescue 0 if sort_id == 0
          end
          sort_id = ZhuanquKw.find(:first,:select=>"sort_id",:conditions=>"kw_name = '#{kw1}'")["sort_id"] rescue 0 if sort_id == 0
          sort_id = ZhuanquSort.find(:first,:select=>"id",:conditions=>"sort_name = '#{kw1}'")["id"] rescue 0 if sort_id == 0
          if trim(kw2).length > 0
              sort_id = ZhuanquKw.find(:first,:select=>"sort_id",:conditions=>"kw_name = '#{kw2}'")["sort_id"] rescue 0 if sort_id == 0
              sort_id = ZhuanquSort.find(:first,:select=>"id",:conditions=>"sort_name = '#{kw2}'")["id"] rescue 0 if sort_id == 0
          end
          sort_id = ZhuanquSort.find(:first,:select=>"id",:conditions=>"is_delete=0",:order=>"rand()")["id"] rescue 0 if sort_id == 0
          mc(kw_mc, sort_id)
      end
      return sort_id
  end

  def get_case_url  #取得套图专区地址
    get_case_id(@kw1) if @case_keyword.nil? #试图取得@case_keyword%>
    if @case_keyword.nil?
      return "http://tuku.51hejia.com"
    else
      return "http://tuku.51hejia.com/zhuanqu/#{@case_keyword}.html"
    end
  end

end
