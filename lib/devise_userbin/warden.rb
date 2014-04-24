Warden::Manager.after_set_user :except => :fetch do |user, warden, opts|
  begin
    session = Userbin::Session.post("/api/v1/users/#{user.userbin_id}/sessions")
  rescue Userbin::Error
    # ...
  end

  warden.session(opts[:scope])['_ubt'] = session.id
end

Warden::Manager.before_logout do |user, warden, opts|
  session_id = warden.session(opts[:scope])['_ubt']
  Userbin::Session.destroy_existing(session_id)
end

Warden::Manager.after_set_user :only => :fetch do |user, warden, opts|
  session_id = warden.session(opts[:scope])['_ubt']
end
