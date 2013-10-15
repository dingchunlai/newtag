# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # Pick a unique cookie name to distinguish our session data from others'

  # after_filter :after_filter_by_development if RAILS_ENV == "development"

  protected #下面是受保护的方法（或使用 private）

  def after_filter_by_development
    dev_url = "http://dev.51hejia.com:#{request.env["SERVER_PORT"]}".dump
    response.body += "<div id='development_tools' style='position:absolute; left:5px; top:5px; width:150px; height:20px; z-index:1'><a href=#{dev_url}>Index</a>　" +
      "<a href='/newrelic' target='_blank'>Newrelic</a></div>"
  end

  def render_404
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  def domain_redress(sub_domain)
    return false if sub_domain == "deco" || sub_domain == "tag" || RAILS_ENV != "production"
    if request.env["SERVER_NAME"].to_s != "#{sub_domain}.51hejia.com"
      redirect_to "http://#{sub_domain}.51hejia.com#{request.env["REQUEST_URI"]}"
      return true
    else
      return false
    end
  end

  def p_to_prod
    if request.env["SERVER_NAME"].to_s == "p.51hejia.com"
      redirect_to "http://prod.51hejia.com#{request.env["REQUEST_URI"]}"
      return true
    else
      return false
    end
  end
  
  def add_slash_at_url_tail
    if right(request.env["REQUEST_URI"], 1) != "/"
      redirect_to "#{request.env["REQUEST_URI"]}/"
      return true
    else
      return false
    end
  end

  def get_spell_by_url
    spell = request.env["REQUEST_URI"].to_s.gsub("/","")
    spell = "jushang" if spell.length == 0
    return spell
  end

end
