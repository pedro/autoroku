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
    FileUtils.mkdir_p 'build'
    FileUtils.mkdir_p 'build/lib/heroku/api'
    create_readme
    create_gemfile
    create_gemspec
  end

  def create_readme
    template = File.read("template/README.md.erb")
    readme = Erubis::Eruby.new(template)
    File.open("build/README.md", "w") do |file|
      file.puts readme.result(erb_variables)
    end
  end

  def create_gemfile
    FileUtils.copy("template/Gemfile", "build/Gemfile")
  end

  def create_gemspec
    template = File.read("template/gemspec.txt.erb")
    gemspec = Erubis::Eruby.new(template)
    File.open("build/#{gem_name}.gemspec", "w") do |file|
      file.puts gemspec.result(erb_variables)
    end
  end

  def erb_variables
    { spec: spec, gem_name: gem_name, gem_version: gem_version }
  end
end
