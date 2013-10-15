class DianxingController < ApplicationController

  def index
    return false if add_slash_at_url_tail
    @spell = get_spell_by_url
    @ci = Dianxing.get_dianxing(@spell)  #取得频道信息
    if @ci.nil?
      render :text => "无此频道：#{@spell}"
    else
      @kw = @ci["name"]
      @about_kws = "#{@kw},#{@ci["tg1_kw"]},#{@ci["tg2_kw"]},装修"  #相关关键字
      render :layout => false
    end
  end

  def jushang
    return false if add_slash_at_url_tail
    @spell == "jushang"
    @ci = {
      "html_title" => "【家居】时尚家居，时尚家居用品导购，时尚居家软装搭配_和家网家居频道",
      "html_keywords" => "家居 时尚家居 家居生活 创意家居 居家 软装 软装饰 家居装饰 家居用品",
      "html_description" => "和家网家居频道关于优雅、健康、时尚居家生活的一切。时尚家居网站,时尚家居潮流，时尚家居用品，提供时尚居家软装饰解决方案。为爱家软装饰搭配、换季换装；DIY情趣饰品；学园艺插花、了解海内外最新时尚家居装修风格。"
    }
    #焦点图
    @jiaodiantus = parse_xml("http://api.51hejia.com/rest/build/xml/53397.xml",["title","url","image_url"],5)
    #首屏焦点文章
    @jiaodians = parse_xml("http://api.51hejia.com/rest/build/xml/53398.xml",["title","url","image_url","description"],9)
    #专题
    @zhuanti = parse_xml("http://api.51hejia.com/rest/build/xml/53399.xml",["title","url","image_url","description"],3)

    @tuiguang = parse_xml("http://api.51hejia.com/rest/build/xml/55186.xml",["title"],6)

    lm1 = parse_xml("http://api.51hejia.com/rest/build/xml/55090.xml",["title","url","image_url","description"],4)
    @lanmu1 = lm1[0]["title"].split(" ")
    @lanmu1_tuijian = lm1[1]["title"].split(" ")
    @lanmu1_tw = lm1[2..3]

    lm2 = parse_xml("http://api.51hejia.com/rest/build/xml/55183.xml",["title","url","image_url","description"],5)
    @lanmu2 = lm2[0]["title"].split(" ")
    @lanmu2_tuijian = lm2[1]["title"].split(" ")
    @lanmu2_tw = lm2[2..4]

    lm3 = parse_xml("http://api.51hejia.com/rest/build/xml/55184.xml",["title","url","image_url","description"],6)
    @lanmu3 = lm3[0]["title"].split(" ")
    @lanmu3_tuijian = lm3[1]["title"].split(" ")
    @lanmu3_tw = lm3[2..5]

    lm4 = parse_xml("http://api.51hejia.com/rest/build/xml/55185.xml",["title","url","image_url","description"],6)
    @lanmu4 = lm4[0]["title"].split(" ")
    @lanmu4_tuijian = lm4[1]["title"].split(" ")
    @lanmu4_tw = lm4[2..5]

    @lanmu5 = []
    @lanmu5 << parse_xml("http://api.51hejia.com/rest/build/xml/55082.xml",["title","url","image_url","resume"],5)
    @lanmu5 << parse_xml("http://api.51hejia.com/rest/build/xml/55083.xml",["title","url","image_url","resume"],5)
    @lanmu5 << parse_xml("http://api.51hejia.com/rest/build/xml/55084.xml",["title","url","image_url","resume"],5)
    @lanmu5 << parse_xml("http://api.51hejia.com/rest/build/xml/55085.xml",["title","url","image_url","resume"],5)

    @friendly_links = parse_xml("54767",["title","url"],99)
  end

end
