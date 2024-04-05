require 'openssl'
require 'jwt'  # https://rubygems.org/gems/jwt
require 'pathname'

private_pem_name = ARGV[0]
private_pem = if Pathname.new(private_pem_name).absolute?
                File.read(private_pem_name)
              else
                warn <<EOM
In .gh-api-examples.conf, a relative path is set to private_pem_file.

   #{private_pem_name}

It is regarded as a relative path from your home directory, but it is recommended to set an absolute path to avoid confusion.

   #{ENV.fetch("HOME")}/#{private_pem_name}
EOM
                File.read("#{Dir.home}/#{private_pem_name}")
              end
private_key = OpenSSL::PKey::RSA.new(private_pem)

# Issued at:
issued_at = Time.now.to_i - 60

# Change the offset value to provoke time errors:
# for example setting: offset_time_by = 1
# will cause:
# {
#   "message": "'Expiration time' claim ('exp') is too far in the future",
#   "documentation_url": "https://docs.github.com/rest"
# }

offset_time_by = 0
expires_at = (Time.now.to_i + offset_time_by) + (10 * 60)


payload = {
  # iat = issued at time
  iat: issued_at,
  # exp = JWT expiration time (10 minute maximum)
  exp: expires_at,
  # GitHub App ID identifier
  iss: ARGV[1].to_i
}

jwt = JWT.encode(payload, private_key, "RS256")
STDERR.puts "This is the JWT: "
puts jwt
