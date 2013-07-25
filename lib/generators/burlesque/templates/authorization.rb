# encoding: utf-8

# Public: Modelo intermedio, permite que un Role pueda ser asignado a un 'Administrador',
#         Este administrador puede ser cualquier modelo que incluya el modulo 'Burlesque::Admin'
#
class Authorization < ActiveRecord::Base
  # Modulo que permite manejar Roles asignables a otros modelo
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::Authorization
end