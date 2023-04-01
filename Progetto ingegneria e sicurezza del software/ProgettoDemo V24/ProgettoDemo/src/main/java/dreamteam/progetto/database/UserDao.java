package dreamteam.progetto.database;

import java.sql.*;

import org.springframework.security.crypto.bcrypt.BCrypt;

import dreamteam.progetto.model.*;

public class UserDao {
	
	String jdbcURL = "jdbc:mysql://localhost:3306/progettodb";
	String dbUser = "root";
	String dbPassword = "root";
	String driver = "com.mysql.cj.jdbc.Driver";
	

	public int registerUser(User utente) throws ClassNotFoundException, SQLException{
        String INSERT_USERS_SQL = "INSERT INTO user" +
            "  (email, password, firstName, lastName, hours, cid) VALUES " +
            " (?, ?, ?, ?, ?, ?);";
        int result = 0;

        Class.forName(driver);

        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USERS_SQL);
            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getPassword());
            preparedStatement.setString(3, utente.getFirstName());
            preparedStatement.setString(4, utente.getLastName());
            preparedStatement.setInt(5, utente.getHours());
            preparedStatement.setBlob(6, utente.getCid());
         
            System.out.println(preparedStatement);
            
            result = preparedStatement.executeUpdate();

        return result;
    }
	
	
	@SuppressWarnings("unchecked")
	public <T extends User> T checkLogin(String email, String password, String scelta) throws SQLException,ClassNotFoundException {
		
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		
		String sql = "SELECT * FROM user WHERE email = ?";
		PreparedStatement statement = connection.prepareStatement(sql);
		statement.setString(1, email);

		ResultSet result = statement.executeQuery();
		
		if (result.next() && (BCrypt.checkpw(password,result.getString("password"))) ) {
			UserFactory factory = new UserFactoryImpl();
			if(scelta.equalsIgnoreCase("professionista")) {
				Professionista user = factory.getType("Professionista");
				user.setEmail(email);
				connection.close();
				return (T) user;
			}
			if(scelta.equalsIgnoreCase("gestore")) {
				Gestore user = factory.getType("Gestore");
				user.setEmail(email);
				connection.close();
				return (T) user;
			}	
		}

		connection.close();
		return null;
	}
	
	public int updateData(User utente) throws SQLException,ClassNotFoundException{

		int result=0;
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		if(!(utente.getProfession().equals(""))){
			String sql = "UPDATE user SET profession = ? WHERE email = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, utente.getProfession());
			statement.setString(2, utente.getEmail());
			result = statement.executeUpdate();
		}
		if(utente.getYearsExperience()!=null){
			String sql = "UPDATE user SET yearsExperience = ? WHERE email = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setInt(1, utente.getYearsExperience());
			statement.setString(2, utente.getEmail());
			result = statement.executeUpdate();
		}
		if(utente.getHours()!=null){
			String sql = "UPDATE user SET hours = ? WHERE email = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setInt(1, utente.getHours());
			statement.setString(2, utente.getEmail());
			result = statement.executeUpdate();
		}
		if(utente.getParcel()!=null){
			String sql = "UPDATE user SET parcel = ? WHERE email = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setDouble(1, utente.getParcel());
			statement.setString(2, utente.getEmail());
			result = statement.executeUpdate();
		}
		if(utente.getCv()!=null){
			String sql = "UPDATE user SET cv = ? WHERE email = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setBlob(1, utente.getCv());
			statement.setString(2, utente.getEmail());
			result = statement.executeUpdate();
		}
		
		connection.close();
		return result;
	}
	
	public int createTeam(Team team) throws ClassNotFoundException, SQLException{
		
		String INSERT_TEAM_SQL = "INSERT INTO team" +
	            "  (id, emailFounder, nameTeam, description, category, largeness, estimatedDuration, state) VALUES " +
	            " (?, ?, ?, ?, ?, ?, ?, ?);";
	        int result = 0;

	        Class.forName(driver);

	        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

	        PreparedStatement preparedStatement = connection.prepareStatement(INSERT_TEAM_SQL);
	        preparedStatement.setString(1, null);
	        preparedStatement.setString(2, team.getEmailFounder());
	        preparedStatement.setString(3, team.getNameTeam());
	        preparedStatement.setString(4, team.getDescription());
	        preparedStatement.setString(5, team.getCategory());
	        preparedStatement.setString(6, team.getLargeness());
	        preparedStatement.setString(7, team.getEstimatedDuration());   
	        preparedStatement.setBoolean(8, true);

	        System.out.println(preparedStatement);

	        result = preparedStatement.executeUpdate();
	        connection.close();
	        return result;
	}
	
	public int contactUser(Offer offer) throws ClassNotFoundException, SQLException{
		
		String INSERT_OFFER_SQL = "INSERT INTO contatta" + 
		"(idTeam, emailProfession, description, parcel, estimatedDuration) VALUES " +
		"( (SELECT id from team WHERE id= ?), (SELECT email from user WHERE email= ?), ?, ? , ?);";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_OFFER_SQL);
		
		preparedStatement.setInt(1, offer.getIdTeam());
		preparedStatement.setString(2, offer.getEmailUser());
		preparedStatement.setString(3, offer.getDescription());
		preparedStatement.setDouble(4, offer.getParcel());
		preparedStatement.setInt(5, offer.getEstimatedDuration());
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		connection.close();
		return result;
	}
	
	public int deleteOffer(int idTeam, String email) throws ClassNotFoundException, SQLException{
		String DELETE_OFFER_SQL = "DELETE FROM contatta where idTeam= ? and emailProfession= ? ;";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(DELETE_OFFER_SQL);
		preparedStatement.setInt(1, idTeam);
		preparedStatement.setString(2, email);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		connection.close();
		return result;		
	}
	
	public int addTeam(int idTeam, String email) throws ClassNotFoundException, SQLException{
		String VERIFY_EXIST= "SELECT state FROM partecipa WHERE state= false AND idTeam= ? AND email= ? ;";
		int result = 0;
		Boolean state=null;
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		
		PreparedStatement preparedStatement = connection.prepareStatement(VERIFY_EXIST);
		
		preparedStatement.setInt(1, idTeam);
		preparedStatement.setString(2, email);
		System.out.println(preparedStatement);
		ResultSet resultSet = preparedStatement.executeQuery();
		
		if(resultSet.next()) {
			state=resultSet.getBoolean("state");
		}
		
		if(state==null) {
			String CREATE_TEAM_SQL = "INSERT INTO partecipa (idTeam, email) "+" VALUES (?, ?);";

			PreparedStatement preparedStatement2 = connection.prepareStatement(CREATE_TEAM_SQL);
			
			preparedStatement2.setInt(1, idTeam);
			preparedStatement2.setString(2, email);
			
			System.out.println(preparedStatement2);
			result = preparedStatement2.executeUpdate();
			
		}
		else {
			String UPDATE_STATE = "UPDATE partecipa SET state = true WHERE idTeam= ? AND email= ?;";
			PreparedStatement preparedStatement3 = connection.prepareStatement(UPDATE_STATE);
			
			preparedStatement3.setInt(1, idTeam);
			preparedStatement3.setString(2, email);
			
			System.out.println(preparedStatement3);
			result = preparedStatement3.executeUpdate();
		}
		connection.close();
		return result;

	}
	
	public int updateHours(String email) throws ClassNotFoundException, SQLException{
		String UPDATE_HOURS_SQL = "UPDATE user a JOIN contatta b on(a.email=b.emailProfession) "
				+ "SET hours=(a.hours-b.estimatedDuration) "
				+ "WHERE a.email= ?;";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

		PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_HOURS_SQL);
		preparedStatement.setString(1,email);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
	
		connection.close();
		return result;
	}
	
	public int setRemainingHours(int idTeam, String email) throws ClassNotFoundException, SQLException{
		String SET_HOURS_SQL = "UPDATE partecipa JOIN contatta on(email=emailProfession) "
				+ "SET removedHours=estimatedDuration "
				+ "WHERE email= ? AND partecipa.idTeam= ?;";
		int result = 0;
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

		PreparedStatement preparedStatement = connection.prepareStatement(SET_HOURS_SQL);
		preparedStatement.setString(1, email);
		preparedStatement.setInt(2, idTeam);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		connection.close();
		return result;
	}
	
	public int removeUser(int idTeam, String email) throws ClassNotFoundException, SQLException {
		String REMOVE_MEMBER_SQL = "UPDATE partecipa SET state= false, adder=false, remover=false, updater=false, reviewer=false, removedHours=0 where idTeam= ? and email= ? ;";
		int result = 0;
		
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(REMOVE_MEMBER_SQL);
		preparedStatement.setInt(1, idTeam);
		preparedStatement.setString(2, email);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		connection.close();
		return result;		
	}
	
	public int addHours(int idTeam, String email) throws ClassNotFoundException, SQLException{
		String ADD_HOURS_SQL = "UPDATE user JOIN partecipa on(user.email=partecipa.email) "
				+ "SET hours=(hours+removedHours) "
				+ "WHERE partecipa.email= ? AND idTeam= ? ;";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(ADD_HOURS_SQL);
		preparedStatement.setString(1, email);
		preparedStatement.setInt(2, idTeam);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		connection.close();
		return result;
	}
	
	public int removeAllUser(int idTeam) throws ClassNotFoundException, SQLException{
		String ADD_HOURS_SQL = "UPDATE user JOIN partecipa on(user.email=partecipa.email) "
				+ "SET hours=(hours+removedHours) "
				+ "WHERE idTeam= ? ;";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(ADD_HOURS_SQL);
		preparedStatement.setInt(1, idTeam);
		
		System.out.println(preparedStatement);
		preparedStatement.executeUpdate();
		
		String REMOVE_MEMBER_SQL = "UPDATE partecipa SET state= false, adder=false, remover=false, updater=false, reviewer=false, removedHours=0 where idTeam= ?;";
		
		PreparedStatement preparedStatement2 = connection.prepareStatement(REMOVE_MEMBER_SQL);
		preparedStatement2.setInt(1, idTeam);
		
		System.out.println(preparedStatement2);
		result = preparedStatement2.executeUpdate();
		
		connection.close();
		return result;
	}
	
	public int setPower(int choose, String email, int idTeam) throws ClassNotFoundException, SQLException{
		String SET_POWER = null;
		if (choose==1)
		{
			SET_POWER = "UPDATE partecipa SET adder = NOT adder WHERE idTeam= ? AND email= ?;";
		}
		else if (choose==2) {
			SET_POWER = "UPDATE partecipa SET remover = NOT remover WHERE idTeam= ? AND email= ?;";
		}
		else if (choose==3) {
			SET_POWER = "UPDATE partecipa SET updater = NOT updater WHERE idTeam= ? AND email= ?;";
		}
		else if (choose==4) {
			SET_POWER = "UPDATE partecipa SET reviewer = NOT reviewer WHERE idTeam= ? AND email= ?;";
		}
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

		PreparedStatement preparedStatement = connection.prepareStatement(SET_POWER);
		preparedStatement.setInt(1, idTeam);
		preparedStatement.setString(2, email);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
	
		connection.close();
		return result;
	}
	
	public boolean isFounder(String email) throws ClassNotFoundException, SQLException{
		
		String EMAIL_FOUNDER_SQL = "SELECT emailFounder FROM team where id= ?;";
		
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(EMAIL_FOUNDER_SQL);
		SessionSingleton userSession= SessionSingleton.getInstance();
		preparedStatement.setInt(1, userSession.getIdTeam());
		
		System.out.println(preparedStatement);
		ResultSet resultSet = preparedStatement.executeQuery();
		String emailFounder=null;
		if(resultSet.next()) {
			emailFounder=resultSet.getString("emailFounder");
		}
		connection.close();
		return (emailFounder.equals(email));	
	}
	
	public int updateInfoTeam(Team team) throws ClassNotFoundException, SQLException{
		int result=0;
		int idTeam= team.getID();
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		if(!(team.getNameTeam().equals(""))){
			String sql = "UPDATE team SET nameTeam = ? WHERE id = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, team.getNameTeam());
			statement.setInt(2, idTeam);
			result = statement.executeUpdate();
		}
		if(!(team.getCategory().equals(""))){
			String sql = "UPDATE team SET category = ? WHERE id = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, team.getCategory());
			statement.setInt(2, idTeam);
			result = statement.executeUpdate();
		}
		if(!(team.getLargeness().equals(""))){
			String sql = "UPDATE team SET largeness = ? WHERE id = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, team.getLargeness());
			statement.setInt(2, idTeam);
			result = statement.executeUpdate();
		}
		if(!(team.getEstimatedDuration().equals(""))){
			String sql = "UPDATE team SET estimatedDuration = ? WHERE id = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, team.getEstimatedDuration());
			statement.setInt(2, idTeam);
			result = statement.executeUpdate();
		}
		if(!(team.getDescription().equals(""))){
			String sql = "UPDATE team SET description = ? WHERE id = ?";
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, team.getDescription());
			statement.setInt(2, idTeam);
			result = statement.executeUpdate();
		}
		
		connection.close();
		return result;
	}
	
	public int closeTeam(int idTeam) throws ClassNotFoundException, SQLException{
		String CLOSE_TEAM_SQL = "UPDATE team SET state= false WHERE id= ? ;";
		int result = 0;
		
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(CLOSE_TEAM_SQL);
		
	
		preparedStatement.setInt(1, idTeam);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		connection.close();
		return result;		
	}
	
	public int createAds(Advertisement ads) throws ClassNotFoundException, SQLException{
		String INSERT_ADS_SQL = "INSERT INTO annuncio (idTeam, description) VALUES ( ?, ?);";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ADS_SQL);
		preparedStatement.setInt(1, ads.getIdTeam());
		preparedStatement.setString(2, ads.getDescription());

		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		String INSERT_POSI_SQL="INSERT INTO posizione" + 
				"(idTeam, profession, estimatedDuration, parcel) VALUES " +
				"( ?, ?, ?, ?);";
		preparedStatement = connection.prepareStatement(INSERT_POSI_SQL);
		for(int i=0; i<ads.getProfession().length; i++) {
			preparedStatement.setInt(1, ads.getIdTeam());
			preparedStatement.setString(2, ads.getProfession()[i]);
			preparedStatement.setInt(3, ads.getDuration()[i]);
			preparedStatement.setDouble(4, ads.getParcel()[i]);
			System.out.println(preparedStatement);
			result = preparedStatement.executeUpdate();
		}
		
		connection.close();
		return result;
	}
	
	
	public int addMemberFromAds(String email, int idTeam, int idPosizione) throws SQLException, ClassNotFoundException {
		String SET_POSITION = "UPDATE posizione SET state= 'Occupato' WHERE id = ? ;";
		int result = 0;
		
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(SET_POSITION);
		
		preparedStatement.setInt(1, idPosizione);
		
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
	
		
		String SET_NEW_HOURS_SQL = "UPDATE user"
				+ " SET hours = hours - (SELECT estimatedDuration FROM posizione WHERE id = ?) "
				+ "WHERE email= ?;";
	
		PreparedStatement preparedStatement2 = connection.prepareStatement(SET_NEW_HOURS_SQL);
		preparedStatement2.setInt(1, idPosizione);
		preparedStatement2.setString(2, email);
		
		System.out.println(preparedStatement2);
		preparedStatement2.executeUpdate();
		
		
		String VERIFY_EXIST= "SELECT state FROM partecipa WHERE state= false AND idTeam= ? AND email= ? ;";
		Boolean state=null;
		
		PreparedStatement preparedStatement6 = connection.prepareStatement(VERIFY_EXIST);
		preparedStatement6.setInt(1, idTeam);
		preparedStatement6.setString(2, email);
		System.out.println(preparedStatement6);
		ResultSet resultSet = preparedStatement6.executeQuery();
		
		if(resultSet.next()) {
			state=resultSet.getBoolean("state");
		}
		
		if(state==null) {
		String ADD_TO_TEAM_SQL = "INSERT INTO partecipa (idTeam, email, removedHours) VALUES (?, ?, (SELECT estimatedDuration FROM posizione WHERE id = ?));";

		PreparedStatement preparedStatement3 = connection.prepareStatement(ADD_TO_TEAM_SQL);
		preparedStatement3.setInt(1, idTeam);
		preparedStatement3.setString(2, email);
		preparedStatement3.setInt(3, idPosizione);
		
		System.out.println(preparedStatement3);
		preparedStatement3.executeUpdate();
		}
		else {
			String UPDATE_STATE = "UPDATE partecipa SET state = true, removedHours = (SELECT estimatedDuration FROM posizione WHERE id = ?) WHERE idTeam= ? AND email= ?;";
			PreparedStatement preparedStatement7 = connection.prepareStatement(UPDATE_STATE);
			preparedStatement7.setInt(1, idPosizione);
			preparedStatement7.setInt(2, idTeam);
			preparedStatement7.setString(3, email);
			
			System.out.println(preparedStatement7);
			result = preparedStatement7.executeUpdate();
		}
		
		if(checkState(idTeam)) {
			String DELETE_ADS_SQL = "DELETE FROM annuncio WHERE idTeam= ?;";

			Class.forName(driver);
			PreparedStatement preparedStatement4 = connection.prepareStatement(DELETE_ADS_SQL);
			preparedStatement4.setInt(1, idTeam);
			System.out.println(preparedStatement4);
			preparedStatement4.executeUpdate();
			
			
			String DELETE_ADS2_SQL = "DELETE FROM posizione WHERE idTeam= ?;";
			PreparedStatement preparedStatement5 = connection.prepareStatement(DELETE_ADS2_SQL);
			preparedStatement5.setInt(1, idTeam);
			System.out.println(preparedStatement5);
			preparedStatement5.executeUpdate();	
		}
			
		connection.close();
		return result;
		
	}
	
	public boolean checkState(int idTeam) throws ClassNotFoundException, SQLException{
		boolean check=true;
		String CHECK ="SELECT state FROM posizione WHERE idTeam= ?";
		String state= null;
		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(CHECK);
		preparedStatement.setInt(1, idTeam);
		
		System.out.println(preparedStatement);
		ResultSet result = preparedStatement.executeQuery();
		while(result.next()) {
			state= result.getString("state");
			if(state.equals("Disponibile")) {
				check=false;
			}
		}
		
		return check;
	}

	
	public int closeAds(int idTeam) throws ClassNotFoundException, SQLException {
		String DELETE_ADS_SQL = "DELETE FROM annuncio WHERE idTeam= ?;";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(DELETE_ADS_SQL);
		preparedStatement.setInt(1, idTeam);
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		
		String DELETE_ADS2_SQL = "DELETE FROM posizione WHERE idTeam= ?;";
		PreparedStatement preparedStatement2 = connection.prepareStatement(DELETE_ADS2_SQL);
		preparedStatement2.setInt(1, idTeam);
		System.out.println(preparedStatement2);
		preparedStatement2.executeUpdate();
		
	
		connection.close();
		return result;		
		
	}
	
	public int reviewSystem(String email, String description, int star) throws ClassNotFoundException, SQLException {
		String INSERT_REVIEW_SYSTEM = "INSERT INTO recensioni_sistema" +
	            "  (id, emailUser, star, description, date) VALUES " +
	            " (?, ?, ?, ?, ?);";
	        int result = 0;

	        Class.forName(driver);
	        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
	        
	        long millis=System.currentTimeMillis();  
	        java.sql.Date date=new java.sql.Date(millis); 

	        PreparedStatement preparedStatement = connection.prepareStatement(INSERT_REVIEW_SYSTEM);
	        preparedStatement.setString(1, null);
	        preparedStatement.setString(2, email);
	        preparedStatement.setInt(3, star);
	        preparedStatement.setString(4, description);
	        preparedStatement.setDate(5, date);
	     
	        System.out.println(preparedStatement);

	        result = preparedStatement.executeUpdate();
	        connection.close();
	        return result;
		
	}
	
	public int reviewTeam(Review review) throws SQLException, ClassNotFoundException {
		String INSERT_REVIEW_TEAM_SQL="INSERT INTO recensioni_Team" + 
				"(id, emailUser, star, availability, professionalism, behaviour, description) VALUES " +
				"( ?, ?, ?, ?, ?, ?, ?);";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_REVIEW_TEAM_SQL);
		for(int i=0; i<review.getDescription().length; i++) {
			preparedStatement.setString(1, null);
			preparedStatement.setString(2, review.getEmailUser()[i]);
			preparedStatement.setInt(3, review.getStar()[i]);
			preparedStatement.setInt(4, review.getAvailability()[i]);
			preparedStatement.setInt(5, review.getProfessionalism()[i]);
			preparedStatement.setInt(6, review.getBehaviour()[i]);
			preparedStatement.setString(7, review.getDescription()[i]);
			System.out.println(preparedStatement);
			result = preparedStatement.executeUpdate();
		}
		
		connection.close();
		return result;
	}
	
	public int reviewMember(String email, int star, int availability, int professionalism, int behaviour, String description) throws SQLException, ClassNotFoundException {
		String INSERT_REVIEW_MEMBER_SQL="INSERT INTO recensioni_Team" + 
				"(id, emailUser, star, availability, professionalism, behaviour, description) VALUES " +
				"( ?, ?, ?, ?, ?, ?, ?);";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_REVIEW_MEMBER_SQL);

		preparedStatement.setString(1, null);
		preparedStatement.setString(2, email);
		preparedStatement.setInt(3, star);
		preparedStatement.setInt(4, availability);
		preparedStatement.setInt(5, professionalism);
		preparedStatement.setInt(6, behaviour);
		preparedStatement.setString(7, description);
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		connection.close();
		return result;
		
	}
	
	public int reviewFounder(String email, int star, int availability, int professionalism, int behaviour, String description) throws SQLException, ClassNotFoundException  {
		String INSERT_REVIEW_MEMBER_SQL="INSERT INTO recensioni_Gestore" + 
				"(id, emailUser, star, availability, professionalism, behaviour, description) VALUES " +
				"( ?, ?, ?, ?, ?, ?, ?);";
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_REVIEW_MEMBER_SQL);

		preparedStatement.setString(1, null);
		preparedStatement.setString(2, email);
		preparedStatement.setInt(3, star);
		preparedStatement.setInt(4, availability);
		preparedStatement.setInt(5, professionalism);
		preparedStatement.setInt(6, behaviour);
		preparedStatement.setString(7, description);
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		connection.close();
		return result;
	}
	

	public int buyPass(String email) throws SQLException, ClassNotFoundException {
		String INSERT_PASS_SQL="UPDATE user SET premium_pass=true, expiration_pass= DATE_ADD(CURDATE() ,INTERVAL 365 DAY) "+" WHERE email= ? ;";
				
		int result = 0;

		Class.forName(driver);
		Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PASS_SQL);

		preparedStatement.setString(1, email);
		System.out.println(preparedStatement);
		result = preparedStatement.executeUpdate();
		
		connection.close();
		return result;
		
	}

		
	public String getJdbcURL() {
		return jdbcURL;
	}


	public String getDbUser() {
		return dbUser;
	}


	public String getDbPassword() {
		return dbPassword;
	}


	public String getDriver() {
		return driver;
	}






	


	


	


	


	

}
