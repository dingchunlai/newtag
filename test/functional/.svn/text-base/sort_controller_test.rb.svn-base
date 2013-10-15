require File.dirname(__FILE__) + '/../test_helper'
require 'sort_controller'

# Re-raise errors caught by the controller.
class SortController; def rescue_action(e) raise e end; end

class SortControllerTest < Test::Unit::TestCase
  def setup
    @controller = SortController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    get :index
    assert_response :success
    assert_template "index"
    
  end
end
