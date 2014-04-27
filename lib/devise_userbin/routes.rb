module ActionDispatch::Routing
  class Mapper
    protected

    def devise_userbin(mapping, controllers)
      resource :two_factor_authentication, :only => [:show, :update], :path => mapping.path_names[:two_factor_authentication], :controller => controllers[:two_factor_authentication]

      resource :two_factor_recovery, :only => [:show, :update], :path => mapping.path_names[:two_factor_recovery], :controller => controllers[:two_factor_recovery]
    end
  end
end
