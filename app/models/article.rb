# == Schema Information
# Schema version: 11
#
# Table name: 51hejia.HEJIA_ARTICLE
#
#  ID                    :integer(19)     not null, primary key
#  AUTHOR                :string(510)
#  BLOD                  :integer(1)
#  COLOR                 :string(510)
#  COPYRIGHT             :string(510)
#  CREATETIME            :datetime
#  EXPIRINGDATE          :datetime
#  FIRSTORDERID          :integer(19)
#  KEYWORD1              :string(510)
#  KEYWORD2              :string(510)
#  LASTMODIFYTIME        :datetime
#  PUBLISHTIME           :datetime
#  SECONDORDERID         :integer(19)
#  SOURCE                :string(510)
#  SUMMARY               :string(4000)
#  TITLE                 :string(510)
#  USERID                :integer(19)
#  ZONE                  :string(510)
#  CONTENTID             :integer(19)
#  FIRSTCATEGORY         :integer(19)
#  SECONDCATEGORY        :integer(19)
#  STATE                 :string(510)
#  IMAGENAME             :string(510)
#  CITYORDERBY           :integer(19)
#  THIRDORDERID          :integer(19)
#  THIRDCATEGORY         :integer(19)
#  PRODUCTFIRSTCATEGORY  :integer(11)
#  PRODUCTSECONDCATEGORY :integer(11)
#  PRODUCTTHIRDCATEGORY  :integer(11)
#  PRODUCTFIRSTORDERID   :integer(11)
#  PRODUCTSECONDORDERID  :integer(11)
#  PRODUCTTHIRDORDERID   :integer(11)
#  TEMPURL               :string(255)
#  HASHTITLE             :string(255)
#  ISAUDIT               :integer(19)
#  ISVALID               :integer(19)
#  ISCHOICENESSNUM       :integer(19)
#  BACKREASON            :string(510)
#  ISCHANGED             :string(510)
#  ISCHOICENESS          :string(510)
#  ISCOMMEND             :string(510)
#  ISPASS                :string(510)
#  CHECKPEOPLE           :integer(19)
#  EDITPEOPLE            :integer(19)
#  ADDPEOPLE             :integer(19)
#  ISREADY               :string(510)
#  COMPANYID             :integer(19)
#  CHANGEREASON          :string(150)
#  PV                    :integer(19)
#  DECIDE                :integer(19)
#  PROVINCE1             :integer(19)
#  PROVINCE2             :integer(19)
#  ISDV                  :string(510)
#  ISPROD                :string(510)
#  BRAND_ID              :integer(11)
#

# -*- coding: utf-8 -*-
class Article < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "51hejia.HEJIA_ARTICLE"
  self.primary_key = "ID"
  

  #根据ID找文章
  def self.get_article(id)
    self.find(:first, :conditions => ["id = ? and STATE <> -1", id])
  end

 
  ## 2012-11-21日添加  资讯推广位开始
  def self.promotion_articles(limit, keyword)
    article_ids = []
    tmp_article_ids = []
    zmbs = ZxMerchantBuy.find(:all, :select => "id,article_id,art_catname", :conditions => ["status=0 and art_catname like ?", "%#{keyword}%"], :order => "article_id desc")
    zmbs.each do |zmb|
      if zmb["art_catname"].split(";").include?(keyword)
        tmp_article_ids << zmb.article_id
      end
    end
    if tmp_article_ids.size <= limit
      article_ids = tmp_article_ids
    else
      limit.times do |i|
        index = rand([1,2,3,4,5].size)
        article_id = tmp_article_ids[index]
        article_ids << article_id
        tmp_article_ids.delete(article_id)
      end
    end
    article_ids
  end

=begin
  def self.promotion(options={})
    conditions = []
    unless options[:name1].blank?
      conditions << "name1='#{options[:name1]}'"
    end
    unless options[:name2].blank?
      conditions << "name2='#{options[:name2]}'"
    end
    unless options[:name3].blank?
      conditions << "name3='#{options[:name3]}'"
    end
    #ActiveRecord::Base.connection.select_all("SELECT id FROM 51hejia_php.zx_article_promotions where #{conditions.join(' and ')} order by id asc limit 1")
    []
  end
  
  def self.promotion_articles(limit = 1, options={})
    unless promotion(options).blank?
      promotion_id = promotion(options)[0]["id"]
      #ActiveRecord::Base.connection.select_all("SELECT article_id FROM 51hejia_php.zx_merchant_buy where promotion_id=#{promotion_id} and status=0 order by art_view desc limit #{limit}")
      []      
    end
  end
=end
  ## 2012-11-21日添加  资讯推广位结束

  belongs_to :article_sort, :foreign_key => 'FIRSTCATEGORY'

  belongs_to :article_content,
  :class_name => "ArticleContent",
  :foreign_key => "CONTENTID"

  belongs_to :article_brand,
  :class_name => "ArticleBrand",
  :foreign_key => "BRAND_ID"

  has_and_belongs_to_many :tags,
  :class_name => "ArticleTag",
  :join_table => "HEJIA_TAG_ENTITY_LINK",
  :foreign_key => "ENTITYID",
  :association_foreign_key => "TAGID"

  has_one :image,
  :class_name => "ArticleImage",
  :foreign_key => "article_id",
  :dependent => :destroy

  belongs_to :article_author,
  :class_name => "Bbsuser",
  :foreign_key => "ADDPEOPLE"

  belongs_to :article_author_new,
  :class_name => "User",
  :foreign_key => "EDITPEOPLE"

  belongs_to :article_author_check,
  :class_name => "User",
  :foreign_key => "CHECKPEOPLE"

  belongs_to :article_type1,
  :class_name => "ArticleTag",
  :foreign_key => "FIRSTCATEGORY"

  has_and_belongs_to_many :art,
  :class_name => "Article",
  :join_table => "HEJIA_TAG_ENTITY_LINK",
  :foreign_key => "ENTITYID",
  :association_foreign_key => "TAGID",
  :conditions =>["LINKTYPE = 'art_art'"]

  has_and_belongs_to_many :products,
  :join_table => "51hejia.HEJIA_TAG_ENTITY_LINK",
  :foreign_key => "ENTITYID",
  :association_foreign_key => "TAGID",
  :conditions =>["51hejia.HEJIA_TAG_ENTITY_LINK.LINKTYPE = 'art_prod'"]


  def self.getarticlebytag options={}

    brand = options[:brand]
    first = options[:first]
    second = options[:second]
    third = options[:third]
    begintime = options[:begintime]
    endtime = options[:endtime]
    order = options[:order]
    beginnum = options[:beginnum]
    allnum = options[:allnum]

    conditions = []
    conditions << "STATE='0'"
    conditions << "BRAND_ID = #{brand}" if brand && brand != '0'
    conditions << "FIRSTCATEGORY = '#{first}'" if first && first != '0'
    conditions << "SECONDCATEGORY = '#{second}'" if second && second != '0'
    conditions << "THIRDCATEGORY = '#{third}'" if third && third != '0'
    conditions << "CREATETIME >= '#{begintime}'" if begintime && begintime != ''
    conditions << "CREATETIME <= '#{endtime}'" if endtime && endtime != ''

    if order == '4'
      orderstr = ' PV asc '
    elsif order == '3'
      orderstr = ' PV desc '
    elsif order == '2'
      orderstr = ' ID asc '
    elsif order == '1'
      orderstr = ' ID desc '
    elsif order == '5'
      orderstr = ' FIRSTORDERID desc,ID desc '
    elsif order == '6'
      orderstr = ' SECONDORDERID desc,ID desc '
    elsif order == '7'
      orderstr = ' THIRDORDERID desc,ID desc '
    end

    if beginnum && allnum
      articles = find(:all,
                      :conditions => conditions.join(" and "),
                      :order => orderstr,
                      :offset => beginnum,
                      :limit => allnum)

      return articles
    else
      return nil
    end

  end

  #按id查找
  def self.getarticlebyid options={}
    ids = options[:ids]

    if ids
      return find(:all, :conditions => ["ID in (#{ids})"])
    else
      return nil
    end
  end


  def self.total_entries
    cache_key = Digest::MD5.hexdigest("article index total_entries")
    find_count = ""
    if CACHE.get(cache_key).blank?
      find_count = find_by_sql(" SELECT count(DISTINCT 51hejia.HEJIA_ARTICLE.ID) AS count_all FROM 51hejia.HEJIA_ARTICLE LEFT OUTER JOIN HEJIA_TAG ON HEJIA_TAG.TAGID = 51hejia.HEJIA_ARTICLE.FIRSTCATEGORY LEFT OUTER JOIN HEJIA_USER_BBS ON HEJIA_USER_BBS.USERBBSID = 51hejia.HEJIA_ARTICLE.ADDPEOPLE WHERE (STATE='0')")[0].count_all
      CACHE.set(cache_key, find_count)
    end
    CACHE.get(cache_key) || find_count
  end

  #统计数据查询(日期，编辑，状态，频道，类型)
  def self.countarticle(date,editorid,state,type1,stype)
    str = "select count(1) as c from HEJIA_ARTICLE where DATE_FORMAT(CREATETIME, '%Y-%m-%d')='"+date.to_s+"' and STATE = '"+state.to_s+"' and FIRSTCATEGORY = '"+type1.to_s+"' and EDITPEOPLE='"+editorid.to_s+"' and CITYORDERBY='"+stype.to_s+"'"
    find_count = find_by_sql(str)[0].c
    return find_count
  end

  #统计数据查询(日期范围，状态，频道，类型)
  def self.countarticledate(begindate,enddate,state,type1,stype)
    str = "select count(1) as c from HEJIA_ARTICLE where CREATETIME >'#{begindate}' and CREATETIME < '#{enddate}' and STATE = '#{state}' and FIRSTCATEGORY = '#{type1}' and CITYORDERBY='#{stype}'"
    find_count = find_by_sql(str)[0].c
    return find_count
  end

  #批量修改文章分类
  def self.updatetype(first,second,third,first2,second2,third2,authorid)
    conditions = ''

    if third == '0'
      conditions = conditions + " 1=1 "
    else
      conditions = conditions + " THIRDCATEGORY = '#{third}' "
    end
    conditions = conditions + ' and '

    if second == '0'
      conditions = conditions + " (SECONDCATEGORY = '0' or SECONDCATEGORY is null) "
    else
      conditions = conditions + " SECONDCATEGORY = '#{second}' "
    end
    conditions = conditions + ' and '

    if first == '0'
      conditions = conditions + " (FIRSTCATEGORY = '0' or FIRSTCATEGORY is null) "
    else
      conditions = conditions + " FIRSTCATEGORY = '#{first}' "
    end

    if authorid && authorid != ''
      conditions = conditions + "and EDITPEOPLE = #{authorid} "
    end

    str = "update HEJIA_ARTICLE set FIRSTCATEGORY = #{first2},SECONDCATEGORY = #{second2},THIRDCATEGORY = #{third2} where "+conditions

    find_by_sql(str) rescue ''

  end
  

  # 文章类型名称
  def type_name
    TYPE_NAMES[self.CHECK_BRAND]
  end
  
  def id
    self.ID
  end

  def title
    self.TITLE
  end

  def generate_url
    "http://www.51hejia.com"
  end

  def created_at
    # 注意这里不能改成 self.CREATETIME 否则时间差8个小时
    read_attribute("CREATETIME")
  end

  def created_date(short_date=false)
    return '' unless created_at
    if short_date
      created_at.strftime("%m-%d")
    else
      created_at.strftime("%Y-%m-%d")
    end
  end

  def keywords
    read_attribute("KEYWORD1").to_s.gsub(',', ';').gsub(' ', ';').split(';')
  end

  def keyword_links
    keywords.map{|e| "<a href='#{Article.get_url_by_keyword(e.strip)}' target='_blank'>#{e}</a>"}.join(' ')
  end

  # 文章终端页url
  def detail_url(is_preview = false, page = 1)
    page_str = ''
    page_str = '-all' if page == 'all'
    page_str = "-#{page}" if page.to_i > 1
    date = created_at && created_at.strftime('%Y%m%d') || '20000101'
    "http://#{subdomain}.51hejia.com/#{sort_sign}/#{date}/#{id}#{is_preview && '_preview' || ''}#{page_str}"
  end
  
  # 文章默认图片地址
  def detail_img_url
    image_url = "http://www.51hejia.com/api/images/none.gif"
    image_name = self.IMAGENAME
    create_time = self.CREATETIME.strftime("%Y%m%d") rescue ""
    unless image_name.nil?
      if image_name.include?("img")
        image_url = "http://img.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
      else
        image_url = "http://img.51hejia.com/files/hekea/article_img/sourceImage/#{create_time}/#{image_name} "
      end
    end
    return image_url
  end
  
  def sort_name
    self.article_sort && self.article_sort.name || '未知文章分类'
  end
  
  def sort_sign
    self.article_sort && self.article_sort.sign || ''
  end
  
  def template_name
    self.article_sort && self.article_sort.template_name || 'common'
  end
  
  def subdomain
    self.article_sort && self.article_sort.subdomain || 'www'
  end

  def channel_sign
    channel = sort_sign
    channel = 'pinlei' if PINLEI_SIGNS.include?(sort_sign)
    channel = 'dianxing' if DIANXING_SIGNS.include?(sort_sign)
    channel
  end


  
  class << self
    #根据ID找文章
    def get_article(id)
      find(:first, :conditions => ["id = ? and STATE <> -1", id])
    end
  end
  
end
