require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "signin with valid token sets cookie and redirects" do
    auth_token = AuthToken.create!(token: "valid_token_123")

    get signin_url(token: "valid_token_123")

    assert_redirected_to root_path
    assert_equal "granted", cookies[:write_access]
    assert_equal "Successfully authenticated! You now have write access.", flash[:notice]
    assert_nil AuthToken.find_by(token: "valid_token_123")
  end

  test "signin with invalid token redirects with error" do
    get signin_url(token: "invalid_token")

    assert_redirected_to root_path
    assert_nil cookies[:write_access]
    assert_equal "Invalid or expired authentication token", flash[:alert]
  end

  test "signin without token redirects with error" do
    get signin_url

    assert_redirected_to root_path
    assert_nil cookies[:write_access]
    assert_equal "No authentication token provided", flash[:alert]
  end
end
