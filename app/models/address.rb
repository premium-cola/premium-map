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
  #before_validation :resolve_tags

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

  def distance(point)
    d = distance_from(point) || 1
    d * 1.609344
  end

  def does? *roles
    tag_set(Role, *x)
  end

  def sells? *roles
    product
      .map {|r| self.roles.include? Product(r) }
      .all
  end
end
