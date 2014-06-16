class Devise::SecuritySettingsController < DeviseController
  include Devise::Controllers::Helpers

  def show
    send("current_#{scope_name}") # initialize after_set_user in warden
    redirect_to env['userbin'].security_settings_url
  end
end
