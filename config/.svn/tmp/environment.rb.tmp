# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.5' unless defined? RAILS_GEM_VERSION

class String
  alias mb_chars chars
  
  remove_method :chars
end if RUBY_VERSION > '1.8.6'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

$KCODE = "u"

require 'memcache'
memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "tag-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}
publish_memcache_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "publish-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

memcache_servers = ['memcachehost:11311']

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  config.plugin_paths += %w[vendor/extensions]
  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  # config.action_controller.session_store = :mem_cache_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end

  # See Rails::Configuration for more options

  require File.join(RAILS_ROOT, 'vendor/extensions/hejia/lib/hejia/sys_logger') # 根据实际情况来填写路径信息
  Hejia::SysLogger.app = 'newtag' # 配置项目的名称，方便区分日志的信息是从哪个项目里面出来的
  config.logger = Hejia::SysLogger.instance
  
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
publish_params = *([memcache_servers, publish_memcache_options].flatten)
PUBLISH_CACHE = MemCache.new *publish_params
cache_params = *([memcache_servers, memcache_options].flatten)
CACHE = MemCache.new *cache_params
# ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })

ENTITY_TYPE = ["","文章","博客","论坛","图片","产品","问吧","装修日记"]
PINLEI_SORT = ["请选择","涂料","地板","瓷砖","卫浴","家具","布艺","家电","橱柜","采暖","照明","水处理"]  #品类频道大类分类
PINLEI_URL = ["","youqituliao","diban","cizhuan","weiyupindao","jiajuchanpin","buyi","jiadian","chuguipindao","cainuan","zhaomingpindao","shuichuli"]  #品类频道大类分类
PINLEI_SORT1 = ["", "大类", "大类", "大类", "座便器/马桶", "风格", "窗帘种类", "大类", "台面", "采暖方式", "大类", "大类"]
PINLEI_SORT2 = ["", "小类", "小类", "小类", "浴缸/淋浴房", "材质", "墙纸", "小类", "门板", "采暖设备", "小类", "小类"]
ZHUANQU_BOARD = ["", "装修", "装饰", "产品", "行业", "品牌", "城市", "家居生活"]
ZHUANQU_BOARD_SPELL = ["www", "d", "deco", "prod", "news", "b", "d", "case"]
ZHUANQU_CITY =[
  ['shanghai','上海'],['suzhou','苏州'],['ningbo','宁波'],['hangzhou','杭州'],['wuxi','无锡'],
  ['wuhan','武汉'],['nanjing','南京'],['qingdao','青岛'],['changsha','长沙'],['hefei','合肥'],
  ['zhengzhou','郑州'], ['beijing', '北京'],['guangzhou', '广州'],['shenzhen','深圳'],['haikou','海口'],
  ['xiamen', '厦门'],['chengdu', '成都'],['chongqing', '重庆'],['tianjin', '天津'],['changchun', '长春'],
  ['dalian', '大连'],['haerbin', '哈尔滨'],['kunming', '昆明'],['shijiazhuang', '石家庄'],['taiyuan', '太原'],['xian', '西安']
]

PRODUCT_IMAGES_PATH_PREFIX = "http://image.51hejia.com/files/hekea/img/"
PRODUCT_DEFAULT_PRIMARY_IMAGE_PATH = "/images/product.jpg"

ZONE_IDS = {"chufang1" =>134 ,"huayuanshenghuo1" =>144 ,"weiyu1" =>257 ,
  "chaojizhufu1" =>145 ,"shufang1" =>280 ,"ertongfang1" =>262 ,
  "bieshu1" =>365 ,"ershoufang1" =>88 ,"xiaohuxing1" =>367 ,
  "beijingqiang1" =>366 ,"woshi1" =>294 ,"keting1" =>272 ,
  "chufang2" =>135 ,"huayuanshenghuo2" =>384 ,"weiyu2" =>381 ,
  "chaojizhufu2" =>385 ,"shufang2" =>377 ,"ertongfang2" =>387 ,
  "bieshu2" =>379 ,"ershoufang2" =>378 ,"xiaohuxing2" =>383 ,
  "beijingqiang2" =>388 ,"woshi2" =>380 ,"keting2" =>386 }

MEMCACHE_PREFIX_KEY = "tag"

gem 'will_paginate', '<3.0.pre'
require 'will_paginate'

WillPaginate::ViewHelpers.pagination_options[:renderer] = 'MyLinkRenderer'

gem 'hejia_ext_links', '~> 0.7.13'
require 'hejia'
Hejia.configuration.set :user_model => 'hejia_user_bbs', :staff_model => 'hejia_staff', :cache => PUBLISH_CACHE
Hejia.rails_init

# == 开始加载hoptoad错误通知服务
require 'hoptoad_notifier'
require 'hoptoad_notifier/rails'

HoptoadNotifier.configure do |config|
  config.api_key = 'd6d29d8503489aa3fd09505f7f2b05ae'
end
# == hoptoad错误通知服务加载完毕