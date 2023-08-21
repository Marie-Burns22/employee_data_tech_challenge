require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get employees_show_url
    assert_response :success
  end
end
