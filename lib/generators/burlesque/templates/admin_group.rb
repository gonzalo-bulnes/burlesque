# encoding: utf-8

# Public: Modelo intermedio, permite que un Grupo pueda ser asignado a un 'Administrador',
#         Este administrador puede ser cualquier modelo que incluya el modulo 'Burlesque::Admin'
#
class AdminGroup < ActiveRecord::Base
  # Modulo que permite manejar Grupos asignables a otros modelo
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::AdminGroup
end