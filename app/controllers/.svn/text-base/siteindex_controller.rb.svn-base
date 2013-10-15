class SiteindexController < ApplicationController
#  require 'open-uri'
#  require 'rexml/document'
#  require 'cgi'

  def result
    @kw1 = params[:kw1].to_s.strip
    @kw2 = params[:kw2].to_s.strip
    if @kw1.blank?
      redirect_to "http://www.51hejia.com/"
    else
#      kws = @kw1.split(//u)
#      if kws.length > 5
#      end
      @keywords = "#{@kw2}#{@kw1}"
      render :layout => false
    end
  end

  def parse(str)
    kw = CGI.escape(iconv_gb2312(str))
    url = "http://api.51hejia.com/rest/format?kw="+kw+"&format=;"
    begin
      example = open(url)
      xml = example.read
      rest = REXML::Document.new(xml)
      rest.root.each_element do |node|
        return node.text if node.name.to_s=="result"
      end
    rescue
      return ""
    end
  end
 
end
