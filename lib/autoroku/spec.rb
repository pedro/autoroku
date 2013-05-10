class Autoroku::Spec
  attr_accessor :api, :resources

  def initialize(api)
    @api = api
    @resources = []
    parse!
  end

  def parse!
    @api["resources"].each do |resource, resource_spec|
      @resources << parse_resource(resource, resource_spec)
    end
  end

  def parse_resource(name, spec)
    Resource.new(name: name).tap do |resource|
      spec["actions"].each do |action, action_spec|
        resource.actions << Action.new(
          resource:   resource,
          name:       action,
          method:     action_spec["method"],
          path:       action_spec["path"],
          status:     action_spec["status"].to_i,
          attributes: (action_spec["attributes"] || {}).values.flatten)
      end
    end
  end

  class Resource
    attr_accessor :name, :actions

    def initialize(options)
      @name    = options[:name]
      @actions = options[:actions] || []
    end
  end

  class Action
    attr_accessor :resource, :name, :method, :path, :status, :attributes

    def initialize(options)
      @resource = options[:resource]
      @name     = options[:name]
      @method   = options[:method]
      @path     = options[:path]
      @status   = options[:status]
      @attributes = options[:attributes]
    end
  end
end