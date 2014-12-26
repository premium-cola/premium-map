# TODO: Get rid
require_relative './concerns/tag.rb'

class Role < ActiveRecord::Base
  include Tag

  has_and_belongs_to_many :addresses
end
