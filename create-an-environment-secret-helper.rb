require "rbnacl"
require "base64"

# You will likely need to `gem install rbnacl` for this script to work.

pk = ARGV[0]

key = Base64.decode64(pk)
public_key = RbNaCl::PublicKey.new(key)

box = RbNaCl::Boxes::Sealed.from_public_key(public_key)
encrypted_secret = box.encrypt("environment_secret_string")

# Print the base64 encoded secret
puts Base64.strict_encode64(encrypted_secret)
