class HejiaTag < Hejia::Db::Hejia

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "HEJIA_TAG"

  def self.get_tagname(tag_id)
    return nil if tag_id.to_i == 0
    tag = HejiaTag.find(:first,:select=>"TAGNAME",:conditions=>"TAGID = #{tag_id} and TAGESTATE='0' and TAGTYPE = 'case'")
    if tag.nil?
      return nil
    else
      return tag["TAGNAME"]
    end
  end

  def self.get_about_tags(tagname) #取得某个标签的相关标签（即同一级标签）
    tagname = tagname.to_s.strip
    tags = []
    if tagname.length > 0
      kw = get_key("mk_hejia_tag_about_tags", tagname)
      tags = CACHE.fetch(kw, 2.weeks) do
        begin
          rs = HejiaTag.find(:first,:select=>"TAGFATHERID",:conditions=>"TAGNAME='#{tagname}' and TAGESTATE='0' and TAGTYPE = 'case'")
          tags = HejiaTag.find(:all,:select=>"TAGNAME",:conditions=>"TAGFATHERID=#{rs.TAGFATHERID} and TAGESTATE='0' and TAGTYPE = 'case'").collect { |result| result.TAGNAME } unless rs.nil?
          tags
        rescue
          []
        end
      end
    end
    return tags
  end

end
