require "#{File.dirname(__FILE__)}/../test_helper"

class MyTest < ActionController::IntegrationTest
  # fixtures :your, :models

  # Replace this with your real tests.
  def test_tag
    urls = []
    urls << "/"
    urls << "/家居.html"
    urls << "/chufang/"
    urls << "/siteindex/result/装修.html"
    for url in urls
      get url
      assert_response :success
      #      assert_select "title", ""
      #      assert_template "index"
    end
  end

  def test_zq
    urls = []
    urls << "/zq/"
    urls << "/zq/阳光房/"
    urls << "/zq/马赛克-金属马赛克.html"
    for url in urls
      get url
      assert_response :success
    end
  end

  def test_tuku
    urls = []
    urls << "/"
    urls << "/zhuanqu/"
    urls << "/zhuanqu/别墅.html"
    urls << "/pic/客厅.html"
    urls << "/pic/卧室/183028.html"
    for url in urls
      get url
      assert_response :success
    end
  end
  
end
