require "base64"
require "excon"
require "yajl"

class Autoroku
  VERSION = "0.0.1"
  HEADERS = {
    'Accept'                => 'application/vnd.heroku; version=3',
    'User-Agent'            => "autoroku/#{VERSION}",
    'X-Ruby-Version'        => RUBY_VERSION,
    'X-Ruby-Platform'       => RUBY_PLATFORM
  }

  def initialize(options={})
    @api_key = options.delete(:api_key) || ENV['HEROKU_API_KEY']
    user_pass = ":#{@api_key}"
    options[:headers] = HEADERS.merge({
      'Authorization' => "Basic #{Base64.encode64(user_pass).gsub("\n", '')}",
    })

    url = options[:url] || "https://api.heroku.com"
    @connection = Excon.new(url, options)
    parse_api_spec!(options[:api_spec] || "lib/api.json")
  end

  def parse_api_spec!(path)
    raw  = File.read(path)
    spec = Yajl::Parser.parse(raw)

    spec["resources"].each do |resource, resource_spec|
      resource_spec["actions"].each do |action, action_spec|
        method_name = "#{resource}_#{action}".downcase
        define_singleton_method(method_name) do |*args|
          options          = args.first || {}
          accepted_options = (action_spec["attributes"] || {}).values.flatten
          unknown_options  = options.keys.map(&:to_sym) - accepted_options.map(&:to_sym)

          unless unknown_options.empty?
            raise ArgumentError, "Unexpected options: #{unknown_options.inspect}"
          end

          @connection.request(
            method:  action_spec["method"],
            path:    action_spec["path"],
            expects: action_spec["status"].to_i,
            query:   options)
        end
      end
    end
  end

end
