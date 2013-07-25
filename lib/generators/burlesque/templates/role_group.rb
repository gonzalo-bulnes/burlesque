# encoding: utf-8

# Public: Modelo intermedio, permite que un Role pueda ser asignado a un Grupo
#
class RoleGroup < ActiveRecord::Base
  # Modulo que permite manejar Roles asignables a Grupos
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::RoleGroup
end