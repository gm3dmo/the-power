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


payload = {
  # iat = issued at time
  iat: Time.now.to_i,
  # exp = JWT expiration time (10 minute maximum)
  exp: Time.now.to_i + (10 * 60),
  # GitHub App ID identifier
  iss: ARGV[1].to_i
}

jwt = JWT.encode(payload, private_key, "RS256")
puts jwt
