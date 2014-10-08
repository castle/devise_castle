require 'generators/devise/views_generator'

module DeviseUserbin
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copies all DeviseUserbin views to your application.'

      argument :scope, :required => false, :default => nil,
                       :desc => "The scope to copy views to"

      include ::Devise::Generators::ViewPathTemplates
      source_root File.expand_path("../../../../app/views/devise", __FILE__)
      def copy_views
        view_directory :two_factor_authentication
      end
    end
  end
end
