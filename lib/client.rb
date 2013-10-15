# 客户端操作相关方法

module Client

  class << self

    #返回javascript操作语句
    def js(str)
      str = str.to_s.strip
      fail "The parameter 'str' can't be empty." unless str.length > 0
      return "<script type=\"text/javascript\">#{str}</script>"
    end

    #返回alert方法javascript操作语句
    def alert(str)
      str = str.to_s.strip
      fail "The parameter 'str' can't be empty." unless str.length > 0
      str = str.to_s.gsub("\"", "\\\"").gsub("\r", "").gsub("\n", "")
      return Client.js("alert(#{str.dump});")
    end

    #返回客户端重定向javascript操作语句
    def top_load(url="")
      url = url.to_s.strip
      if url.empty? || url == "self"
        js_str = "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
      else
        js_str = "top.location.href = \"#{url}\";"
      end
      return Client.js(js_str)
    end

#    def myrender(alert_text=@alert_text, forward_url=@forward_url, render_text=@render_text)
#      str = ""
#      str += render_text  unless render_text.blank?
#      str += Client.alert(alert_text)  unless alert_text.blank?
#      str += Client.top_load(forward_url) unless forward_url.blank?
#      render :text => str unless str.blank?
#    end

  end
    
end
