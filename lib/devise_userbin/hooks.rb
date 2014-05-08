Warden::Manager.before_logout do |record, warden, opts|
  begin
    Userbin.deauthenticate(warden.session(opts[:scope]).delete('_ubt'))
  rescue Userbin::Error; end
end
