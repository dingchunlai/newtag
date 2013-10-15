class Product < ActiveRecord::Base

  include ConnProduct
  has_many :images, :class_name => "ProductImage"
  has_one :primary_image, :class_name => "ProductImage", :conditions => ["is_primary = ?", 1]


  PRICE_RANGE = {
    1 => "0",
    2 => "1-100",
    3 => "100-500",
    4 => "500-1000",
    5 => "1000-2000",
    6 => "2000-5000",
    7 => "5000+"
  }

  def self.search(keyword)
    if keyword
      find(:all, :conditions => ['name LIKE ?', "%#{keyword}%"])
    else
      find(:all)
    end
  end

  def hot_products(num)
    if self.vendor
      self.vendor.products.find(:all, :conditions => ["id != ?", self.id], :limit => num, :order => "marking desc")
    else
      []
    end
  end

  def primary_image_path(thumbnail = nil)
    primary_image ? primary_image.full_path(thumbnail) : PRODUCT_DEFAULT_PRIMARY_IMAGE_PATH
  end

  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, *partitioned_path(thumbnail_name_for(thumbnail)))
  end

  def common_images
    images.find(:all, :conditions => ["is_primary = ?", "0"])
  end

  def self.direct_products
    self.find(:all, :conditions => ["typehood = ?", 1])
  end

end
