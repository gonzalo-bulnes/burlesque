# Burlesque

Crea estructura de roles y grupos para cualquier modelo, considera además las 3 tablas de _join_ que pudiesen darse.


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

Esto habilita en el modelo que incluye el modulo `Burlesque::Admin` que se pueda asignar `Burlesque::Groups` y `Burlesque::Roles`.

## Definicion de Roles

Usted puede definir roles:

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

Esto crear las siguiente autorizaciones:

<table>
  <thead>
    <th>Action</th>
    <th>Resource</th>
    <th>Description</th>
  </thead>
  <tbody>
    <tr>
      <td>Read</td>
      <td>User</td>
      <td>Puede ver lista y detalle de un Usuario</td>
    </tr>
    <tr>
      <td>Create</td>
      <td>User</td>
      <td>Puede crear un nuevo Usuario (:new, :create)</td>
    </tr>
    <tr>
      <td>Update</td>
      <td>User</td>
      <td>Puede actualizar un Usuario (:edit, :update)</td>
    </tr>
    <tr>
      <td>Destroy</td>
      <td>User</td>
      <td>Puede eliminar un Usuario</td>
    </tr>
  </tbody>
</table>

Action  | Resource | Description
:-------|:---------|:-----------
Read    | User     | Puede ver lista y detalle de un Usuario
Create  | User     | Puede crear un nuevo Usuario (:new, :create)
Update  | User     | Puede actualizar un Usuario (:edit, :update)
Destroy | User     | Puede eliminar un Usuario


## Definicion de Grupos

Para crear un `Burlesque::Group` usted puede utilizar la forma que mejor le parezca, `Burlesuque` solo lo obliga a que defina los nombre de forma unica, quiza usted deba hacerlo de la siguiente forma.

```
Burlesque::Group.find_or_create_by_name('Administrator')
```

## Grupos y Roles

Para asignar una lista de Roles por id a un `Burlesque::Group` usted puede:

```
groupo.push_roles [role]  # Donde role es una instancia de un Rol
```

Esto le asegura que los roles solo seran asignados de forma unica al `Burlesque::Group`, si usted quiere asignar los grupos por su cuenta, tambien puede hacerlo, pero antes de asignalos es necesario que revise que el `Burlesque::Role` no esta ya asignado, de lo contrario se levantara la excepcion `ActiveRecord::RecordInvalid`.



## Funciones de Ayuda

Asumiendo que usted incluyo **Burlesque** en su modelo `User`:

### Questions
Para consultar si un usuario tiene un *Grupo* puntual:

```
user.group?(group)  # group -> instancia o nombre del groupo a consultar
```

Para consultar si un usuario tiene un Rol puntual

```
user.role?(role)  # role -> una instancia o nombre del rol a consultar
```

Dado que un usuario puede tener Roles sin necesariamente pertenecer a un groupo, es probable que usted quiera consultar su un Rol que es producto de pertenecer a un Grupo o no.

```
role_in_groups?(role)  # role -> una instancia o nombre del rol a consultar
```

### MassAssignment

Para asignar una lista de Grupos por id a un `User`:

```
user.group_ids=(ids)
```

Para asignar una lista de Roles por id:

```
user.role_ids=(ids)
```


### Search

Usted puede bucar Roles facilmente utilizando los SCOPE de busqueda definidos y combinarlos de la forma que necesite

Scope         | Description
:-------------|:-----------
action        | Para buscar Roles que estan asociados a una misma accion.
not_action    | Para buscar Roles que no estan asociados a una misma accion.
resource      | Para buscar Roles que estan vinculados a un recurso en cuestion
not_resource  | Para buscar Roles que no estan vinculados a un recurso en cuestion

# I18n

Si usted desea traducir sus Roles puede utilizar la funcion:

```
role.translate_name()  # Donde role es una instancia de un Rol
```

Esta traduce de forma natural utilizando un archivo `YML, si usted tiene solo acciones REST, no es necesario traducir los roles, basta que tenga la definicion de sus modelos, y burlesque le provee traducciones para sus Roles, ejemplo:

```
Role.create(name: 'user#read'   ).translate_name()  ==>  'Read User'
Role.create(name: 'user#create' ).translate_name()  ==>  'Create User'
Role.create(name: 'user#update' ).translate_name()  ==>  'Read User'
Role.create(name: 'user#destroy').translate_name()  ==>  'Destroy User'
Role.create(name: 'user#manage' ).translate_name()  ==>  'Manage User'
```

Pero si usted desea cambiar esto usted puede crear un `YML` y definir sus propias traducciones, ejemplo para traducir al Español, (Recuerde traducir sus modelos en su archivo `YML`):

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

Si lo que usted desea es cambiar la traduccion de un solo Rol, usted puede:

```
es:
  authorizations:
    user#read: List Users
```

```
Role.create(name: 'user#read').translate_name()  ==>  'List Users'
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
