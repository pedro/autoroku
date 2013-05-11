class Autoroku::Spec
  attr_accessor :api, :resources

  def initialize(api)
    @api = read_api_spec(api)
    @resources = []
    parse!
  end

  def read_api_spec(api)
    return api if api.is_a?(Hash)
    Yajl::Parser.parse(File.read(api))
  end

  def parse!
    @api["resources"].each do |resource, resource_spec|
      @resources << parse_resource(resource, resource_spec)
    end
  end

  def parse_resource(name, spec)
    Resource.new(name: name).tap do |resource|
      spec["actions"].each do |action, action_spec|
        attrs = action_spec["attributes"] || {}
        attrs_required = (attrs["required"] || [])
        attrs_optional = (attrs["optional"] || [])

        attributes = attrs_required.map { |a| Attribute.new(a, true) } +
          attrs_optional.map { |a| Attribute.new(a, false) }

        resource.actions << Action.new(
          resource:   resource,
          name:       action,
          method:     action_spec["method"],
          path:       action_spec["path"],
          status:     action_spec["status"].to_i,
          attributes: attributes)
      end
    end
  end

  class Resource
    attr_accessor :name, :actions

    def initialize(options)
      @name    = options[:name]
      @actions = options[:actions] || []
    end

    def system_name
      @name.downcase.gsub(" ", "_")
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

    def system_name
      @name.downcase.gsub(" ", "_")
    end

    def method_name
      "#{resource.system_name}_#{system_name}"
    end
  end

  class Attribute
    attr_accessor :name, :required
    def initialize(name, required)
      @name = name
      @required = required
    end
  end
end