Warden::Manager.on_request do |warden|
  warden.request.env['userbin'] = Userbin::Client.new(warden.request)
end

Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    begin
      userbin = warden.request.env['userbin']
      userbin.logout
    rescue Userbin::Error; end
  end
end
