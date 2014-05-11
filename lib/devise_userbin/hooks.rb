Warden::Manager.before_logout do |record, warden, opts|
  begin
    Userbin.deauthenticate(warden.request.session["#{opts[:scope]}_userbin"])
  rescue Userbin::Error; end
end
