module HaveTags
  extend ActiveSupport::Concern

  included do
    def self.have_tags clz
      sym      = HaveTags.sym_get clz
      sym_set  = HaveTags.sym_set clz
      sudo_set = HaveTags.sudo_set clz

      self.class_eval do
        has_and_belongs_to_many sym

        @@tagcache ||= {}
      
      protected
        alias_method sudo_set, sym_set

      public
        define_method sym do
          # TODO: We should actually just mutate the array.
          @@tagcache[clz] ||= super().to_a
        end

        define_method "#{sym}=".intern do |x|
          @@tagcache[clz] = x
        end

      protected

        # Resolve the models of roles/producs so we can do this:
        #   address.products = [:cola, "beer", Product("mate")]
        #   address.roles << :merchant
        def resolve_tags
          return unless @@tagcache
          @@tagcache.each do |clz, tagv|
            tagv.map! {|x| clz.Get(x) }
            send HaveTags.sudo_set(clz), tagv
          end
        end

      end
    end
  end

  def tag_set? clz, *tags
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
    "#{sym_get clz}="
  end

  def self.sudo_set clz
    "sudo_#{sym_get clz}=".intern
  end
end
