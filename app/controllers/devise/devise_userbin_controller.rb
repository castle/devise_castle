class Devise::DeviseUserbinController < DeviseController
  include Devise::Controllers::Helpers

  def show
  end

  def update
    render :show and return if params[:code].nil?

    Devise.mappings.keys.flatten.any? do |scope|
      challenge_id = warden.session(scope)['_ubc']

      begin
        session = Userbin::Session.post(
          "/api/v1/sessions", {
            challenge: { id: challenge_id, response: params[:code] } }
        )
        warden.session(scope).delete('_ubc')
        warden.session(scope)['_ubt'] = session.id

        redirect_to after_sign_in_path_for(scope)
      rescue Userbin::UserUnauthorizedError => error
        set_flash_message :notice, :failed if is_flashing_format?
        respond_with_navigational(resource_name) { render :show }
      rescue Userbin::Forbidden => error
        sign_out_with_message(:no_retries_remaining)
      rescue Userbin::Error => error
        sign_out_with_message(:signed_out)
      end
    end
  end

  protected

  def sign_out_with_message(message)
    warden.session(resource_name).delete('_ubc')
    signed_out = sign_out(resource_name)
    set_flash_message :notice, message if signed_out && is_flashing_format?
    redirect_to after_sign_out_path_for(resource_name)
  end

end
