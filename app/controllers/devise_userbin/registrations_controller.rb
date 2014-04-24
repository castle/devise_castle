class DeviseUserbin::RegistrationsController < Devise::RegistrationsController
  unloadable unless Rails.version =~/^4/
end
