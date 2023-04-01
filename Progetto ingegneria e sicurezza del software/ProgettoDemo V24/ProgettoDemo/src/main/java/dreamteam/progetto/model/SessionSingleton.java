package dreamteam.progetto.model;

public class SessionSingleton {
	private static SessionSingleton instance= null;
	private String email;
	private Integer idTeam;
	
	public static SessionSingleton getInstance() {
		if(instance== null) {
			instance= new SessionSingleton();
		}
		
		return instance;
	}
	
	public void removeSession() {
		instance.email=null;
		instance.idTeam=null;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Integer getIdTeam() {
		return idTeam;
	}

	public void setIdTeam(Integer idTeam) {
		this.idTeam = idTeam;
	}
	
	
		
}
