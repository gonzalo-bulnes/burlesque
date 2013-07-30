# Burlesque

Create roles and group structure for any model, also considers 3 _join_ tables that might be.


## Installation


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

This enables in model that include `Burlesque::Admin` module, can be assigned `Burlesque::Groups` and `Burlesque::Roles'.

## Defining Role's

You can define/create roles using:

```
Role.for 'user'
```

ó

```
Role.for :user
```

ó

```
Role.for User
```

This will create the following authorizations:

Action  | Resource | Description
:-------|:---------|:-----------
Read    | User     | Can see list of all Users or single User details
Create  | User     | Can create a new User (:new, :create)
Update  | User     | Can Update a User (:edit, :update)
Destroy | User     | Can delete a User


## Defining Group's

Para crear un `Burlesque::Group` usted puede utilizar la forma que mejor le parezca, `Burlesuque` solo lo obliga a que defina los nombre de forma unica, quiza usted deba hacerlo de la siguiente forma.

To create a `Burlesque::Group` you can use as you see fit, `Burlesuque` only forces him to define the name unique way, maybe you should do it this way:

```
Burlesque::Group.find_or_create_by_name('Administrator')
```

## Group's and Role's

To assign an id list of `Burlesque::Role` for a `Burlesque::Group` you can:

```
groupo.push_roles [role]  # Where role is an instance of a `Burlesque::Role`
```

This ensures that you will only be assigned roles only way to `Burlesque::Group`, If you want to assign the groups on your own, you can also do it, but before you assign them is necessary to check that the `Burlesque::Role` not already assigned, otherwise it will rise the exception `ActiveRecord::RecordInvalid`.


## Utility functions

Assuming you included **Burlesque** in your model `User`:

### Questions

To see if a user has a `Burlesque::Group`:

```
user.group?(group)  # group -> Where groups is an instance or name of the `Burlesque::Group` to check
```

To see if a user has a `Burlesque::Role`:

```
user.role?(role)  # role -> Where role is an instance or name of the `Burlesque::Role` to check
```

Since a user may have `Burlesque::Role` without necessarily belonging to a `Burlesque::Group`, you probably want to consult its a role that is a product of belonging to a `Burlesque::Group` or not.

```
role_in_groups?(role)  # role -> Where role is an instance or name of the `Burlesque::Role` to check
```

### MassAssignment

To assign a list of `Burlesque::Group` by id to a `User`:

```
user.group_ids=(ids)
```

To assign a list of `Burlesque::Role` by id to a `User`:

```
user.role_ids=(ids)
```


### Search

You can search `Burlesque::Role` using defined SCOPE search and combine them any way you need.

Scope         | Description
:-------------|:-----------
action        | To search for `Burlesque::Role` that are associated with the same action.
not_action    | To search for `Burlesque::Role` that are not associated with the same action.
resource      | To search for `Burlesque::Role` that are linked to a resource in question
not_resource  | To search for `Burlesque::Role` that are not linked to a resource in question

# I18n

If you want to translate their `Burlesque::Role` may use the function:

```
role.translate_name()  #  Where role is an instance `Burlesque::Role` to be translated
```

This translates naturally using a `YML`, if you have only REST actions, maybe it is not necessary to translate the `Burlesque::Role`, just to have the definition of their models, and `Burlesque` provides translations for their `Burlesque::Role`:


```
Role.create(name: 'user#read'   ).translate_name()  ==>  'Read User'
Role.create(name: 'user#create' ).translate_name()  ==>  'Create User'
Role.create(name: 'user#update' ).translate_name()  ==>  'Read User'
Role.create(name: 'user#destroy').translate_name()  ==>  'Destroy User'
Role.create(name: 'user#manage' ).translate_name()  ==>  'Manage User'
```

Pero si usted desea cambiar esto usted puede crear un `YML` y definir sus propias traducciones, ejemplo para traducir al Español, (Recuerde traducir sus modelos en su archivo `YML`):

But if you want to change this you can create a `YML` and define their own translations, eg to translate into Spanish, (Remember translate their models into your `YML`):

```
es:
  authorizations:
    read: Leer
    show: Mostrar
    create: Crear
    update: Actualizar
    destroy: Eliminar
    manage: Administrar
```

```
Role.create(name: 'user#read'   ).translate_name()  ==>  'Leer Usuarios'
Role.create(name: 'user#create' ).translate_name()  ==>  'Crear Usuarios'
Role.create(name: 'user#update' ).translate_name()  ==>  'Actualizar Usuarios'
Role.create(name: 'user#destroy').translate_name()  ==>  'Eliminar Usuarios'
Role.create(name: 'user#manage' ).translate_name()  ==>  'Administrar Usuarios'
```

If what you want is to change the translation of a single `Burlesque::Role`, you can:

```
es:
  authorizations:
    user#read: My List Users
```

```
Role.create(name: 'user#read').translate_name()  ==>  'My List Users'
```

# Contributing


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
