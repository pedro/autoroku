require "erubis"
require "fileutils"

class Autoroku::Builder
  attr_accessor :spec

  def initialize(spec)
    @spec = spec
  end

  def run
    FileUtils.mkdir_p 'build'
    FileUtils.mkdir_p 'build/lib/heroku/api'
    create_readme
    create_gemfile
  end

  def create_readme
    template = File.read("template/README.md.erb")
    readme = Erubis::Eruby.new(template)
    File.open("build/README.md", "w") do |file|
      file.puts readme.result(spec: spec)
    end
  end

  def create_gemfile
    FileUtils.copy("template/Gemfile", "build/Gemfile")
  end
end
