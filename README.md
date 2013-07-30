# Burlesque

Create roles and groups structures for any model, also creates the 3 _join_ tables.

## Installation

In order to use the generator, add the gem to your project's `Gemfile` as follows:

```ruby
gem 'burlesque'
```

Then install it by running:

```bash
bundle install
```

Then bootstrap your Rails app:

```bash
rake burlesque:install:migrations
rake db:migrate
```

Note that if you want to run **only** the Burlesque migrations, you can use the `SCOPE` option:

```bash
rake db:migrate SCOPE=burlesque
```

Finally, enable Burlesque in each model:

```ruby
class User < ActiveRecord::Base
  include Burlesque::Admin

  # ...
end
```

## Defining Role's

You can define/create all RESTful roles at once with:

```
Burlesque::Role.for 'user' # String, or
Burlesque::Role.for :user  # Symbol, or
Burlesque::Role.for User   # Constant
```

This will create the following authorizations:

Action  | Resource | Description
:-------|:---------|:-----------
Read    | User     | Can see list of all Users or single User details
Create  | User     | Can create a new User (:new, :create)
Update  | User     | Can Update a User (:edit, :update)
Destroy | User     | Can delete a User

## Defining Group's

Group names must be unique. The best way to define Burlesque groups is:

```
Burlesque::Group.find_or_create_by_name('Admin')
```

## Group's and Role's

To assign a list of `Burlesque::Role` identifiers to a `Burlesque::Group` just do:

```ruby
group = Burlesque::Group.find_by_name('Admin')
group.push_roles [role, another_role]  # role and antoher_role are instances of Burlesque::Role
```

The `push_roles` method ensures the roles are only added once to the group. If you want to assign the groups by yourself, please take care with that. Otherwise, Burlesque will raise an `ActiveRecord::RecordInvalid` exception.


## Utility functions

Assuming you enabled **Burlesque** in your model `User`:

### Questions

Ask for groups:

```ruby
user.group?(group)   # group is an instance of Burlesque::Group
user.group?('Admin') # it also works with groups names
```

Ask for roles:

```ruby
user.role?(role)         # role is an instance of Burlesque::Role
user.role?('all#manage') # again, it also works with names
```

Since an user may have `Burlesque::Role` without necessarily belonging to a `Burlesque::Group`, you may want to know if a given _role_ is provided by the belonging to a `Burlesque::Group`, or not.

```ruby
user.role_in_groups?(role)         # role is an instance of Burlesque::Role
user.role_in_groups?('all#manage')
```

### MassAssignment

To assign a list of groups to an user:

```ruby
ids = [1, 3, 4]  # groups identifiers
user.group_ids = (ids)
```

To assign a list of roles to an user:

```ruby
ids = [6, 7, 9]  # roles identifiers
user.role_ids = (ids)
```


### Search

You can search `Burlesque::Role` using defined SCOPE search and combine them any way you need.

Scope         | Description
:-------------|:-----------
action        | To search for `Burlesque::Role` that are associated with the same action.
not_action    | To search for `Burlesque::Role` that are not associated with the same action.
resource      | To search for `Burlesque::Role` that are linked to a resource in question.
not_resource  | To search for `Burlesque::Role` that are not linked to a resource in question.

Example:

```ruby
Burlesque::Role.action('read')   # String, or
Burlesque::Role.action(:read)    # Symbol

Burlesque::Role.resource('user') # String, or
Burlesque::Role.resource(:user)  # Symbol, or
Burlesque::Role.resource(User)   # Constant
```

# I18n

If you want to translate the roles names, you can use the `translate_name` method:

```ruby
role = Burlesque::Role.action(:read).resource(:user)
name = role.translate_name()  #  where role is an instance of Burlesque::Role to be translated
# => 'Read User'
```

The translation is handled by a YML file. If you only have RESTful actions, it may not be necessary to translate the roles by hand, as Burlesque will automagically use the model translations to compose human-friendly strings:


```ruby
Burlesque::Role.create(name: 'user#read'   ).translate_name()  ==>  Read User
Burlesque::Role.create(name: 'user#create' ).translate_name()  ==>  Create User
Burlesque::Role.create(name: 'user#update' ).translate_name()  ==>  Read User
Burlesque::Role.create(name: 'user#destroy').translate_name()  ==>  Destroy User
Burlesque::Role.create(name: 'user#manage' ).translate_name()  ==>  Manage User
```

However, you are free to override the Burlesque defaults (e.g. for localization, here in Spanish):

```yaml
es:
  authorizations:
    read: Leer
    create: Crear
    update: Actualizar
    destroy: Eliminar
    manage: Administrar
```

```ruby
# Provided Spanish is the default language of your app
Burlesque::Role.create(name: 'user#read'   ).translate_name()  ==>  Leer Usuario
Burlesque::Role.create(name: 'user#create' ).translate_name()  ==>  Crear Usuario
Burlesque::Role.create(name: 'user#update' ).translate_name()  ==>  Actualizar Usuario
Burlesque::Role.create(name: 'user#destroy').translate_name()  ==>  Eliminar Usuario
Burlesque::Role.create(name: 'user#manage' ).translate_name()  ==>  Administrar Usuario
```

If what you want is to change the translation of a single `Burlesque::Role`, you can:
Finally, in case you were not satisfied by the generated translations, you can define your own:

```yaml
es:
  authorizations:
    user#read: 'Read Awesome Users'
```

```ruby
Burlesque::Role.action(:read).resource(:user).translate_name()  ==>  Read Awesome Users
Burlesque::Role.find_by_name('user#read').translate_name()      ==>  Read Awesome Users
```

# Contributing

TODO

# CanCan

Burlesque makes no assumption about how auhtorizations are handled in your application. However it integrates nicely with [CanCan][cancan] all you have to do is define the `Ability` model as follows:

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


# Todo

Rake task for burlesque admin module inclusion.
