class DeviseCastle::PasswordsController < Devise::PasswordsController
  unloadable unless Rails.version =~/^4/

  def create
    key = resource_params.keys.first

    username = if Devise.reset_password_keys.include?(key.to_sym)
      resource_params.values.first
    end

    super do |resource|
      unless resource.respond_to?(:castle_do_not_track?) && resource.castle_do_not_track?
        begin
          castle.track(
            name: '$password_reset.requested',
            details: {
              '$login' => username
            })
        rescue ::Castle::Error => e
          if Devise.castle_error_handler.is_a?(Proc)
            Devise.castle_error_handler.call(e)
          end
        end
      end
    end
  end

  def update
    super do |resource|
      unless resource.respond_to?(:castle_do_not_track?) && resource.castle_do_not_track?
        begin
          if resource.errors.empty?
            castle.track(
              name: '$password_reset.succeeded',
              user_id: resource._castle_id)
          else
            castle.track(
              name: '$password_reset.failed',
              user_id: resource._castle_id)
          end
        rescue ::Castle::Error => e
          if Devise.castle_error_handler.is_a?(Proc)
            Devise.castle_error_handler.call(e)
          end
        end
      end
    end
  end
end
