module WriteAuthorization
  extend ActiveSupport::Concern

  private

  def require_write_access
    unless has_write_access?
      redirect_to root_path, alert: "Write access required. Please authenticate to perform this action."
    end
  end

  def has_write_access?
    cookies[:write_access] == "granted"
  end
end
