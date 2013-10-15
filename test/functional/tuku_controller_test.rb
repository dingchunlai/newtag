require File.dirname(__FILE__) + '/../test_helper'
require 'tuku_controller'

# Re-raise errors caught by the controller.
class TukuController; def rescue_action(e) raise e end; end

class TukuControllerTest < Test::Unit::TestCase
  def setup
    @controller = TukuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
