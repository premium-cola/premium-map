require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  def test_parse_file
    Address.parse_excel(File.expand_path("../../data/example.xls", __FILE__))
  end

end
