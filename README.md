Autoroku
========

This is a series of experiments based off the [json definition of the Heroku API](https://gist.github.com/geemus/5623304).

Spec
----

The base for all experiments is `Autoroku::Spec`, some sort of AST for the API:

```ruby
spec = Autoroku::Spec.new("/path/to/doc.json")

# the spec has multiple resources:
res = spec.resources.first
res.name # => "Account"

# each one with different actions:
action = res.actions.last
action.name # => "Update"
action.path # => "/account"
action.method # => "PATCH"

# actions have attributes:
action.attributes.map(&:name) # => ["allow_tracking", "beta", "email"] 
action.attributes.map(&:required?) # => [false, false, false]

# and path ids:
action.path_ids # => ["app_id_or_name"]
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
spec = Autoroku::Spec.new("/path/to/doc.json")
api = Autoroku::Lib.new(:api_key => "...", :api_spec => spec)
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

The generated client contains a readme, Gemfile, gemspec, and all other files required to install it:

```
$ gem install build/heroku-api-v3-0.0.1.gem
Successfully installed heroku-api-v3-0.0.1
1 gem installed
Installing ri documentation for heroku-api-v3-0.0.1...
Installing RDoc documentation for heroku-api-v3-0.0.1...
```

You can then test it like:

```
$ irb -r rubygems -r heroku-api-v3
1.9.3p125 :001 > api = Heroku::API.new(api_key: "12345")
 => #<Heroku::API:0x007ff3f31e6e20> 
1.9.3p125 :002 > api.apps_info("blog").body
 => {"buildpack_provided_description"=>"Ruby/Rails", "created_at"=>"2012-03-09T00:40:51-00:00", "id"=>"c2b7a023-04b3-4bec-9bee-3774f3a6c29a", "git_url"=>"git@heroku.com:blog.git", "legacy_id"=>"app3188136@heroku.com", "maintenance"=>false, "name"=>"blog", "owner"=>{"email"=>"heroku@herokumanager.com", "id"=>"13048c51-de45-400f-96b8-e265f93d380f"}, "region"=>{"id"=>"59accabd-516d-4f0e-83e6-6e3757701145", "name"=>"us"}, "released_at"=>"2013-04-26T17:50:19-00:00", "repo_size"=>16715776, "slug_size"=>28573696, "stack"=>"cedar", "tier"=>"production", "updated_at"=>"2013-05-07T01:10:33-00:00", "web_url"=>"http://blog.herokuapp.com/"} 
```
