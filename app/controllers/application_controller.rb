class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :write_access?

  private

  def write_access?
    cookies[:write_access] == "granted"
  end
end
