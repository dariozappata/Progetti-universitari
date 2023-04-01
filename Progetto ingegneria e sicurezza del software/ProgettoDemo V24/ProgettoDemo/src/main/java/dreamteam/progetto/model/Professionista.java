package dreamteam.progetto.model;

import java.sql.SQLException;

public class Professionista extends User implements Component{
	public Professionista () {}
	
	public void acceptOffer(int idTeam, String email) throws ClassNotFoundException, SQLException{
		userdao.updateHours(email);
		userdao.addTeam(idTeam, email);
		userdao.setRemainingHours(idTeam, email);
	}
	
	public void deleteOffer(int idTeam, String email) throws ClassNotFoundException, SQLException{
		userdao.deleteOffer(idTeam, email);
	}
	
	public void addMemberFromAds(String email, int idTeam, int idPosizione) throws ClassNotFoundException, SQLException{
		userdao.addMemberFromAds(email, idTeam, idPosizione);
		
	}
	
	public void reviewSystem(String email, String description, int star) throws ClassNotFoundException, SQLException {
		userdao.reviewSystem(email, description, star);
	}


	public void reviewFounder(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException{
		userdao.reviewFounder(email,star,availability,professionalism,behaviour,description);
		
	}
	public void buyPass(String email) throws ClassNotFoundException, SQLException {
		userdao.buyPass(email);
		
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

	@Override
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		
	}

	


	


}
