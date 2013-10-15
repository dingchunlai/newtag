module LsbLib::StringAndDate

  protected #下面是受保护的方法（或使用 private）

  #以下是字符串处理相关方法 #################################################

  def get_error(e)
    e = "controller_name(#{controller_name}) action_name(#{@action_name}) error_info: \n#{e}"
    separate = ("=" * 120)
    logger.warn(separate);logger.warn(e);logger.warn(separate)
    if e.downcase.include?("duplicate entry")
      return "操错失败：存在重复的记录！"
    else
      return e
    end
  end

  def ul(str, len, preview=0, replacer="...", do_strip_tags=1)
    if preview == 1
      str = "预览内容" * 80
    end
    str = strip_tags(str.to_s.gsub("&nbsp;", " ").gsub("\r\n", "")) if do_strip_tags==1
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  def get_md5(str)
    return Digest::MD5.hexdigest(str.to_s.strip)
  end

  def alert(str)
    return js("alert(\"#{str.to_s.gsub("\"", "\\\"").gsub("\r", "").gsub("\n", "")}\");")
  end

  def js(str)
    return "<script type=\"text/javascript\">#{str}</script>"
  end

  def top_load(url="")
    url = url.to_s.strip
    if url.empty? || url == "self"
      return "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
    else
      return "top.location.href = \"#{url}\";"
    end
  end

  def strip(str)
    str = str.to_s
    if str.length > 0
      return str.strip
    else
      return ""
    end
  end

  def trim(str)
    return strip(str)
  end

  def nonempty(str)
    if str.to_s.strip.length > 0
      return true
    else
      return false
    end
  end

  def left(str, length)
    return str.strip[0, length] rescue ""
  end

  def right(str, length)
    str = str.strip
    return str[str.length - length, length] if str.length > length
    return str
  end

  def myrender(alert_text=@alert_text, forward_url=@forward_url, render_text=@render_text)
    str = ""
    str += render_text  unless render_text.blank?
    str += alert(alert_text)  unless alert_text.blank?
    str += js(top_load(forward_url)) unless forward_url.blank?
    render :text => str unless str.blank?
  end

  #显示布告
  def show_notice(str)
    render :text => "<div style='line-height:30px; padding:30px'><b>#{str}</b><br /><br />\
  <a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a>"
  end

  def iconv_gb18030(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb18030", str).join("") : str;
    rescue
      str;
    end
  end

  def iconv_gb2312(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb2312", str).join("") : str;
    rescue
      str;
    end
  end

  def iconv_utf8(str)
    begin
      str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
    rescue
      str;
    end
  end

  #以下是时间处理相关方法 #################################################

  def getnow()
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end


end
