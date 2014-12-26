Dir["#{Rails.root}/lib/patches/*"].each do |p|
  require_relative p
end
