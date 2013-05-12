Autoroku
========

This is a series of experiments based off the [json definition for the Heroku API](https://github.com/heroku/api/blob/master/docs/v3/doc.json).

Spec
----

The base for all experiments is Autoroku::Spec, some sort of AST for the API:

```ruby
spec = Autoroku::Spec.new("/path/to/doc.json")

# the spec has multiple resources:
res = spec.resources.first
puts res.name

# each one with different actions:
action = res.actions.first
puts action.name
puts action.path
puts action.method

# actions have attributes:
puts action.attributes.map(&:name)
puts action.attributes.map(&:required?)
```

Lib
---

This is an API client library defined in `Autoroku::Lib`:

```ruby
api = Autoroku::Lib.new(:api_key => "...")
api.account_update(allow_tracking: false)
```

It's generated on the fly based on the API definition:

```ruby
api = Autoroku::Lib.new(:api_key => "...", :api_spec => "/path/to/doc.json")
```

Cli
---

This is a quick hack trying to implement a client:

```
$ autoroku help
Usage: autoroku [command]
  account:info
  account:update
  apps:create
  apps:delete
  apps:info
...

$ autoroku account:info
allow_tracking: true
api_key: 12345
beta: true
confirmed: true
...
```

Builder
-------

Perhaps more importantly, this will use the Spec to write a full Heroku API client based off [Heroku.rb](https://github.com/heroku/heroku.rb):

```
$ ./bin/build
Built gem in ./build/heroku-api-v3-0.0.1.gem
```

The generated client contains a readme, Gemfile, gemspec, and all other files required to install it. You can then install the gem and release it:

```
$ gem install build/heroku-api-v3-0.0.1.gem
Successfully installed heroku-api-v3-0.0.1
1 gem installed
Installing ri documentation for heroku-api-v3-0.0.1...
Installing RDoc documentation for heroku-api-v3-0.0.1...
```
