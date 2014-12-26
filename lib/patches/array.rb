class Array
  alias :filter :select
  alias :filter! :select!

  # TODO: Still a bit inconvenient
  def self.Lit *a
    a
  end
end

