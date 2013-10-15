class MyLinkRenderer < WillPaginate::LinkRenderer

  protected

  def url_for(page)
    params = @template.controller.params
    controller_name = params["controller"]
    action_name = params["action"]
    if controller_name == "list" && action_name == "keyword"
      return "/#{params[:keyword]}-#{page}.html"
    else
      super(page) #调用WillPaginate的默认生成的url
    end
  end
  
end
