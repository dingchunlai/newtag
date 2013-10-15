class HejiaCase < Hejia::Db::Hejia

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "HEJIA_CASE"

  CASES_PER_PAGE = 12

  def title
    read_attribute('NAME')
  end

  def url
    if self.COMPANYID == 7 || self.COMPANYID.nil?
      "http://tuku.51hejia.com/zhuangxiu/tuku-#{read_attribute('ID')}"
    else
      "/gs-#{self.COMPANYID}/cases-#{self.ID}"
    end
  end

  def image_url
    type_id = read_attribute('TYPE_ID').to_i
    if type_id == 5 || type_id == -5
      "http://image.51hejia.com#{read_attribute('MAINPHOTO')}"
    else
      "http://image.51hejia.com/files/hekea/case_img/tn/#{read_attribute('ID')}.jpg"
    end
  end

  class << self

    def get_cases(keyword1, keyword2 = '', page = 1)
      keyword1 = keyword1.to_s.strip; keyword2 = keyword2.to_s.strip
      memkey = "memkey_hejia_cases_10_#{keyword1}_#{keyword2}_#{page}"
      CACHE.fetch(memkey, keyword2.blank? ? 1.day : 3.days) do
        case_ids = []
        unless keyword2.blank?
          tag_id2 = get_case_id(keyword2)
          conditions = []
          conditions << "l.ENTITYID = c.ID and l.LINKTYPE='case' and c.STATUS <> '-100' and l.STATUS <> -1 and c.ISZHUANGHUANG <> '1'"
          conditions << "l.TAGID = #{tag_id2} and c.show_tuku=1"
          case_ids = HejiaCase.find(:all,:select => "c.ID",:joins => "c, HEJIA_TAG_ENTITY_LINK l",
            :conditions => conditions.join(" and "),
            :limit => 4000
          ).collect{|r| r.ID.to_i}
        end

        tag_id1 = get_case_id(keyword1)
        conditions = []
        conditions << "l.ENTITYID = c.ID and l.LINKTYPE='case' and c.STATUS<>'-100' and l.STATUS <> -1 and c.ISZHUANGHUANG <> '1'"
        conditions << "l.TAGID = #{tag_id1} and c.show_tuku=1"
        conditions << "c.ID in (#{case_ids.join(",")})" if case_ids.length > 0
        HejiaCase.paginate(
          :select => "c.ID,c.NAME,c.INTRODUCE,c.TYPE_ID,c.ISZHUANGHUANG,c.MAINPHOTO,c.COMPANYID,c.CREATEDATE",
          :joins => "c, HEJIA_TAG_ENTITY_LINK l",
          :conditions => conditions.join(" and "),
          :order => "c.ID desc",
          :page => page,
          :per_page => CASES_PER_PAGE
        )
      end
    end

    def get_url(case_id, companyid=0, iszhuanghuang=nil)
      #      if iszhuanghuang.nil? || companyid == 0
      #        kw_mc = "hejia_case_url_2_#{case_id}"
      #        companyid, iszhuanghuang = get_mc(kw_mc) do
      #          hc = HejiaCase.find(case_id, :select=>"COMPANYID, ISZHUANGHUANG") rescue {}
      #          [hc["COMPANYID"], hc["ISZHUANGHUANG"]]
      #        end
      #      end
      #      if iszhuanghuang.to_i == 1
      #        return "http://z.51hejia.com/gs-#{companyid}/cases-#{case_id}"
      #      else
      return "http://tuku.51hejia.com/zhuangxiu/tuku-#{case_id}"
      #      end
    end
    
    #根据城市查找最新案例
    def get_case_for_city(city, limit)
      CACHE.fetch("get_case/city/#{city}/#{limit}", 1.hours) do
        condition =  (city.to_i == 11910) ? ["deco_firms.city = ? and HEJIA_CASE.STATUS <> '-100'", city] : ["deco_firms.district = ? and HEJIA_CASE.STATUS <> '-100'", city] 
        HejiaCase.find(:all,
          :joins => "JOIN deco_firms ON deco_firms.id = HEJIA_CASE.COMPANYID",
          :conditions => condition,
          :order => "CREATEDATE desc",
          :limit => limit
          )
      end
    end
    
  end

end
