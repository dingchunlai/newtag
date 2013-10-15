module TukuHelper

  def get_tag_link(tag)
    if RAILS_ENV == "development"
      host = "/"
    else
      host = "http://tuku.51hejia.com/"
    end
    tag = tag.split(",")
    if tag.length > 1
      if tag[1] == "3"
        return "<li><h3><a href=\"#{host}pic/#{tag[0]}.html\" title=\"#{tag[0]}\" target=\"_blank\">#{tag[0]}</a></h3></li>"
      else
        return "<li><h3><a href=\"#{host}zhuanqu/#{tag[1]}_#{tag[2]}.html\" title=\"#{tag[0]}\" target=\"_blank\">#{tag[0]}</a></h3></li>"
      end
    else
      return "<li><h3><a href=\"#{host}zhuanqu/#{tag[0]}.html\" title=\"#{tag[0]}\" target=\"_blank\">#{tag[0]}</a></h3></li>"
    end
  end
  
  def get_tagname_by_tag_id(tag_id)
    kw_mc = "tagname_#{tag_id}"
    tagname = mc(kw_mc)
    if tagname.nil?
      tagname = HejiaTag.find(:first, :select=>"TAGNAME", :conditions=>["TAGID = ?", tag_id]).TAGNAME rescue ""
      mc(kw_mc, tagname)
    end
    return tagname
  end

end
