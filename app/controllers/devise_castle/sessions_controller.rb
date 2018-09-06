class DeviseCastle::SessionsController < Devise::SessionsController

  protected

  def auth_options
    # find the username
    key = serialize_options(resource)[:methods].first
    username = sign_in_params[key]

    # find the user if any
    user = resource_class.find_for_authentication(key => username)

    # make it available to Warden hooks
    super.merge(username: username, user: user)
  end
end
