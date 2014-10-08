module ActionDispatch::Routing
  class Mapper
    protected

    def devise_userbin(mapping, controllers)
      resources :two_factor_authentication, :only => [:new, :show, :update, :edit], :path => mapping.path_names[:two_factor_authentication], :controller => controllers[:two_factor_authentication]

      resource :security_settings, :only => [:show], :path => mapping.path_names[:security_settings], :controller => controllers[:security_settings]
    end
  end
end
