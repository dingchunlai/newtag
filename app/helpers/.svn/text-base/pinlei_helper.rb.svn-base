module PinleiHelper

  def get_article_url(tagurl, createtime, id)
    s = []
    s << "http:/"
    if tagurl == "zhuangxiu"
      s << "d.51hejia.com"
    else
      s << "www.51hejia.com"
    end
    s << tagurl
    s << createtime.strftime("%Y%m%d")
    s << id.to_s
    return s.join("/")
  end

  def get_brands(kw, sort, limit)
    category_id = get_product_category_id(kw, sort)
    if category_id == 0
      return []
    else
      return ProductBrand.find(:all,:select=>"b.id, b.name_zh, b.view_count",:joins=>"b, product_brands_categories bc",:conditions=>"b.id=bc.brand_id and bc.category_id = #{category_id}",:order=>"view_count desc",:limit=>limit)
    end
  end

  def get_products(kw, sort, limit)
    category_id = get_product_category_id(kw, sort)
    if category_id == 0
      return []
    else
      return Product.find(:all,:select=>"id,productid,name,now_price,unit",:conditions=>"is_delete = 0 and status = 1 and category_id = #{category_id}",:order=>"view_count desc",:limit=>limit)
    end
  end

  def get_product_category_id(kw, sort)
    kw = trim(kw)
    kw_pci = "pci6_" + kw
    pcid = mc(kw_pci)
    if pcid.nil?
      pc = ProductCategory.find(:first,:select=>"id, products_count",:conditions=>"parent_id > 1 and is_valid = 0 and name_zh like '%%#{kw}%%'",:order=>"products_count desc")
      products_count = pc.products_count.to_i rescue 0
      if pc.nil? || products_count < 6
        sort = "油漆" if sort == "涂料"
        sort = "石材" if sort == "瓷砖"
        pc = ProductCategory.find(:first,:select=>"id",:conditions=>"parent_id > 1 and is_valid = 0 and name_zh like '%%#{sort}%%'",:order=>"products_count desc")
        if pc.nil? || sort.to_s.length == 0
          pcid = 0
        else
          pcid = pc.id
        end
      else
        pcid = pc.id
      end
      mc(kw_pci, pcid)
    end
    return pcid.to_i
  end

  def format_price(price, unit, typehood = nil)
    price_string = ""
    if typehood && typehood == 3
      price_string << "<span>特价中</span> 电询"
    else
      price_string << "<span>#{(price && price != 0 && price != 888888) ? number_to_currency(price, :unit => '', :precision => 0, :delimiter => "") : '电询 '}</span>"
      price_string << "元/"+"#{unit || '件'}"
    end
    return price_string
  end

  def get_sortlist_by_sort_id(sort_id, subsort)
    sorts = Pinlei.find(:all,:select=>"id,name",:conditions=>"sort_id=#{sort_id} and subsort=#{subsort}")
    if sorts.length == 0
      return []
    else
      return sorts
    end
  end

end
