module DantuHelper

  def dantu_info(column, len=0)
    rv = ul(@dantu_info[column].to_s, len) rescue ""
    rv = "0" if (column == "haoping" || column == "chaping") && rv == ""
    return rv
  end

  def get_dantu_tags_by_photo_id(photo_id, limit=15)
    kw_mc = get_mc_kw("dantu_mk","dantu_tags",photo_id)
    tags = mc(kw_mc)
    if tags.nil?
      tags = PhotoTag.find(:all,:select=>"pt.name",
        :conditions=>"ppt.photo_id = #{photo_id} and pt.id = ppt.tag_id and ppt.type_id in (0,1,2)",
        :joins=>"pt, photo_photos_tags ppt",
        :limit=>15).collect{ |r| [r.name.gsub("/","|")] }
      tags = tags.uniq
      mc(kw_mc, tags)
    end
    return tags[0..(limit-1)]
  end

  def get_dantu_about_links(str, len=99)
    arr = []
    kws = trim(str).split("\r")
    for kw in kws
      arr << kw unless kw.include?("http")
    end
    return arr[0..(len-1)]
  end

end
