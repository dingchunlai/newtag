class HejiaArticle < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "HEJIA_ARTICLE"

  def self.resume(id)
    id = id.to_i
    return "" unless id > 0
    HejiaArticle.find(:first,:select=>"SUMMARY",:conditions=>["ID = ?", id]).SUMMARY rescue ""
  end

  #根据多个文章ID取得一个有效的题图
  def self.get_one_image_url_by_any_ids(ids)
    default_image_url = "http://www.51hejia.com/api/images/none.gif"
    ids = ids.to_s.split(",") unless ids.class == Array
    return default_image_url if ids.length == 0
    ids.each do |id|
      image_url = HejiaArticle.image_url(id)
      return image_url unless image_url == default_image_url
    end
    default_image_url
  end

  #根据文章ID取得文章题图
  def self.image_url(id)
    id = id.to_i
    default_image_url = "http://www.51hejia.com/api/images/none.gif"
    return default_image_url unless id > 0
    mk = get_key("mk_HejiaArticle_image_url", id)
    image_url = CACHE.fetch(mk, 1.month) do
      image_url = ""
      article = HejiaArticle.find(:first,:select=>"ID,CREATETIME,IMAGENAME",:conditions=>["ID = ?", id])
      unless article.nil?
        image_name = article.IMAGENAME
        create_time = article.CREATETIME.strftime("%Y%m%d") rescue ""
        unless image_name.nil?
          if image_name.include?("img")
            image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
          else
            image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{create_time}/#{image_name} "
          end
        end
      end
      image_url
    end
    image_url = default_image_url if image_url.blank?
    return image_url
  end
  
end
