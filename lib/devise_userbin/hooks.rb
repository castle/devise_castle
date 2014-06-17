Warden::Manager.on_request do |warden|
  warden.request.env['userbin'] = Userbin::Security.new(warden.request)
end

# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  begin
    userbin = warden.request.env['userbin']
    userbin.authorize!(record._userbin_id, { email: record.email })
  rescue Userbin::Error => error
    warden.logout(opts[:scope])
    throw :warden, :scope => opts[:scope], :message => :timeout
  end
end

Warden::Manager.before_logout do |record, warden, opts|
  begin
    userbin = warden.request.env['userbin']
    userbin.logout
  rescue Userbin::Error; end
end
