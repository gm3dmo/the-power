## Known Issues/Problems/Solutions

#### SSL: CERTIFICATE_VERIFY_FAILED
When running the `configure.py` script You may see an error like:

```
SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1108)>
```

To fix it, go to your python directory and run the `Install Certificates.command`.

Source: [How to make python use ca certificates from mac os truststore](https://stackoverflow.com/questions/40684543/how-to-make-python-use-ca-certificates-from-mac-os-truststore)

#### Hosts using self signed certificate
If the GHE host is using a self signed certificate then you may want to to add it to your trusted CA's. The error you'll see from `curl` looks like:

```
curl -v  https://3.67.138.205
*   Trying 3.67.138.205...
* TCP_NODELAY set
* Connected to 3.67.138.205 (3.67.138.205) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/cert.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (OUT), TLS alert, unknown CA (560):
* SSL certificate problem: self signed certificate
* Closing connection 0
curl: (60) SSL certificate problem: self signed certificate
More details here: https://curl.haxx.se/docs/sslcerts.html
curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```

Solution: Edit `.gh-api-examples.conf`, locate the `curl_custom_flags` parameter and add `--insecure`:

```
curl_custom_flags="--insecure"
```

#### Chrome storage for smee urls
If you use smee.io very often then Chrome can end up filling up it's storage for smee.io and you must clean clean it down: More toools, Developer tools, Storage. Remove the smee entries.

#### Homebrew base64 causes create-commit-commands to fail

See #70 where the Homebrew base64 command on mac can break things.
