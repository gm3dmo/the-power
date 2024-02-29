require "rbnacl"
require "base64"

# You will likely need to `gem install rbnacl` for this script to work.

org_public_key = ARGV[0]

key = Base64.decode64(org_public_key)
public_key = RbNaCl::PublicKey.new(key)

box = RbNaCl::Boxes::Sealed.from_public_key(public_key)

# make the filename an env variable
# read the file from the env variable prefixed with $HOME
# secret = File.read(ENV["HOME"] + "/.ssh/id_rsa")
secret = File.read(ENV["HOME"] + '/' + ENV["private_pem_file"])
# print the secret to stderr
$stderr.puts "The secret is:"

$stderr.puts secret

encrypted_secret = box.encrypt(secret)

# Print the base64 encoded secret
puts Base64.strict_encode64(encrypted_secret)
