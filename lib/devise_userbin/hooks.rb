# After login
#
Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  begin
    session = Userbin.with_context(warden.env) do
      Userbin::Session.post("/api/v1/users/#{record.userbin_id}/sessions")
    end
    warden.session(opts[:scope])['_ubt'] = session.id
  rescue Userbin::ChallengeException => error
    warden.session(opts[:scope])['_ubc'] = error.challenge.id
  rescue Userbin::Error
    # TODO: Proceed silently or report to browser?
  end
end

# Before logout
#
Warden::Manager.before_logout do |record, warden, opts|
  begin
    if session_id = warden.session(opts[:scope]).delete('_ubt')
      Userbin.with_context(warden.env) do
        Userbin::Session.destroy_existing(session_id)
      end
    end
  rescue Userbin::Error; end
end

# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  scope = opts[:scope]
  session_id = warden.session(scope)['_ubt']

  if session_id
    begin
      if Userbin::JWT.new(session_id).expired?
        session = Userbin.with_context(warden.env) do
          Userbin::Session.new(id: session_id).refresh
        end
        warden.session(scope)['_ubt'] = session.id
      end
    rescue Userbin::Error
      warden.session(scope).delete('_ubt')
      warden.session(scope).delete('_ubc')
      warden.logout(scope)
      throw :warden, :scope => scope, :message => :timeout
    end
  end
end
