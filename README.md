Burlesque
=========

Crea estructura de roles y grupos para cualquier modelo, considera además las 3 tablas de _join_ que pudiesen darse.

Installation
------------

Before you can use the generator, add the gem to your project's Gemfile as follows:

```
gem 'burlesque', :git => 'https://github.com/gonzalo-bulnes/burlesque.git'
```

Then install it by running:

```
bundle install
```

Finally, bootstrap your Rails app, for example:

```
rails generate burlesque:install
rake db:migrate
```

CanCan
------

Burlesque makes no assumption about how auhtorizations are handled in your application. However it integrates nicely with [CanCan][cancan]; all you have to do is define the `Ability` model as follows:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.roles.each do |role|
        action = role.action_sym
        model  = role.resource_class
        can action, model
      end
    end
  end
end
```

  [cancan]: https://github.com/ryanb/cancan
