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
    render_readme
  end

  def render_readme
    template = File.read("template/README.md.erb")
    readme = Erubis::Eruby.new(template)
    File.open("build/README.md", "w") do |file|
      file.puts readme.result(spec: spec)
    end
  end
end
