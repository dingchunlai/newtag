module IndexHelper

  def get_tag_link(tag)
    tag = tag.split(",")
    if tag.length == 3
      return "<li><h3><a href=\"http://tuku.51hejia.com/zhuanqu/#{tag[1]}_#{tag[2]}.html\" title=\"#{tag[0]}\" target=\"_blank\">#{tag[0]}</a></h3></li>"
    else
      return "<li><h3><a href=\"http://tuku.51hejia.com/zhuanqu/#{tag[0]}.html\" title=\"#{tag[0]}\" target=\"_blank\">#{tag[0]}</a></h3></li>"
    end
  end

end
