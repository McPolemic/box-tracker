module WriteAuthorization
  extend ActiveSupport::Concern

  private

  def require_write_access
    unless write_access?
      head :unauthorized
    end
  end
end
