require "netrc"

class Autoroku::CLI
  def self.start(*args)
    new.run(args)
  end

  def initialize
    @key = fetch_api_key
    @api = Autoroku.new(:api_key => @key)
  end

  def fetch_api_key
    netrc["api.heroku.com"][1]
  end

  def run(*args)
    cmd = args.first.first
    method = cmd.gsub(":", "_")
    if @api.respond_to?(method)
      response = @api.send(method)

      if response.is_a?(Array)
        response.each do |element|
          render(element)
        end
      else
        render(response)
      end
    end
  end

  def render(element)
    element.keys.sort.each do |key|
      display "#{key}: #{element[key]}"
    end
  end


  def display(line)
    puts line
  end

  def netrc_path
    default = Netrc.default_path
    encrypted = default + ".gpg"
    if File.exists?(encrypted)
      encrypted
    else
      default
    end
  end

  def netrc   # :nodoc:
    @netrc ||= begin
      File.exists?(netrc_path) && Netrc.read(netrc_path)
    rescue => error
      if error.message =~ /^Permission bits for/
        perm = File.stat(netrc_path).mode & 0777
        abort("Permissions #{perm} for '#{netrc_path}' are too open. You should run `chmod 0600 #{netrc_path}` so that your credentials are NOT accessible by others.")
      else
        raise error
      end
    end
  end


end
