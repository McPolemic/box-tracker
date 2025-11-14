require "test_helper"

class AuthTokenTest < ActiveSupport::TestCase
  test "generate creates a new auth token with random token" do
    auth_token = AuthToken.generate
    assert auth_token.persisted?
    assert_not_nil auth_token.token
    assert auth_token.token.length > 20
  end

  test "token must be unique" do
    token = "unique_token_123"
    AuthToken.create!(token: token)
    duplicate = AuthToken.new(token: token)
    assert_not duplicate.valid?
  end

  test "signin_url returns properly formatted URL" do
    auth_token = AuthToken.create!(token: "test_token_123")
    url = auth_token.signin_url
    assert_includes url, "/signin"
    assert_includes url, "token=test_token_123"
    assert_includes url, "http://localhost:3000"
  end
end
