# encoding: UTF-8
# TODO: Can we get rid of these?
require_relative './product'
require_relative './role'
require_relative './concerns/have_tags.rb'

class Address < ActiveRecord::Base
  include HaveTags
  # TODO: Rename to entity?

  geocoded_by :address
  after_validation :reset_geocode

  have_tags Product
  have_tags Role

  before_save :resolve_tags

  def reset_geocode
    # TODO: Use a proper cache for that
    changed =  street_changed? || zipcode_changed? \
            || city_changed? || country_changed?
    return unless changed

    self.latitude = nil
    self.longitude = nil
    geocode
  end

  def address
    # TODO: oO Newline Delimiting?
    "#{self.street}, #{self.zipcode} #{self.city}"
  end

  def person_name o={}
    "#{first_name} #{last_name}".strip
  end

  def business_name
    "#{person_name} #{company}".strip
  end

  def distance point
    distance_from point, :km
  end

  def does? *roles
    tags_set? Role, *roles
  end

  def sells? *products
    tags_set? Product, *products
  end
end
