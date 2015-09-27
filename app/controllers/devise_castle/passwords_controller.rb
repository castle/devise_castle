class DeviseCastle::PasswordsController < Devise::PasswordsController
  unloadable unless Rails.version =~/^4/

  def create
    key = resource_params.keys.first

    username = if Devise.reset_password_keys.include?(key.to_sym)
      resource_params.values.first
    end

    super do |resource|
      castle.track(
        name: '$password_reset.requested',
        details: {
          '$login' => username
        })
    end
  end

  def update
    super do |resource|
      if resource.errors.empty?
        castle.track(
          name: '$password_reset.succeeded',
          user_id: resource._castle_id)
      else
        castle.track(
          name: '$password_reset.failed',
          user_id: resource._castle_id)
      end
    end
  end
end
