Warden::Manager.on_request do |warden|
  warden.request.env['userbin'] = Userbin::Client.new(warden.request)
end

Warden::Manager.after_authentication do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    warden.request.env['userbin'].login(
      record._userbin_id, email: record.email)
  end
end

Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    warden.request.env['userbin'].logout
  end
end

Warden::Manager.after_set_user do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    controller = warden.env['action_dispatch.request.parameters']['controller']
    unless controller == 'devise/two_factor_authentication'
      warden.request.env['userbin'].authorize!
    end
  end
end
