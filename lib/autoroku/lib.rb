class Autoroku::Lib
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
    @spec = options[:api_spec] || Autoroku::Spec.new("lib/api.json")
    build!
  end

  protected

  def build!
    @spec.resources.each do |resource|
      resource.actions.each do |action|
        method_name = "#{resource.name}_#{action.name}".downcase
        define_singleton_method(method_name) do |*args|
          options          = args.first || {}
          accepted_options = action.attributes.map(&:name)
          unknown_options  = options.keys.map(&:to_sym) - accepted_options.map(&:to_sym)

          unless unknown_options.empty?
            raise ArgumentError, "Unexpected options: #{unknown_options.inspect}"
          end

          response = @connection.request(
            method:  action.method,
            path:    action.path,
            expects: action.statuses,
            query:   options)

          Yajl::Parser.parse(response.body)
        end
      end
    end
  end
end