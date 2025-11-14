class AuthController < ApplicationController
  def signin
    token = params[:token]

    if token.blank?
      redirect_to root_path, alert: "No authentication token provided"
      return
    end

    auth_token = AuthToken.find_by(token: token)

    if auth_token
      auth_token.destroy
      cookies.permanent[:write_access] = {
        value: "granted",
        httponly: true,
        secure: Rails.env.production?
      }
      redirect_to root_path, notice: "Successfully authenticated! You now have write access."
    else
      redirect_to root_path, alert: "Invalid or expired authentication token"
    end
  end
end
