module HaveTags
  extend ActiveSupport::Concern

  included do

    def self.have_tags clz
      self.class_eval do

        has_and_belongs_to_many HaveTags.sym_get(clz)

        # Setter for the tags. Allows us to do this:
        # Address.products = [Product(:cola), :beer, "frohlunder"]
        # TODO: I would like to mutate the relation object in this way `Address.products << :cola`
        define_method HaveTags.sym_set(clz) do |x|
          super x.map {}
        end

      end
    end

  end

  def tags_set? clz, *tags
    sym = HaveTags.sym_get clz
    tags
      .map {|r| self.send(sym).include? clz.Get(r) }
      .all
  end

private
  def self.sym_get clz
    "#{clz.name.downcase}s".intern
  end

  def self.sym_set clz
    "#{sym_get clz}=".intern
  end
end
