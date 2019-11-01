package guestbook;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;
import com.googlecode.objectify.ObjectifyService;

import com.google.appengine.api.users.User;

@Entity
public class UserEmail {
	static {
		ObjectifyService.register(UserEmail.class);
	}
	
	@Id Long id;
	@Index String email;
		
	public UserEmail(User user) {
		this.email = user.getEmail();
	}
		
	public String getEmail() {
		return email;
	}
	

}

