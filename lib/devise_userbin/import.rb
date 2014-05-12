module DeviseUserbin
  class ImportError < Exception; end

  class Import
    attr_reader :resource_class, :batch_size

    def initialize(options = {})
      begin
        @resource_class = eval(options[:resource_class])
      rescue NameError
        raise ImportError, "No such class: #{options[:resource_class]}"
      end

      unless supported_orm?
        raise ImportError, "Only ActiveRecord and Mongoid models are supported"
      end

      unless Userbin.config.api_secret.present?
        raise ImportError, "Please add an Userbin API secret to your devise.rb"
      end

      @batch_size = [(options[:batch_size] || 100), 100].min
    end

    def self.run(*args)
      new(*args).run
    end

    def run
      batches do |batch, resources|
        begin
          users = Userbin::User.import(users: batch)
        rescue Userbin::Error => error
          raise ImportError, error.message
        end

        users.zip(resources).each do |user, resource|
          resource.userbin_id = user.id
          resource.save(validate: false)
        end
      end
    end

    def batches
      if active_record?
        resource_class.where("userbin_id IS NULL").find_in_batches(:batch_size => batch_size) do |resources|
          resources_for_wire = map_resources_to_userbin_format(resources)
          yield(resources_for_wire, resources) unless resources.count.zero?
        end
      elsif mongoid?
        0.step(resource_class.where(:userbin_id => nil).count, batch_size) do |offset|
          resources_for_wire = map_resources_to_userbin_format(resource_class.limit(batch_size).skip(offset))
          yield(resources_for_wire, resources) unless resources.count.zero?
        end
      end
    end

    def map_resources_to_userbin_format(resources)
      resources.map do |resource|
        format = {}
        format[:email] = resource.email unless resource.email.blank?
        format[:id] = resource._userbin_id
        format[:created_at] = resource.created_at if resource.respond_to? :created_at
        format
      end.compact
    end

    def prepare_batch(batch)
      { :users => batch }.to_json
    end

    def active_record?
      (defined?(ActiveRecord::Base) && (resource_class < ActiveRecord::Base))
    end

    def mongoid?
      (defined?(Mongoid::Document) && (resource_class < Mongoid::Document))
    end

    def supported_orm?
      active_record? || mongoid?
    end

  end
end
