# encoding: utf-8

# Public: Modelo que maneja Grupos
#
class Group < ActiveRecord::Base
  # Modulo que permite manejar Grupos
  # Mas información en: http://rubygems.org/gems/burlesque
  include Burlesque::Group
end