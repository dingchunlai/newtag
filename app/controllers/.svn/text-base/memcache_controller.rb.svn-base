class MemcacheController < ApplicationController

  def expire
    keywords = params[:keywords].to_s.strip
    if keywords.blank?

    else
      begin
        keywords = keywords.split("\r\n").map{ |e| e.strip}
        keywords.each do |keyword|
          CACHE.delete(keyword)
          CACHE.delete(MEMCACHE_PREFIX_KEY+"_"+keyword) unless keyword[0..3] == MEMCACHE_PREFIX_KEY+"_"
        end
        @alert_text = "操作成功： [#{keywords.join(", ")}] 的缓存已清除！"
      rescue Exception => e
        @alert_text = "操作失败： #{e.to_s}"
      end
    end
    myrender
  end

end
