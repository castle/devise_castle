class Devise::DeviseUserbinController < DeviseController
  include Devise::Controllers::Helpers

  before_filter :return_not_found, except: :new

  def new
    challenge = env['userbin'].challenges.create
    redirect_to edit_user_two_factor_authentication_path(challenge.id) # todo:
  end

  def edit
    @challenge = env['userbin'].challenges.find(params[:id])

    # Prevent "undefined method `errors' for nil:NilClass"
    self.resource = resource_class.new
  end

  def update
    challenge_id = params.require(:challenge_id)
    code = params.require(:code)

    begin
      env['userbin'].challenges.verify(challenge_id, response: code)

      Devise.mappings.keys.flatten.any? do |scope|
        redirect_to after_sign_in_path_for(scope)
      end
    rescue Userbin::Error => error
      sign_out_with_message(:no_retries_remaining, :alert)
    end
  end

  protected

  def sign_out_with_message(message, kind = :notice)
    signed_out = sign_out(resource_name)
    set_flash_message kind, message if signed_out
    redirect_to after_sign_out_path_for(resource_name)
  end

  private

  def return_not_found
    unless env['userbin'].mfa_in_progress?
      redirect_to after_sign_in_path_for(resource_name)
    end
  end

end
