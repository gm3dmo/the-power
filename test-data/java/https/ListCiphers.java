import javax.net.ssl.SSLSocketFactory;

public class ListCiphers {
    public static void main(String[] args) {
        String[] ciphers = ((SSLSocketFactory) SSLSocketFactory.getDefault()).getSupportedCipherSuites();
        for (String cipher : ciphers) {
            System.out.println(cipher);
        }
    }
}
