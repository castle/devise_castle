module ActionDispatch::Routing
  class Mapper
    protected

    def devise_userbin(mapping, controllers)
      resources :two_factor_authentication, :only => [:new, :show, :update, :edit], :path => mapping.path_names[:two_factor_authentication], :controller => controllers[:two_factor_authentication]
    end
  end
end
