import jwt
import time 
import sys

# Get PEM file path
if len(sys.argv) > 1:
    pem = sys.argv[1]
else:
    pem = input("Enter path of private PEM file: ")    

# Open PEM
with open(pem, 'r') as pem_file:
    signing_key = pem_file.read()
    
payload = {
    # Issued at time
    'iat': int(time.time()),
    # JWT expiration time (10 minutes maximum)
    'exp': int(time.time()) + 600, 
    # GitHub App's identifier
    'iss': 'YOUR_APP_ID' 
}
    
# Create JWT
encoded_jwt = jwt.encode(payload, signing_key, algorithm='RS256')
     
print(encoded_jwt())
