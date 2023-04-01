package dreamteam.progetto.model;

public class Offer {
	private int idTeam;
	private String emailUser;
	private String description;
	private Double parcel;
	private int estimatedDuration;
	
	public int getIdTeam() {
		return idTeam;
	}
	public void setIdTeam(int idTeam) {
		this.idTeam = idTeam;
	}
	public String getEmailUser() {
		return emailUser;
	}
	public void setEmailUser(String emailUser) {
		this.emailUser = emailUser;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Double getParcel() {
		return parcel;
	}
	public void setParcel(Double parcel) {
		this.parcel = parcel;
	}
	public int getEstimatedDuration() {
		return estimatedDuration;
	}
	public void setEstimatedDuration(int estimatedDuration) {
		this.estimatedDuration = estimatedDuration;
	}

}
