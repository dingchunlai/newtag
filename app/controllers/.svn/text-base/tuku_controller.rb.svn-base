class TukuController < ApplicationController

  def get_case_compound_words(tag_id, need_commend) #读取案例复合词
    cond = []
    cond << "is_confirmed = 1" if need_commend == 1
    cond << "sort_id2 = #{tag_id}"
    return ZhuanquCw.find(:all,:select=>"tagname,kw1,kw2,sort_id1",:conditions=>cond.join(" and "),:order=>"sort_id1 asc")
  end

  def get_case_tags_by_fahtertagid(fahtertagid)
    return HejiaTag.find(:all,:select=>"TAGID, TAGNAME",:conditions=>"TAGFATHERID = #{fahtertagid} and TAGESTATE='0' and TAGTYPE = 'case'")
  end

  def get_dantu_tags_by_sort_id(sort_id)
    return ZhuanquDantu.find(:all,:select=>"id, name",:conditions=>["is_delete=0 and is_published=1 and sort_id = ?",sort_id])
  end

  def tuku_index
    kw_mc = get_mc_kw("tuku_index_mk","tuku_index",4)
    @tags = get_mc(kw_mc) do
      f_tags = HejiaTag.find(:all,:select=>"TAGID, TAGNAME",:conditions=>"TAGID not in (42160,4401) and TAGFATHERID = 4346 and TAGESTATE='0' and TAGTYPE = 'case'")
      arr = []
      for f_tag in f_tags
        f_id = f_tag.TAGID
        tags = []
        for tag in get_case_tags_by_fahtertagid(f_id)
          tags << tag.TAGNAME.to_s
        end
        for tag in get_case_compound_words(f_id, 1)
          tags << "#{tag.tagname},#{tag.kw1},#{tag.kw2}"
        end
        for tag in get_dantu_tags_by_sort_id(f_id)
          tags << "#{tag.name},3"
        end
        arr << [f_tag.TAGID, f_tag.TAGNAME, tags]
      end
      arr
    end
  end

  def tuku_index_more
    @tag_id = params[:tag_id].to_i
    if @tag_id > 0
      kw_mc = get_key("mk_tuku_index_more", @tag_id)
      @tags = CACHE.fetch(kw_mc, 3.days) do
        arr = []
        arr << HejiaTag.get_tagname(@tag_id)
        for tag in get_case_tags_by_fahtertagid(@tag_id)
          arr << tag.TAGNAME.to_s
        end
        for tag in get_dantu_tags_by_sort_id(@tag_id)
          arr << "#{tag.name},3"
        end
        for tag in get_case_compound_words(@tag_id, 0)
          arr << "#{tag.tagname},#{tag.kw1},#{tag.kw2},#{tag.sort_id1}"
        end
        arr.compact
      end
    end
    @tags = [] if @tags.nil?
    render_404 if @tags.length == 0
  end

end
