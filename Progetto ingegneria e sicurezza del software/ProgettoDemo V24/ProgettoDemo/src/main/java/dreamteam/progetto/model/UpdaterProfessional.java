package dreamteam.progetto.model;

import java.sql.SQLException;

public class UpdaterProfessional extends Decorator {

	public UpdaterProfessional(Component component) {
		super(component);
	}
	
	@Override
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException{
		userdao.updateInfoTeam(team);
	}

	@Override
	public void contactUser(Offer offer) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		
	}

}
