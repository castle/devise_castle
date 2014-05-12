# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  scope = opts[:scope]

  begin
    session_token = warden.request.session["#{scope}_userbin"]

    session_token =
      Userbin.authenticate(session_token, record.id, {
        properties: {
          email: record.email
        },
        context: {
          ip: warden.request.ip,
          user_agent: warden.request.user_agent
        }
      })

    warden.request.session["#{scope}_userbin"] = session_token

  rescue Userbin::Error => error
    warden.logout(scope)
    throw :warden, :scope => scope, :message => :timeout
  end

end

Warden::Manager.before_logout do |record, warden, opts|
  begin
    session_token = warden.request.session.delete("#{opts[:scope]}_userbin")
    Userbin.deauthenticate(session_token)
  rescue Userbin::Error; end
end
