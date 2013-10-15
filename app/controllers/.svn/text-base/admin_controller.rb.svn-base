class AdminController < ApplicationController

  before_filter :authentication

  def authentication
    return true if current_staff && current_staff.hejia_editor?
    false
  end

  def hejia_index_delete
    begin
      id = params[:id].to_i
      fail "id must greater than zero" unless id > 0
      keyword_ids = HejiaIndexesKeyword.find(:all, :select=>"keyword_id", :conditions=>["index_id = ?",id]).map{|r| r.keyword_id}.uniq
      keyword_ids.each do |keyword_id|
        kw = get_key("tag_lists_1", keyword_id, 1)
        expire_memcache(kw)
      end
      HejiaIndex.delete_all(["id = ?", id])
      HejiaIndexesKeyword.delete_all(["index_id = ?", id])
      @alert_text = "记录已经删除！要看效果请刷新本页。"
    rescue Exception => e
      @alert_text = e.to_s
    end
    myrender
  end

  #删除专区文章关联
  def relation_delete
    begin
      relation = Relation.find(:first, :select => 'id, keyword_id', :conditions => ['keyword_id = ? and entity_id = ?', params[:keyword_id], params[:entity_id]])
      if relation
        HejiaIndex.zhuanqu_list_clear_cache(relation.keyword_id) #清除列表专区缓存
        CACHE.delete(HejiaIndex.articles_memkey(relation.keyword_id)) #清除文章调用缓存
        relation.destroy
      end
      @alert_text = "关联已经删除！要看效果请刷新本页。"
    rescue Exception => e
      @alert_text = e.to_s
    end
    myrender
  end

end
