# TODO: Get rid
require_relative './concerns/tag.rb'

class Product < ActiveRecord::Base
  include Tag
  has_and_belongs_to_many :addresses
end
