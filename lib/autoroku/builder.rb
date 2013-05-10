require "fileutils"

class Autoroku::Builder
  attr_accessor :spec

  def initialize(spec)
    spec = spec
  end

  def run
    FileUtils.mkdir_p 'build'
  end
end
