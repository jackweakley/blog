/*
 * Jack Weakley
 * URL
 * https://whatever2.appspot.com/
 * */

package guestbook;


import com.google.appengine.api.datastore.DatastoreService;

import com.google.appengine.api.datastore.DatastoreServiceFactory;

import com.google.appengine.api.datastore.Entity;

import com.google.appengine.api.datastore.Key;

import com.google.appengine.api.datastore.KeyFactory;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

import static com.googlecode.objectify.ObjectifyService.ofy;

 

import java.io.IOException;

import java.util.Date;

 

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

 

public class OfySignGuestbookServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

 

        // We have one entity group per Guestbook with all Greetings residing

        // in the same entity group as the Guestbook to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Greetings for a given Guestbook.  However, the write rate to each

        // Guestbook should be limited to ~1/second.

        String guestbookName = req.getParameter("guestbookName");
        
        String title = req.getParameter("title");

        String content = req.getParameter("content");

        Greeting greeting = new Greeting(user, title, content, guestbookName);

        ofy().save().entity(greeting).now();

 

        resp.sendRedirect("/gb.jsp?guestbookName=" + guestbookName);

    }

}