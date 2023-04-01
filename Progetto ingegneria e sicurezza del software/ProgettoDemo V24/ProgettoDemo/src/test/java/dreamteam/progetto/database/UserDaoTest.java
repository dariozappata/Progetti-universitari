package dreamteam.progetto.database;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;

import org.junit.After;
import org.junit.Before;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCrypt;

import dreamteam.progetto.model.*;

class UserDaoTest {
	UserFactory factory = new UserFactoryImpl();
	private Professionista user = factory.getType("Professionista");
	private Team team = new Team();
	private Offer offer = new Offer();
	private Advertisement ads= new Advertisement();
	private Review review = new Review();
	private UserDao userDao=new UserDao();

	@Before
	void setUp() throws Exception {
	}

	@After
	void tearDown() throws Exception {
		user=null;
		assertNull(user);
	}

	
//------------------------------------------------------PRIMO-SPRINT--------------------------------------------------------------------------------------------------------------------------
	@Test
	void registerUserTest() throws ClassNotFoundException, SQLException {
		user.setEmail("provaTest@gmail.com");
    	user.setPassword(BCrypt.hashpw("CiaoCiao!55", BCrypt.gensalt()));
    	user.setFirstName("Giuseppe");
    	user.setLastName("Rossi");
    	user.setHours(200);
    	user.setCid(null);
		assertEquals(userDao.registerUser(user),1);
	}

	
	@Test
	void checkLoginTest() throws SQLException,ClassNotFoundException {
		 assertNotNull(userDao.checkLogin("provaTest@gmail.com", "CiaoCiao!55", "professionista"));
	}

	
	@Test
	void updateDataTest() throws ClassNotFoundException, SQLException {
		user.setEmail("provaTest@gmail.com");  //da cambiare con uno esistente già nel DB
		user.setProfession("Grafico");
		user.setParcel(40.00);
		user.setYearsExperience(5);
		assertEquals(userDao.updateData(user),1);
	}
	
//------------------------------------------------------SECONDO-SPRINT--------------------------------------------------------------------------------------------------------------------------
	@Test
	void createTeamTest() throws  ClassNotFoundException, SQLException{
		team.setEmailFounder("provaTest@gmail.com");
		team.setNameTeam("Team prova");
		team.setDescription("Descrizione prova");
		team.setCategory("Prova");
		team.setLargeness("Nazionale");
		team.setEstimatedDuration("1 anno");
		team.setState(true);
		assertEquals(userDao.createTeam(team),1);
	}
	
	@Test
	void contactUserTest() throws ClassNotFoundException, SQLException{
		offer.setIdTeam(7);  //verificare che esista un team con id 1 nel DB
		offer.setEmailUser("lucrezianeri@gmail.com");  //da creare prima di eseguire il test
		offer.setDescription("Descrizione prova");
		offer.setParcel(25.00);
		offer.setEstimatedDuration(40);
		assertEquals(userDao.contactUser(offer),1);
	}
	
	@Test
	void deleteOfferTest() throws ClassNotFoundException, SQLException{
		assertEquals(userDao.deleteOffer(7,"lucrezianeri@gmail.com"),1);
	}
	
	@Test
	void acceptOfferTest() throws ClassNotFoundException, SQLException{	//prima di eseguirlo rimandare l'offerta
		int idTeam =7;
		String email="lucrezianeri@gmail.com";
		assertEquals(userDao.updateHours(email),1);
		assertEquals(userDao.addTeam(idTeam,email),1);
		assertEquals(userDao.setRemainingHours(idTeam,email),1);
	}
	
	@Test
	void removeUserTest() throws ClassNotFoundException, SQLException{
		int idTeam =7;
		String email="lucrezianeri@gmail.com";
		assertEquals(userDao.addHours(idTeam,email),1);
		assertEquals(userDao.removeUser(idTeam,email),1);
	}
	 
	@Test
	void setPowerTest() throws ClassNotFoundException, SQLException{
		assertEquals(userDao.setPower(1,"lucrezianeri@gmail.com",7),1);
	}
	
	@Test
	void updateInfoTeamTest() throws ClassNotFoundException, SQLException{
		team.setID(7);
		team.setNameTeam("Team prova modifica");
		team.setDescription("Descrizione prova modifica");
		team.setCategory("Prova modifica");
		team.setLargeness("Internazionale");
		team.setEstimatedDuration("2 anni");
		assertEquals(userDao.updateInfoTeam(team),1);
	}
	
	
	@Test
	void createAdsTest() throws ClassNotFoundException, SQLException{
		String [] profession=  {"Grafico","Programmatore","Designer"};
		int [] duration=  {20,30,40};
		double [] parcel=  {20.00,21.00,22.00};
		ads.setIdTeam(7); //verificare che non siano già presenti annunci con idTeam 7
		ads.setDescription("Descrizione test");
		ads.setProfession(profession);
		ads.setDuration(duration);
		ads.setParcel(parcel);
		assertEquals(userDao.createAds(ads),1); 
	}
	
	
	@Test
	void addMemberFromAdsTest() throws ClassNotFoundException, SQLException{
		user.setEmail("provaTest3@gmail.com");
    	user.setPassword(BCrypt.hashpw("ProvaTest!01", BCrypt.gensalt()));
    	user.setFirstName("Paolo");
    	user.setLastName("Rossi");
    	user.setHours(200);
    	user.setCid(null);
		assertEquals(userDao.registerUser(user),1);
		user.setProfession("Grafico");
		assertEquals(userDao.updateData(user),1);
		
		assertEquals(userDao.addMemberFromAds("provaTest3@gmail.com", 7, 5),1); //ATTENZIONE
		//verificare che la professione richiesta dalla posizione sia uguale a quella dell'user
	}
	
	
	@Test
	void closeAdsTest() throws ClassNotFoundException, SQLException{
		assertEquals(userDao.closeAds(7),1);
	}
	
	
	@Test
	void closeTeamTest() throws ClassNotFoundException, SQLException{  //da fare alla fine di tutte le operazione del team
		int idTeam =7;
		assertEquals(userDao.closeTeam(idTeam),1);
		assertEquals(userDao.removeAllUser(idTeam),1);
	}
	
	
	//------------------------------------------------------TERZO-SPRINT--------------------------------------------------------------------------------------------------------------------------
	@Test
	void reviewSystem() throws ClassNotFoundException, SQLException{
		String email= "provaTest3@gmail.com";
		String description= "Ottima piattafroma";
		int stars_value=4;
		assertEquals(userDao.reviewSystem(email,description,stars_value),1);
	}
	
	@Test
	void reviewTeam() throws ClassNotFoundException, SQLException{
		String [] email=  {"mariorossi@gmail.com","lucrezianeri@gmail.com"};
		int [] stars=  {3,5};
		int [] availability=  {2,4};
		int [] professionalism=  {3,5};
		int [] behaviour=  {3,5};
		String [] description=  {"l'utente possiede ottime capacità relazionali","l'utente è molto professionale"};
		review.setEmailUser(email);
		review.setStar(stars);
		review.setAvailability(availability);
		review.setProfessionalism(professionalism);
		review.setBehaviour(behaviour);
		review.setDescription(description);
		assertEquals(userDao.reviewTeam(review),1);
	}
	
	@Test
	void reviewMember() throws ClassNotFoundException, SQLException{
		String email=  "provaTest3@gmail.com";
		int stars= 2;
		int availability= 3;
		int professionalism= 1;
		int behaviour= 2;
		String description= "poco professionale";
		assertEquals(userDao.reviewMember(email,stars,availability,professionalism,behaviour,description),1);
	}
	
	@Test
	void reviewFounder() throws ClassNotFoundException, SQLException{
		String email=  "provaTest3@gmail.com";
		int stars= 5;
		int availability= 4;
		int professionalism= 4;
		int behaviour= 5;
		String description= "un gestore coi fiocchi";
		assertEquals(userDao.reviewFounder(email,stars,availability,professionalism,behaviour,description),1);
	}
	
	@Test
	void buyPass() throws ClassNotFoundException, SQLException{
		String email=  "provaTest3@gmail.com";
		assertEquals(userDao.buyPass(email),1);
	}
	
}
