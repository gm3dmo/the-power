require "rbnacl"
require "base64"

# You will likely need to `gem install rbnacl` for this script to work.

# Check for required environment variables
unless ENV["private_pem_file"]
  STDERR.puts "Error: private_pem_file environment variable is not set. Please set it to the path of your private key file."
  exit 1
end

# Check if the private key file exists
private_key_path = File.join(ENV["HOME"], ENV["private_pem_file"])
unless File.exist?(private_key_path)
  STDERR.puts "Error: Private key file not found at #{private_key_path}"
  exit 2
end

# Check if organization public key is provided
unless ARGV[0]
  STDERR.puts "Error: Organization public key not provided. Usage: ruby script.rb <org_public_key>"
  exit 3
end

begin
  org_public_key = ARGV[0]
  key = Base64.decode64(org_public_key)
  public_key = RbNaCl::PublicKey.new(key)

  box = RbNaCl::Boxes::Sealed.from_public_key(public_key)

  secret = File.read(private_key_path)
  encrypted_secret = box.encrypt(secret)

  puts Base64.strict_encode64(encrypted_secret)
rescue RbNaCl::CryptoError => e
  STDERR.puts "Error: Failed to encrypt secret - #{e.message}"
  exit 4
rescue ArgumentError => e
  STDERR.puts "Error: Invalid organization public key - #{e.message}"
  exit 5
rescue => e
  STDERR.puts "Error: #{e.message}"
  exit 6
end
