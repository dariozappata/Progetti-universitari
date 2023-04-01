package dreamteam.progetto.model;

import java.sql.SQLException;

public class ReviewerProfessional extends Decorator{

	public ReviewerProfessional(Component component) {
		super(component);
	}
	
	@Override
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		userdao.reviewMember(email, star, availability, professionalism, behaviour, description);
	}


	@Override
	public void contactUser(Offer offer) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException {
	}

	@Override
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException {
	}

	
}
