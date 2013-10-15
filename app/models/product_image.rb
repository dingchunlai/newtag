class ProductImage < ActiveRecord::Base
  include ConnProduct
  #acts_as_readonlyable :read_only_a
  belongs_to :product
  has_attachment :content_type => :image,
                   :storage => :file_system,
                   :path_prefix => "public/images/products"
                   #:max_size => 500.kilobytes,
                   #:resize_to => '320x200',
                   #:thumbnails => { :thumb => '130x40', :medium => '200x62' },
                   #:processor => :Rmagick
  validates_as_attachment

#  def full_path(thumbnail = nil)
#    path_prefix = PRODUCT_IMAGES_PATH_PREFIX
#    path = ""
#    path << path_prefix
#    if self.filename.length == 28
#      path << self.filename[3,8]
#      path << "/"
#      path << "tn/" if thumbnail
#      path << self.filename
#    else
#      #path << "/"
#      path << (thumbnail ? (File.split(self.filename)[0] + "/tn/" + File.split(self.filename)[1]) : self.filename)
#    end
#    return path
#  end

  def full_path(thumbnail = nil)
    path_prefix = PRODUCT_IMAGES_PATH_PREFIX
    path = ""
    if File.split(self.filename)[0] == "source1"
      path << "/"
      path << (thumbnail ? (File.split(self.filename)[0] + "/" + File.split(self.filename)[1] + "/tn/" + File.split(self.filename)[2]) : self.filename)
    elsif self.filename.include?("/") || self.filename.length == 28
      path << path_prefix
      if self.filename.length == 28
        path << self.filename[3,8]
        path << "/"
        path << "tn/" if thumbnail
        path << self.filename
      else
        #path << "/"
        path << (thumbnail ? (File.split(self.filename)[0] + "/tn/" + File.split(self.filename)[1]) : self.filename)
      end
    else
      path << "http://p.51hejia.com" + self.public_filename(thumbnail)
    end
    return path
  end

end
