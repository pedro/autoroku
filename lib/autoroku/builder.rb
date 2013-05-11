require "erubis"
require "fileutils"

class Autoroku::Builder
  attr_accessor :spec, :gem_name, :gem_version

  def initialize(options)
    @spec        = options[:spec]
    @gem_name    = options[:name] || "heroku-api-v3"
    @gem_version = options[:version] || "0.0.1"
  end

  def run
    FileUtils.rm_rf 'build'
    FileUtils.mkdir_p 'build/lib/heroku/api'
    create_readme
    create_gemfile
    create_gemspec
    create_heroku_api_dot_rb
    create_api_dot_rb
  end

  def create_readme
    render_template("README.md.erb", "README.md")
  end

  def create_gemfile
    FileUtils.copy("template/Gemfile", "build/Gemfile")
  end

  def create_gemspec
    render_template("gemspec.txt.erb", "#{gem_name}.gemspec")
  end

  def create_heroku_api_dot_rb
    FileUtils.copy("template/heroku-api.rb", "build/lib/#{gem_name}.rb")
  end

  def create_api_dot_rb
    render_template("api.txt.erb", "lib/heroku/api.rb")
  end

  def render_template(template_path, destination_path, extra_vars={})
    contents = File.read("template/#{template_path}")
    template = Erubis::Eruby.new(contents)
    File.open("build/#{destination_path}", "w") do |file|
      file.puts template.result(erb_variables.merge(extra_vars))
    end
  end

  def erb_variables
    { spec: spec, gem_name: gem_name, gem_version: gem_version }
  end
end
