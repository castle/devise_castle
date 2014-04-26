# After login
#
Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  begin
    session = Userbin::Session.post(
      "/api/v1/users/#{record.userbin_id}/sessions")
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
  session_id = warden.session(opts[:scope]).delete('_ubt')
  begin
    Userbin::Session.destroy_existing(session_id)
  rescue Userbin::Error; end
end

# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  session_id = warden.session(opts[:scope])['_ubt']
  begin
    if Userbin::JWT.new(session_id).expired?
      session = Userbin::Session.new(id: session_id).refresh
      warden.session(opts[:scope])['_ubt'] = session.id
    end
  rescue Userbin::SecurityError => error
    # TODO: Tampered or non-existing Userbin session. Log out
  rescue Userbin::Error; end
end
