<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>

<%@ page import="java.util.Collections" %>

<%@ page import="guestbook.Greeting" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>

<%@ page import="com.google.appengine.api.datastore.Query" %>

<%@ page import="com.google.appengine.api.datastore.Entity" %>

<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>

<%@ page import="com.google.appengine.api.datastore.Key" %>

<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<%@ page import="com.googlecode.objectify.Objectify" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>

 

  <body>

 

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();
    
    %>

 <p>Click <a href="/gb.jsp?guestbookName=${guestbookName}" >here</a> to reduce the number of blog entries</p>

<%


	ObjectifyService.register(Greeting.class);

	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
	
	Collections.sort(greetings);
	
	

    if (greetings.isEmpty()) {

        %>

        <p>There are no blog entries.</p>

        <%

    } else {

        %>

        <p>Blog Entries: </p>

        <%

        for (Greeting greeting : greetings) {
        	
        	pageContext.setAttribute("greeting_title",
        							 greeting.getTitle());

            pageContext.setAttribute("greeting_content",

                                     greeting.getContent());
            pageContext.setAttribute("greeting_date",
            						 greeting.getDate().toString());

            pageContext.setAttribute("greeting_user",

                                         greeting.getUser());

                %>

            <p><b>(${fn:escapeXml(greeting_date)}) ${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
			<div class="title"><blockquote><b>${fn:escapeXml(greeting_title)}</b></blockquote></div>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>

       <%

        }

    }

%>


 



 

  </body>

</html>