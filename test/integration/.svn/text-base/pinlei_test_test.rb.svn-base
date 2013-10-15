require "#{File.dirname(__FILE__)}/../test_helper"

class PinleiTestTest < ActionController::IntegrationTest
  # fixtures :your, :models

  # Replace this with your real tests.
  def test_truth
    ['diban',
      'chuguipindao',
      'youqituliao',
      'buyi',
      'cizhuan',
      'jiajuchanpin',
      'jiadian',
      'zhaomingpindao',
      'cainuan',
      'weiyupindao',
      'menchuang',
      'jiajushoucang'].each do |e|
      get "/#{e}/"
      assert_response :success
    end
  end
end
