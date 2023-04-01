package dreamteam.progetto.model;

import java.sql.SQLException;

public class RemoverProfessional extends Decorator{

	public RemoverProfessional(Component component) {
		super(component);
	}
	
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException{
		userdao.addHours(idTeam, email);
		userdao.removeUser(idTeam , email);
	}

	@Override
	public void contactUser(Offer offer) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		
	}

}
