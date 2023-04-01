package dreamteam.progetto.model;

import dreamteam.progetto.database.UserDao;

public abstract class Decorator implements Component{
	protected Component professional;
	protected UserDao userdao =new UserDao();

	public Decorator(Component component) {
		professional=component;
	}


}
