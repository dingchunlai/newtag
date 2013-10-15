class IpAdsController < ApplicationController

  def index
    i_now = params[:i_now]
    @is_shanghai = cookies["is_hejia_shanghai_user"].to_i
    @is_shanghai = is_shanghai_ip(request.remote_ip) if @is_shanghai == 0
    if @is_shanghai == 1
      cookies["is_hejia_shanghai_user"] = {:value => "1",  :domain=>".51hejia.com", :expires => 90.days.from_now }
      cookies["hejia_every_day_ad"] = {:value => i_now,  :domain=>".51hejia.com", :expires => 90.days.from_now }
    else
      cookies["is_hejia_shanghai_user"] = {:value => "2", :domain=>".51hejia.com", :expires => 90.days.from_now }
    end
  end

  def is_shanghai_ip(ip)  #判断IP地址是否是上海的（1是0否）
    user_ip = 0
    user_ipa = ip.to_s.split(".") 
    if user_ipa.length == 4
      0.upto(3) do |i|
        user_ip += (user_ipa[i].to_i * (256 ** (3-i)))
      end
      return IpAddress.find(:first,:select=>"is_shanghai",:conditions=>"ipstart < #{user_ip} and ipend > #{user_ip}").is_shanghai.to_i rescue 0
    else
      return 2
    end
  end

end
