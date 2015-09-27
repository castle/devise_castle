class DeviseCastle::RegistrationsController < Devise::RegistrationsController
  unloadable unless Rails.version =~/^4/

  def create
    super do |resource|
      if resource.persisted?
        castle.track(
          name: '$registration.succeeded',
          user_id: resource._castle_id)
      else
        castle.track(
          name: '$registration.failed')
      end
    end
  end
  end
end
