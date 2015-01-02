class DeviseUserbin::SessionsController < Devise::SessionsController
  unloadable unless Rails.version =~/^4/

  protected

  def auth_options
    key = serialize_options(resource)[:methods].first
    username = sign_in_params[key]

    super.merge(username: username)
  end
end
