class Devise::DeviseUserbinController < DeviseController
  include Devise::Controllers::Helpers

  before_filter do
    # This controller should only be reachable when two-factor is in progress
    unless env['userbin'].two_factor_in_progress?
      redirect_to after_sign_in_path_for(resource_name)
    end
  end

  def show
    self.resource = resource_class.new
  end

  def update
    render :show and return if params[:code].nil?

    Devise.mappings.keys.flatten.any? do |scope|
      begin
        env['userbin'].two_factor_verify(params[:code])

        set_flash_message :notice, :success
        redirect_to after_sign_in_path_for(scope)
      rescue Userbin::UserUnauthorizedError => error
        set_flash_message :alert, :failed
        self.resource = resource_class.new
        respond_with_navigational(resource_name) { render :show }
      rescue Userbin::ForbiddenError => error
        sign_out_with_message(:no_retries_remaining, :alert)
      rescue Userbin::Error => error
        sign_out_with_message(:error, :alert)
      end
    end
  end

  protected

  def sign_out_with_message(message, kind = :notice)
    signed_out = sign_out(resource_name)
    set_flash_message kind, message if signed_out
    redirect_to after_sign_out_path_for(resource_name)
  end

end
