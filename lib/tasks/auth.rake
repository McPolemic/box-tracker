namespace :auth do
  desc "Generate a one-time signin URL"
  task generate_signin_url: :environment do
    auth_token = AuthToken.generate
    puts "\nGenerated signin URL:"
    puts auth_token.signin_url
    puts "\nThis URL can be used once to authenticate for write access."
  end
end
