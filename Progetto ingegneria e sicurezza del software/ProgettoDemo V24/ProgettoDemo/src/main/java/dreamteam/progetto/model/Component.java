package dreamteam.progetto.model;

import java.sql.SQLException;

public interface Component {
	public void contactUser(Offer offer)throws ClassNotFoundException, SQLException;
	public void removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException;
	public void updateInfoTeam(Team team) throws ClassNotFoundException, SQLException;
	public void reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws ClassNotFoundException, SQLException;
}
