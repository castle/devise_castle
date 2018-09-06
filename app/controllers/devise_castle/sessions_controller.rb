class DeviseCastle::SessionsController < Devise::SessionsController

  protected

  def auth_options
    # find the auth params
    user_traits = sign_in_params.slice(*resource_class.authentication_keys)
    # there should be one key related to auth
    key = user_traits.keys.first

    # find the user if any
    user = resource_class.find_for_authentication(key => sign_in_params[key])

    # make it available to Warden hooks
    super.merge(user_traits: user_traits, user: user)
  end
end
