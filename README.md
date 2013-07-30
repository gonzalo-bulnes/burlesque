Action  | Resource | Description
:-------|:---------|:-----------
Read    | User     | Puede ver lista y detalle de un Usuario
Create  | User     | Puede crear un nuevo Usuario (:new, :create)
Update  | User     | Puede actualizar un Usuario (:edit, :update)
Destroy | User     | Puede eliminar un Usuario

Burlesque
=========

Crea estructura de roles y grupos para cualquier modelo, considera además las 3 tablas de _join_ que pudiesen darse.

Installation
------------

Before you can use the generator, add the gem to your project's Gemfile as follows:

```
gem 'burlesque'
```

Then install it by running:

```
bundle install
```

After, bootstrap your Rails app, for example:

```
rake burlesque:install:migrations
rake db:migrate
```

If you would like to run migrations only from Burlesque engine, you can do it by specifying SCOPE:

```
rake db:migrate SCOPE=burlesque
```

Finally, in model that you need burlesque:

```
include Burlesque::Admin
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

Todo
----

Rake task for burlesque admin module inclusion.
