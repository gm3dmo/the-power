require 'openssl'
require 'jwt'  # https://rubygems.org/gems/jwt


private_pem_name = ARGV[0]

private_pem = File.read("#{Dir.home}/#{private_pem_name}")
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
