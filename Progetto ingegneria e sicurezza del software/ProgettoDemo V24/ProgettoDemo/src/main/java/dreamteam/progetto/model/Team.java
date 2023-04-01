package dreamteam.progetto.model;


public class Team {

	private int ID;
	private String emailFounder;
	private String nameTeam;
	private String description;
	private String category;
	private String largeness;
	private String estimatedDuration;
	private boolean state;
	
	
	public boolean isState() {
		return state;
	}
	public void setState(boolean state) {
		this.state = state;
	}
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getEmailFounder() {
		return emailFounder;
	}
	public void setEmailFounder(String emailFounder) {
		this.emailFounder = emailFounder;
	}
	public String getNameTeam() {
		return nameTeam;
	}
	public void setNameTeam(String nameTeam) {
		this.nameTeam = nameTeam;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getLargeness() {
		return largeness;
	}
	public void setLargeness(String largeness) {
		this.largeness = largeness;
	}
	public String getEstimatedDuration() {
		return estimatedDuration;
	}
	public void setEstimatedDuration(String estimatedDuration) {
		this.estimatedDuration = estimatedDuration;
	}
	
	
}
