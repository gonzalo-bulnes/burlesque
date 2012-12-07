Burlesque
=========

Crea estructura de roles y grupos para cualquier modelo, considera además las 3 tablas de _join_ que pudiesen darse.

Installation
------------

Before you can use the generator, add the gem to your project's Gemfile as follows:

```
gem 'burlesque', :git => 'git@gitlab.acid.cl:burlesque.git'
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
