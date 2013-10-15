require File.dirname(__FILE__) + '/../test_helper'
require 'dianxing_controller'

# Re-raise errors caught by the controller.
class DianxingController; def rescue_action(e) raise e end; end

class DianxingControllerTest < Test::Unit::TestCase
  def setup
    @controller = DianxingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
