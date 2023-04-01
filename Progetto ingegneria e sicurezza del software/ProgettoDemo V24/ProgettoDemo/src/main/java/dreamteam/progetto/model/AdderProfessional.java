package dreamteam.progetto.model;

import java.sql.SQLException;

public class AdderProfessional extends Decorator {

	public AdderProfessional(Component component) {
		super(component);
	}
	
	@Override
	public void contactUser(Offer offer) throws ClassNotFoundException, SQLException {
		userdao.contactUser(offer);
	}

	@Override
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		
	}
	

}
