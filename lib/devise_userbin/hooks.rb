Warden::Manager.on_request do |warden|
  warden.request.env['userbin'] = Userbin::Client.new(warden.request)
end

# Everytime current_<scope> is prepared
#
Warden::Manager.after_set_user :only => :fetch do |record, warden, opts|
  if record.respond_to?(:_userbin_id)
    begin
      userbin = warden.request.env['userbin']
      userbin.authorize!(record._userbin_id, { email: record.email })
    rescue Userbin::Error
      warden.logout(opts[:scope])
      throw :warden, :scope => opts[:scope], :message => :timeout
    end
  end
end

Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:userbin_id)
    begin
      userbin = warden.request.env['userbin']
      userbin.logout
    rescue Userbin::Error; end
  end
end
