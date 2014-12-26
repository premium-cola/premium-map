module Tag
  extend ActiveSupport::Concern

  # TODO: Cache as Singletons
  # TODO: Indices
  # TODO: Auto delete when there are no linked addresses?
  # TODO: Add mapping for internationalization

  included do
    #validates :name, uniqness: true

    def self.Get x
      return x if x.is_a? self

      name = x.to_s.downcase
      find_by_name(name) || create!(name: name)
    end

    def self.find_by_name name
      where(name: name.to_s.downcase).first
    end

    # Provide the Product(:cola) initializer. No need to use
    # Get.
    clz = self
    Kernel.instance_eval do
      define_method clz.name do |*a|
        clz.Get(*a)
      end
    end

  end
end
