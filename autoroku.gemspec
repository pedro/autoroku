# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "autoroku"
  s.version     = "0.0.1"
  s.authors     = ["Pedro Belo"]
  s.email       = ["pedro@heroku.com"]
  s.homepage    = "http://github.com/heroku/autoroku"
  s.summary     = %q{Ruby Client for the Heroku API}
  s.description = %q{Ruby Client for the Heroku API}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'erubis', '~>2.7.0'
  s.add_runtime_dependency 'excon', '~>0.20.0'
  s.add_runtime_dependency 'yajl-ruby', '~>1.1.0'
  s.add_runtime_dependency 'netrc', '~>0.7.7'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'webmock'
end
