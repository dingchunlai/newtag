require File.dirname(__FILE__) + '/../test_helper'
require 'taotu_controller'

# Re-raise errors caught by the controller.
class TaotuController; def rescue_action(e) raise e end; end

class TaotuControllerTest < Test::Unit::TestCase
  def setup
    @controller = TaotuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
