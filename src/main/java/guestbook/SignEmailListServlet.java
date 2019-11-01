package guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignEmailListServlet extends HttpServlet{

	public void doGet(HttpServletRequest req, HttpServletResponse resp)

            throws IOException {
		
			UserService userService = UserServiceFactory.getUserService();
			
			User user = userService.getCurrentUser();
			UserEmail userEmail = new UserEmail(user);
			ofy().save().entity(userEmail).now();
			
			String guestbookName = req.getParameter("guestbookName");
			
			resp.sendRedirect("/gb.jsp?guestbookName=" + guestbookName);
	}
}
	
