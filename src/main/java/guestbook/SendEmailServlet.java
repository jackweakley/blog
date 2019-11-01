package guestbook;

import javax.mail.*;
import javax.mail.internet.*;

import java.io.*;
import java.io.UnsupportedEncodingException;
import java.util.*;
import com.googlecode.objectify.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;


public class SendEmailServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		
				throws IOException{
		formatEmailAndSend();
	}
	
	public void formatEmailAndSend() {
		
		long time = System.currentTimeMillis();
		Date aDayAgo = new Date(time - 3600*24*1000);
		
		ObjectifyService.register(User.class);
		ObjectifyService.register(Greeting.class);
		
		List<User> users = ObjectifyService.ofy().load().type(User.class).list();
		List<String> emails = new ArrayList<>();
		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		List<Greeting> recentGreetings = new ArrayList<Greeting>();
		
		for(User user : users) {
			emails.add(user.getEmail());
		}
		for(Greeting greeting : greetings) {
			if(greeting.getDate().before(aDayAgo))
				recentGreetings.add(greeting);
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("Blog posts from the last 24 hours: \n\n");
		for(Greeting greeting : recentGreetings) {
			sb.append("User: " + greeting.getUser() + "\nTitle: " 
				+ greeting.getTitle() + "\nContent: " + greeting.getContent() + "\n\n");
		}
		
		
		sendEmail("jackweakley1@gmail.com", emails, "Daily Digest", sb.toString());

	}

	public void sendEmail(String sendEmailFrom, List<String> sendEmailTo, String messageSubject, String messageText) {
		Properties prop = new Properties();
		Session session = Session.getDefaultInstance(prop, null);
		
		try {
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(sendEmailFrom));
			Address[] addresses = new Address[sendEmailTo.size()];
			for (int i = 0; i < sendEmailTo.size(); i++) {
				addresses[i] = new InternetAddress(sendEmailTo.get(i));
			}
			msg.addRecipients(Message.RecipientType.TO, addresses);
			msg.setSubject(messageSubject);
			msg.setText(messageText);
			Transport.send(msg);
			System.out.println("Successful Delivery.");
			
		}
		catch(Exception e) {			
			e.printStackTrace();
		}
		
		
	}
}
