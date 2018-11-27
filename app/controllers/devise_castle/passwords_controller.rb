class DeviseCastle::PasswordsController < Devise::PasswordsController
  def create
    user_traits = Devise.reset_password_keys.each_with_object({}) do |key, acc|
      acc[key] = resource_params[key] if resource_params.key?(key)
    end

    super do |resource|
      unless resource.respond_to?(:castle_do_not_track?) && resource.castle_do_not_track?
        begin
          castle.track(
            event: '$password_reset.requested',
            user_traits: user_traits
          )
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
              event: '$password_reset.succeeded',
              user_id: resource._castle_id
            )
          else
            castle.track(
              event: '$password_reset.failed',
              user_id: resource._castle_id
            )
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
