# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  scope = opts[:scope]

  begin
    warden.session(scope)['_ubt'] =
      Userbin.authenticate(warden.session(scope)['_ubt'], record.id, {
        properties: {
          email: record.email
        },
        context: {
          ip: warden.request.ip,
          user_agent: warden.request.user_agent
        }
      })
  rescue Userbin::Error => error
    warden.session(scope).delete('_ubt')
    warden.logout(scope)
    throw :warden, :scope => scope, :message => :timeout
  end
end

# Before logout
#
Warden::Manager.before_logout do |record, warden, opts|
  begin
    Userbin.deauthenticate(warden.session(opts[:scope]).delete('_ubt'))
  rescue Userbin::Error; end
end

