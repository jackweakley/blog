<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>

<%@ page import="java.util.Collections" %>

<%@ page import="guestbook.Greeting" %>

<%@ page import="guestbook.UserEmail" %>

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


	<header>
		<h1>This is a blog for people to express their feelings about dogs. </h1>
	</header>
 

  <body>

 

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();
    
    ObjectifyService.register(UserEmail.class);
    List<UserEmail> emailUsersTemp = ObjectifyService.ofy().load().type(UserEmail.class).list();
	List<String> emailUsers = new ArrayList<>();
    for(UserEmail userEmail : emailUsersTemp)
    	emailUsers.add(userEmail.getEmail());
    
    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>)</p>

<%
		if(emailUsers.contains(user.getEmail())){
			%>
			Click <a href="/unsignemail?default">here</a> to unsubscribe to the daily digest
			<%
		}
		else{
			%>
			Click <a href="/signemail?default">here</a> to subscribe to the daily digest	
			<%
		}

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to create new blog entries.</p>

<%

    }

%>

 <p><img src="https://cdn.shopify.com/s/files/1/0028/1978/4763/articles/Puppy-care_1400x.progressive.jpg?v=1538555224" alt="Image not found" hspace="20"/></p>

 <p>Click <a href="/allentries.jsp?guestbookName=${guestbookName}" >here</a> to view all blog entries</p>
 	

<%


	ObjectifyService.register(Greeting.class);

	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
	List<Greeting> greetings_subset = new ArrayList<>();

	Collections.sort(greetings);
	int length = Math.min(5, greetings.size());
	for (int i = 0; i < length; i++){
		greetings_subset.add(greetings.get(i));
	}
	

    if (greetings_subset.isEmpty()) {

        %>

        <div id="blogStart">There are no blog entries.</div>
		<a href="/blogpost.jsp">create a new entry</a>
        <%

    } else {

        %>

        <div id="blogStart">Blog Entries: </div>
        <a href="/blogpost.jsp">create a new entry</a>
        
		<div id="blogPosts">


        <%

        for (Greeting greeting : greetings_subset) {
        	
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
        
        %>
        </div>
        <%        

    }

%>

 



 

  </body>

</html>