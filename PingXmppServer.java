
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.PacketListener;
import org.jivesoftware.smack.SASLAuthentication;
import org.jivesoftware.smack.XMPPConnection;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smack.packet.Packet;

public class PingXmppServer implements PacketListener, MessageListener {

  private static final String HOST = "talk.google.com";
  private static final int PORT = 5222;
  private static Logger logger;
  private XMPPConnection xmppConnection;

  public static void main(String[] args) {
    if (args.length != 2) {
      System.out.println("Please pass a user name and password. ");
      System.out.println("For example: java -cp ./:smack_3_2_2.jar PingXmppServer ping@pla1.net PasswordGoesHere");
      System.exit(-1);
    }
    if (args[0].split("@").length != 2) {
      System.out.println("User name is invalid. Should be like username@example.com");
      System.exit(-1);
    }
    String userName = args[0];
    String password = args[1];
    new PingXmppServer(userName, password);
    while (true) {
      sleep();
    }
  }

  public PingXmppServer(String userName, String password) {
    try {
      logger = Logger.getLogger("");
      Handler handler = new FileHandler("%t/PingXmppServer.log");
      handler.setFormatter(new SimpleFormatter());
      logger.addHandler(handler);
    } catch (Exception ex) {
      Logger.getLogger(PingXmppServer.class.getName()).log(Level.SEVERE, null, ex);
      logger = Logger.getAnonymousLogger();
    }
    logger.log(Level.INFO, "Logging in as: {0}", userName);
    String serviceName = userName.split("@")[1];
    ConnectionConfiguration connectionConfig = new ConnectionConfiguration(HOST, PORT, serviceName);
    xmppConnection = new XMPPConnection(connectionConfig);
    boolean connected = false;
    while (!connected) {
      try {
        xmppConnection.connect();
        SASLAuthentication.supportSASLMechanism("PLAIN", 0);
        xmppConnection.login(userName, password);
        connected = true;
      } catch (XMPPException e) {
        e.printStackTrace();
        sleep();
      }
    }
    logger.info("Logged in.");
    xmppConnection.addPacketListener(this, null);
  }

  public void processPacket(Packet packet) {
    Message message = (Message) packet;
    if (isBlank(message.getBody())) {
      logger.info("Message is blank");
    }
    Runtime runtime = Runtime.getRuntime();
    String firstWord = "";
    logger.log(Level.INFO, "Message: {0} from: {1}", new Object[]{message.getBody(), message.getFrom()});
    String messageBody = message.getBody().replace("ping ", "");
    StringTokenizer st = new StringTokenizer(messageBody);
    if (st.hasMoreTokens()) {
      firstWord = st.nextToken();
    }
    if ("localhost".equalsIgnoreCase(firstWord)) {
      logger.warning("Trying to ping localhost. Abort.");
      return;
    }
    StringBuilder command = new StringBuilder();
    command.append("ping ");
    command.append(firstWord);
    command.append(" -c 1 -w 1");
    logger.log(Level.INFO, "Command to process: {0}", command.toString());
    String fromAddress = message.getFrom();
    try {
      Process process = runtime.exec(command.toString());
      BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
      String line = reader.readLine();
      StringBuilder output = new StringBuilder();
      while (line != null) {
        line = line.trim();
        if (!isBlank(line)) {
          logger.log(Level.INFO, "Received from runtime process: {0}", line);
          output.append(line);
          output.append("\n");
        }
        line = reader.readLine();
      }
      sendMessage(output.toString(), fromAddress);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void sendMessage(String message, String to) throws XMPPException {
    logger.info(message);
    Chat chat = xmppConnection.getChatManager().createChat(to, this);
    chat.sendMessage(message);
  }

  public void processMessage(Chat chat, Message msg) {
    logger.log(Level.INFO, "FROM: {0} MESSAGE: {1}", new Object[]{msg.getFrom(), msg.getBody()});
  }

  private static boolean isBlank(String s) {
    if (s == null || s.trim().length() == 0) {
      return true;
    } else {
      return false;
    }
  }

  private static void sleep() {
    try {
      Thread.sleep(1000);
    } catch (InterruptedException ex) {
      ex.printStackTrace();
    }
  }
}
