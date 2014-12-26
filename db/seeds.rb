# Import the list of json formatted addresses from stdin
#
# The format: (order never matters)
# [
#   { # Represents one address
#     "roles": ["role1", ...],
#     "product": ["product1", ...],
#     "addr_field1": "value",
#     "addr_field2": "value",
#     ...
#   },
#   ...
# ]
#
# TODO: Sanitize! Even though this data can not be forged
#       by an attacker
# TODO: This is wayyyyyy to slow!
# TODO: Error Messages

dat = JSON.parse STDIN.read
Address.transaction do
  dat.each_with_index do |d,i|
    print "\rImport #{i+1}/#{dat.length}"
    Address.create! d
  end
end
print "\n"
