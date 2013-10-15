class IndexController < ApplicationController

  def test
    render :layout => false
  end

  def index #tag频道首页
    #    if read_fragment :action=>"index", :part=>"keywords"
    #有百分之一的概率访问的同时更新缓存
    expire_fragment :action=>"index", :part=>"keywords" if rand(100) == 0
  end

  def change_memcache_key_prefix  #修改key_name相关缓存关键字前缀
    key_name = params[:key_name]
    if trim(key_name).length == 0
      @alert_text = "操作错误：参数不足！"
    else
      old_key = mc(key_name)
      if old_key.nil?
        new_key = get_memcache_key_prefix(key_name)
      else
        t = old_key.gsub(key_name, "").to_i
        if t == 9999
          t = 1
        else
          t += 1
        end
        new_key = "#{key_name}#{t}"
      end
      mc(key_name, new_key)
      @alert_text = "操作成功：缓存关键字 #{key_name} 的值已修改为 #{new_key}"
    end
    myrender
  end

  def zq_index
    
    return false if p_to_prod
    return false if add_slash_at_url_tail
    board_id = get_board_id_by_hostname
    @hostname = "#{ZHUANQU_BOARD_SPELL[board_id]}.51hejia.com"
    @zq_name = ZHUANQU_BOARD[board_id]
    
    @tags = []
    if board_id == 0
      1.upto(ZHUANQU_BOARD.length-1) do |i|
        tags = []
        for tag in ZhuanquSort.get_sorts_by_board_id(i)
          tags << tag.sort_name.to_s
        end
        @tags << [i, ZHUANQU_BOARD[i], tags]
      end
    else
      f_tags = ZhuanquSort.get_sorts_by_board_id(board_id)
      for f_tag in f_tags
        f_id = f_tag.id
        tags = []
        for tag in ZhuanquKw.get_kw_names_by_sort_id(f_id)
          tags << tag
        end
        @tags << [f_tag.id, f_tag.sort_name, tags]
      end
    end

    if board_id == 0
      render :action => "zq_index_all"
    else
      render :action => "zq_index"
    end
  end

  def development
    redirect_to "http://seven.51hejia.com:#{request.env["SERVER_PORT"]}"
  end

  protected
  
  def get_board_id_by_hostname
    hostname = request.env["HTTP_HOST"].split(".")[0]
    board_id = 0
    0.upto(ZHUANQU_BOARD_SPELL.length-1) do |i|
      board_id = i if ZHUANQU_BOARD_SPELL[i] == hostname
    end
    board_id = 1 if board_id == 6
    return board_id
  end
  
end
