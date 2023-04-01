package dreamteam.progetto.model;

import java.sql.SQLException;

public class Gestore extends User{
	public Gestore() {}
	
	public void createTeam(Team team) throws ClassNotFoundException, SQLException {
		userdao.createTeam(team);
	}
	
	public void contactUser(Offer offer) throws ClassNotFoundException, SQLException{
		userdao.contactUser(offer);
	}
	
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException {
		userdao.addHours(idTeam, email);
		userdao.removeUser(idTeam , email);
	}
	
	public void setPower(int choose, String email, int idTeam) throws ClassNotFoundException, SQLException{
		userdao.setPower(choose, email, idTeam);
	}
	
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException{
		userdao.updateInfoTeam(team);
	}
	
	public void closeTeam(int idTeam) throws ClassNotFoundException, SQLException{
		userdao.closeTeam(idTeam);
		userdao.removeAllUser(idTeam);
	}
	
	public void reviewTeam(Review review) throws ClassNotFoundException, SQLException{
		userdao.reviewTeam(review);
	}

	public void createAds(Advertisement ads) throws ClassNotFoundException, SQLException{
		userdao.createAds(ads);
	}

	public void closeAds(int idTeam) throws ClassNotFoundException, SQLException {
		userdao.closeAds(idTeam);
	}

	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException {
		userdao.reviewMember(email, star, availability, professionalism, behaviour, description);
		
	}
	

	
}
