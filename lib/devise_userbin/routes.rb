module ActionDispatch::Routing
  class Mapper
    protected

    def devise_userbin(mapping, controllers)
      resource :userbin, :only => [:show, :update], :path => mapping.path_names[:userbin], :controller => controllers[:devise_userbin]
    end
  end
end
