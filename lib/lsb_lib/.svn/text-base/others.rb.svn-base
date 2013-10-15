module LsbLib::Others

  protected #下面是受保护的方法（或使用 private）

  #辅助will_paginate插件显示记录数的方法
  def mypage_entries_info(rs, options)
    options[:show_total_entries] = true if options[:show_total_entries].nil?
    options[:show_page_link] = false if options[:show_page_link].nil?
    options[:entry_name] = "记录" if options[:entry_name].nil?
    total_page = (rs.total_entries.to_f/rs.per_page.to_f).ceil
    strs = []
    strs << "总共<b>#{rs.total_entries}</b>条#{options[:entry_name]}" if options[:show_total_entries]
    strs << "当前显示第<b>#{rs.current_page}</b>页 共<b>#{total_page}</b>页"
    strs << will_paginate(rs,:inner_window => 1,:outer_window => 1,:page_links => false,:prev_label => '上一页',:next_label => '下一页') if options[:show_page_link]
    return strs.join(" 　")
  end

  #取得上传的文件并保存，返回已保存的文件名。
  def save_file(file, save_path, maxsize)
    return nil if file.type==String || file.type==Array || file==nil
    if file.original_filename.empty?
      return nil
    else
      if file.size/1024 > maxsize.to_i && maxsize != 0
        return maxsize.to_i
      else
        filename = generate_filename(file.original_filename)
        filepath = "#{RAILS_ROOT}/public#{save_path}#{filename}"
        File.open(filepath, "wb") do |f|
          f.write(file.read)
        end
        return save_path + filename
      end
    end
  end

  #根据原文件名，结合单前系统时间生成新的文件名
  def generate_filename(old_name)
    old_name = old_name.split(".")
    suffix = old_name[old_name.length-1]  #取得原文件名后缀
    new_name = Time.now.strftime("%Y%m%d_%H%M_#{('a'..'z').to_a[rand(26)]}%S")
    return new_name + "." + suffix
  end

  def get_pagelist(url_prefix, recordcount, pagesize, curpage, cur_list, listsize)
    listsize_half = listsize / 2
    pagecount = (recordcount.to_f / pagesize.to_f).ceil
    return "没有任何数据记录" if pagecount == 0
    return "共1页 当前显示第1页" if pagecount == 1
    if curpage < (listsize_half)
      pages = 1..listsize
    elsif pagecount - curpage < (listsize_half)
      pages = (pagecount-listsize+1)..pagecount
    else
      pages = (curpage-listsize_half)..(curpage+listsize_half)
    end
    strs = []
    if curpage != 1
      strs << "<a target=\"_self\" title=\"跳转至首页\" href=\"#{url_prefix}\">首页</a>" + " <a target=\"_self\" title=\"跳转至第#{curpage-1}页\" href=\"#{url_prefix}?page=#{curpage-1}\">上一页</a> &nbsp;"
    end
    for page in pages
      if page > 0 && page <= pagecount
        if page == curpage
          strs << page.to_s
        else
          strs << "<a target=\"_self\" title=\"跳转至第#{page}页\" href=\"#{url_prefix}?page=#{page}\">#{page}</a>"
        end
      end
    end
    if curpage != pagecount
      strs << "&nbsp; <a target=\"_self\" title=\"跳转至第#{curpage+1}页\" href=\"#{url_prefix}?page=#{curpage+1}\">下一页</a> " + "<a target=\"_self\" title=\"跳转至第#{pagecount}页\" href=\"#{url_prefix}?page=#{pagecount}\">尾页</a>"
    end
    return strs.join(" ")
  end

  #将指定的url内容保存为静态文件
  def save_url_to_file(url, path="", filename="index.html")
    begin
      require 'open-uri'
      path = "/#{path}/".gsub("\\","/").gsub("//","/").gsub("//","/").sub("/public","")
      save_path = "#{RAILS_ROOT}/public#{path}"
      str = open(url) do |f|
        f.read
      end
      dirs = path.split("/")
      if dirs.length > 0
        dirs.shift if dirs[0].length == 0
        dirs.pop if dirs[dirs.length-1].length == 0
        0.upto(dirs.length-1) do |i|
          dir = "#{RAILS_ROOT}/public/#{dirs[0..i].join("/")}"
          Dir.mkdir(dir) unless File.exist?(dir)  #创建每个不存在的文件夹
        end
      end
      file = File.new("#{save_path}#{filename}", "w")
      file.print(str)
      file.close_write
      return "<a href='#{path}#{filename}' target='_blank'>#{path}#{filename}</a>"
    rescue Exception => e
      return e.to_s
    end
  end

    
end
