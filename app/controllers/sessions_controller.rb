class SessionsController < Clearance::SessionsController
  def redirect_url
    '/timer'
  end
end
