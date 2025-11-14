class AuthToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true

  def self.generate
    token = SecureRandom.urlsafe_base64(32)
    create!(token: token)
  end

  def signin_url
    url_options = {
      token: token,
      host: Rails.application.config.action_mailer.default_url_options[:host] || "localhost",
      protocol: Rails.env.production? ? "https" : "http"
    }
    url_options[:port] = 3000 unless Rails.env.production?
    Rails.application.routes.url_helpers.signin_url(**url_options)
  end
end
