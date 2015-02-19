# Instantiate Castle client on every request
Warden::Manager.on_request do |warden|
  warden.request.env['castle'] =
    Castle::Client.new(warden.request, warden.cookies)
end

# Track logout.succeeded
Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:castle_id)
    castle = warden.request.env['castle']
    castle.logout
    castle.track(user_id: record._castle_id, name: '$logout.succeeded')
  end
end

# Track login.failed
Warden::Manager.before_failure do |env, opts|
  if opts[:action] == 'unauthenticated' && opts[:username]

    user_id = if opts[:user].respond_to?(:castle_id)
      opts[:user]._castle_id
    end

    castle = env['castle']
    castle.track(
      name: '$login.failed',
      user_id: user_id,
      details: {
        '$login' => opts[:username]
      })
  end
end

# Track login.succeeded
Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  if record.respond_to?(:castle_id)
    castle = warden.request.env['castle']
    castle.track(user_id: record._castle_id, name: '$login.succeeded')
    castle.login(record._castle_id, email: record.email)
  end
end

# Continous authentication
Warden::Manager.after_set_user do |record, warden, opts|
  if record.respond_to?(:castle_id)
    env = warden.request.env
    castle = env['castle']
    castle.authorize! unless env['castle.skip_authorization']
  end
end
