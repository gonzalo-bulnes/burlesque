# encoding: utf-8

# Public: Modelo que maneja Roles.
#         Un Role es un permiso que permite a un usuario a realizar una determinada acción sobre un modelo
#
class Role < ActiveRecord::Base
  # Modulo que permite manejar Roles
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::Role
end