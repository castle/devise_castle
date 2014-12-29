# Instantiate Userbin client on every request
Warden::Manager.on_request do |warden|
  warden.request.env['userbin'] =
    Userbin::Client.new(warden.request, warden.cookies)
end

# Track logout.succeeded
Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    userbin = warden.request.env['userbin']
    userbin.logout
    userbin.track(name: 'logout.succeeded')
  end
end

# Track login.failed
Warden::Manager.before_failure do |env, opts|
  if opts[:action] == 'unauthenticated'
    userbin = env['userbin']
    userbin.track(name: 'login.failed')
  end
end

# Track login.succeeded
Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    userbin = warden.request.env['userbin']
    userbin.track(user_id: record._userbin_id, name: 'login.succeeded')
    userbin.login(record._userbin_id, email: record.email)
  end
end

# Continous authentication
Warden::Manager.after_set_user do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    env = warden.request.env
    userbin = env['userbin']
    userbin.authorize! unless env['userbin.skip_authorization']
  end
end
