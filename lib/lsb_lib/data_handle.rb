module LsbLib::DataHandle

  protected #下面是受保护的方法（或使用 private）

  #取得“通过多个关键字查询到的数据集合”，并返回其中指定数量的记录。
  def get_rs_by_any_keywords(kws, limit)  
    ars = []
    kws = kws.split(",") unless kws.class == Array
    for kw in kws
      rs = yield(kw, limit)
      for r in rs
        ars << r
        return ars if ars.length == limit
      end
    end
    return ars
  end

  def get_key(prefix, *keywords)
    key = ["#{MEMCACHE_PREFIX_KEY}_#{prefix}"].concat(keywords).join("_").gsub(" ","")
    key = key[0,50] if key.length > 50
    return key
  end

  def get_cache_key(templet, *values)
    0.step(values.length-1, 2) do |i|
      templet = templet.sub(values[i].to_s, values[i+1].to_s)
    end
    return get_key(templet)
  end

  #尝试获取相应关键字的本地缓存
  def get_lcache(kw, expire=1.month)
    rv = lcache(kw)
    if rv.nil? && block_given?
      rv = yield
      lcache(kw, rv, expire)
    end
    return rv
  end

  #调用或保存本地全局缓存
  def lcache(kw, value=nil, expire=1.month)
    kw = kw.strip
    fail("The local_cache's keyword can't be blank!") if kw.blank?
    if value.nil?
      rv = nil
      if $local_cache.nil?
      elsif $local_cache[kw].nil?
      elsif $local_cache[kw][1].nil?
      elsif Time.now > $local_cache[kw][1]
        $local_cache[kw] = nil  #缓存已过期，自动清除缓存。
      else
        rv = $local_cache[kw][0]  #如果缓存存在且未过期，读取缓存。
      end
      return rv
    else
      $local_cache = {} if $local_cache.nil?
      $local_cache[kw] = [value, Time.now + expire]
    end
  end

  #尝试获取相应关键字的memcache缓存
  def get_memcache(kw, expire=1.month, regain=0)
    rv = memcache(kw)
    if (rv.nil? && block_given?) || regain==1
      rv = yield
      memcache(kw, rv, expire)
    end
    return rv
  end

  #调用或保存本地memcache缓存缓存
  def memcache(kw, value=nil, expire=1.month)
    kw = kw.to_s.gsub(" ","")
    fail("The memcache's keyword can't be blank!") if kw.blank?
    if value.nil?
      return CACHE.get(kw)
    else
      if expire == 0
        CACHE.set(kw, value)
      else
        expire = 1.month if expire > 1.month  #memcache的过期时间不能超过一个月，否则会报错。
        CACHE.set(kw, value, expire)
      end
    end
  end

  #清除指定关键词的memcache缓存
  def expire_memcache(kw)
    CACHE.set(kw, nil, 1)
  end

  #直接执行sql语句
  def dosql(str)
    return ActiveRecord::Base.connection.execute(str)
  end
    
end
