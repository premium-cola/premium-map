class ActiveRecord::Base
  def attrs
    attributes.with_indifferent_access
  end
end
