import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.*;

public class HttpsGetWithCipher {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java HttpsGetWithCipher <host> <cipherSuite>");
            System.exit(1);
        }

        String host = args[0];
        String cipherSuite = args[1];
        int port = 443; // HTTPS default port

        try {
            SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
            try (SSLSocket socket = (SSLSocket) factory.createSocket(host, port)) {
                // Set the specified cipher suite
                socket.setEnabledCipherSuites(new String[]{ cipherSuite });

                socket.startHandshake();

                PrintWriter out = new PrintWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"));
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"));

                // Send HTTP GET request
                out.print("GET / HTTP/1.1\r\n");
                out.print("Host: " + host + "\r\n");
                out.print("Connection: close\r\n");
                out.print("\r\n");
                out.flush();

                // Print the response
                String line;
                while ((line = in.readLine()) != null) {
                    System.out.println(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(2);
        }
    }
}
