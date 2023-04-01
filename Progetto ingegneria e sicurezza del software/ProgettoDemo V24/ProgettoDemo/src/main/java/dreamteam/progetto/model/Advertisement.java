package dreamteam.progetto.model;

public class Advertisement {
	
	private int idTeam;
	private String description;
	private String []profession;
	private int []duration;
	private double []parcel;
	public int getIdTeam() {
		return idTeam;
	}
	public void setIdTeam(int idTeam) {
		this.idTeam = idTeam;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String[] getProfession() {
		return profession;
	}
	public void setProfession(String[] profession) {
		this.profession = profession;
	}
	public int[] getDuration() {
		return duration;
	}
	public void setDuration(int[] duration) {
		this.duration = duration;
	}
	public double[] getParcel() {
		return parcel;
	}
	public void setParcel(double[] parcel) {
		this.parcel = parcel;
	}
	
	
	
}
