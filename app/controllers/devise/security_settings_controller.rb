class Devise::SecuritySettingsController < DeviseController
  include Devise::Controllers::Helpers

  def show
    session_token = session["#{resource_name}_userbin"]
    redirect_to Userbin.security_settings_url(session_token)
  end
end
