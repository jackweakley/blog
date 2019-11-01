package guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class UnsignEmailListServlet extends HttpServlet{

	public void doPost(HttpServletRequest req, HttpServletResponse resp)

            throws IOException {
		
			UserService userService = UserServiceFactory.getUserService();
			
			User user = userService.getCurrentUser();
			
			ObjectifyService.register(UserEmail.class);
		    List<UserEmail> emails = ObjectifyService.ofy().load().type(UserEmail.class).list();
		    for (UserEmail userEmail : emails) {
		    	if (userEmail.getEmail().equals(user.getEmail())) {
		    		ofy().delete().entity(user).now();
		    		break;
		    	}
		    		
		    }
			
			
			
			String guestbookName = req.getParameter("guestbookName");
			
			resp.sendRedirect("/gb.jsp?guestbookName=" + guestbookName);
	}
}
	
