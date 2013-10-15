ActionController::Routing::SEPARATORS <<  "-" unless ActionController::Routing::SEPARATORS.include?("-") 
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  map.connect '', :controller => 'index', :action => 'index'
  map.connect 'link/link/index.htm', :controller => 'api', :action => 'hejia_links'

  map.connect ':keyword.html', :controller => 'list', :action => 'keyword'  #tag频道详情页
  map.connect ':keyword-:page.html', :controller => 'list', :action => 'keyword'
  map.connect ':keyword-:page-:recordcount.html', :controller => 'list', :action => 'keyword'

  #以下是“典型频道”路由
  map.connect 'jushang', :controller => 'dianxing', :action => 'jushang'
  map.connect 'chufang', :controller => 'dianxing', :action => 'index'
  map.connect 'huayuanshenghuo', :controller => 'dianxing', :action => 'index'
  map.connect 'weiyu', :controller => 'dianxing', :action => 'index'
  map.connect 'chaojizhufu', :controller => 'dianxing', :action => 'index'
  map.connect 'shufang', :controller => 'dianxing', :action => 'index'
  map.connect 'ertongfang', :controller => 'dianxing', :action => 'index'
  map.connect 'bieshu', :controller => 'dianxing', :action => 'index'
  map.connect 'ershoufang', :controller => 'dianxing', :action => 'index'
  map.connect 'xiaohuxing', :controller => 'dianxing', :action => 'index'
  map.connect 'beijingqiang', :controller => 'dianxing', :action => 'index'
  map.connect 'woshi', :controller => 'dianxing', :action => 'index'
  map.connect 'keting', :controller => 'dianxing', :action => 'index'
  map.connect 'gongyu', :controller => 'dianxing', :action => 'index'
  map.connect 'hunfang', :controller => 'dianxing', :action => 'index'

  #以下是“品类频道”路由
  map.connect 'pinlei/index.html', :controller => 'pinlei', :action => 'index'
  map.connect 'diban/index.html', :controller => 'pinlei', :action => 'index'
  map.connect 'buyi/index.html', :controller => 'pinlei', :action => 'index'
  map.connect 'diban', :controller => 'pinlei', :action => 'index'
  map.connect 'chuguipindao', :controller => 'pinlei', :action => 'index'
  map.connect 'youqituliao', :controller => 'pinlei', :action => 'index'
  map.connect 'buyi', :controller => 'pinlei', :action => 'index'
  map.connect 'cizhuan', :controller => 'pinlei', :action => 'index'
  map.connect 'jiajuchanpin', :controller => 'pinlei', :action => 'index'
  map.connect 'jiadian', :controller => 'pinlei', :action => 'index'
  map.connect 'zhaomingpindao', :controller => 'pinlei', :action => 'index'
  map.connect 'cainuan', :controller => 'pinlei', :action => 'index'
  map.connect 'weiyupindao', :controller => 'pinlei', :action => 'index'
  map.connect 'menchuang', :controller => 'pinlei', :action => 'index'
  map.connect 'jiajushoucang', :controller => 'pinlei', :action => 'index'


  #以下是“品类频道内页”相关路由
  map.connect 'pinlei/:keyword.html', :controller => 'pinlei', :action => 'detail'
  map.connect 'diban/:keyword.html', :controller => 'pinlei', :action => 'detail'
  map.connect 'buyi/:keyword.html', :controller => 'pinlei', :action => 'detail'
  map.connect 'community/:sort_id.html', :controller => 'pinlei', :action => 'community'

  #以下是其它路由
  map.connect 'all/:keyword.html', :controller => 'list', :action => 'keyword'
  map.connect 'all/:keyword-:page.html', :controller => 'list', :action => 'keyword'

  map.connect 'article/:keyword.html', :controller => 'list', :action => 'keyword'
  map.connect 'blog/:keyword.html', :controller => 'list', :action => 'keyword'
  map.connect 'image/:keyword.html', :controller => 'list', :action => 'keyword'
  map.connect 'bbs/:keyword.html', :controller => 'list', :action => 'keyword'
  map.connect 'product/:keyword.html', :controller => 'list', :action => 'keyword'

  map.connect 'zq/cmc/:key_name', :controller => 'index', :action => 'change_memcache_key_prefix' #修改key_name相关缓存关键字前缀
  map.connect 'zq', :controller => 'index', :action => 'zq_index'       #栏目专区关键词索引页
  map.connect 'zq/:sort_name/more', :controller => 'index', :action => 'zq_index'
  map.connect 'zq/:sort_name', :controller => 'sort', :action => 'index'  #栏目专区详情页
  map.connect 'zq/:sort_name-:keyword.html', :controller => 'zhuanqu', :action => 'keyword'
  map.connect 'zq/:sort_name-:keyword-:page.html', :controller => 'zhuanqu', :action => 'keyword'
  map.connect 'zq/:sort_name-:keyword-:page-:recordcount.html', :controller => 'zhuanqu', :action => 'keyword'
  

  map.connect 'zhuanqu', :controller => 'tuku', :action => 'tuku_index'               #套图专区关键词索引页
  map.connect 'zhuanqu/:tag_id', :controller => 'tuku', :action => 'tuku_index_more'  #套图专区关键词二级页
  map.connect 'zhuanqu/:keyword.html', :controller => 'taotu', :action => 'keyword'   #套图专区详情页
  map.connect 'zhuanqu/:keyword-:page.html', :controller => 'taotu', :action => 'keyword'
  map.connect 'zhuanqu/:keyword-:page-:recordcount.html', :controller => 'taotu', :action => 'keyword'

  map.connect 'pic/:keyword.html', :controller => 'dantu', :action => 'list'                      #单图专区列表页
  map.connect 'pic/:keyword-:page.html', :controller => 'dantu', :action => 'list'                #单图专区列表页
  map.connect 'pic/:keyword-:page-:recordcount.html', :controller => 'dantu', :action => 'list'   #单图专区列表页
  map.connect 'pic/:keyword/:photo_id.html', :controller => 'dantu', :action => 'detail'          #单图专区详情页
  map.connect 'zq/dantu_pingfen/:kw/:type.js', :controller => 'dantu', :action => 'dantu_pingfen'
  map.connect 'siteindex/result/:kw2/:kw1.html', :controller => 'siteindex', :action => 'result'
  map.connect 'siteindex/result/:kw1.html', :controller => 'siteindex', :action => 'result'
  map.connect 'siteindex/result/:kw2/:kw1', :controller => 'siteindex', :action => 'result'
  map.connect 'siteindex/result/:kw1', :controller => 'siteindex', :action => 'result'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
