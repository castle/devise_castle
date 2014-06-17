class Devise::SecuritySettingsController < DeviseController
  include Devise::Controllers::Helpers

  def show
    redirect_to env['userbin'].security_settings_url
  end
end
