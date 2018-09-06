# Instantiate Castle client on every request
Warden::Manager.on_request do |warden|
  warden.request.env['castle'] = Castle::Client.from_request(warden.request)
end

# Track logout.succeeded
Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:castle_id)
    unless record.respond_to?(:castle_do_not_track?) && record.castle_do_not_track?
      castle = warden.request.env['castle']
      begin
        castle.track(user_id: record._castle_id, event: '$logout.succeeded')
      rescue ::Castle::Error => e
        if Devise.castle_error_handler.is_a?(Proc)
          Devise.castle_error_handler.call(e)
        end
      end
    end
  end
end

# Track login.failed
Warden::Manager.before_failure do |env, opts|
  if opts[:action] == 'unauthenticated' && opts[:user_traits]

    user_id = if opts[:user].respond_to?(:castle_id)
      opts[:user]._castle_id
    end

    castle = env['castle']
    begin
      castle.track(
        event: '$login.failed',
        user_id: user_id,
        user_traits: opts[:user_traits]
      )
    rescue ::Castle::Error => e
      if Devise.castle_error_handler.is_a?(Proc)
        Devise.castle_error_handler.call(e)
      end
    end
  end
end

# Track login.succeeded
Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  if record.respond_to?(:castle_id)
    unless record.respond_to?(:castle_do_not_track?) && record.castle_do_not_track?
      castle = warden.request.env['castle']
      begin
        castle.authenticate(user_id: record._castle_id, event: '$login.succeeded')
      rescue ::Castle::Error => e
        if Devise.castle_error_handler.is_a?(Proc)
          Devise.castle_error_handler.call(e)
        end
      end
    end
  end
end
