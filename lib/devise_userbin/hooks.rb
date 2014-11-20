Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    warden.request.env['userbin'].logout
  end
end

Warden::Manager.after_set_user :except => :fetch do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    env = warden.request.env
    env['userbin'].login(record._userbin_id, email: record.email)
  end
end

Warden::Manager.after_set_user do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    env = warden.request.env
    env['userbin'].authorize! unless env['userbin.skip_authorization']
  end
end
