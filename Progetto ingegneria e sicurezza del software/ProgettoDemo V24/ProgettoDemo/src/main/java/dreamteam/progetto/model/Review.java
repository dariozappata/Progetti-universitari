package dreamteam.progetto.model;

public class Review {
	private int id;
	private String[] emailUser;
	private int[] star;
	private int[] availability;
	private int[] professionalism;
	private int[] behaviour;
	private String[] description;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String[] getEmailUser() {
		return emailUser;
	}
	public void setEmailUser(String[] emailUser) {
		this.emailUser = emailUser;
	}
	public int[] getStar() {
		return star;
	}
	public void setStar(int[] star) {
		this.star = star;
	}
	public int[] getAvailability() {
		return availability;
	}
	public void setAvailability(int[] availability) {
		this.availability = availability;
	}
	public int[] getProfessionalism() {
		return professionalism;
	}
	public void setProfessionalism(int[] professionalism) {
		this.professionalism = professionalism;
	}
	public int[] getBehaviour() {
		return behaviour;
	}
	public void setBehaviour(int[] behaviour) {
		this.behaviour = behaviour;
	}
	public String[] getDescription() {
		return description;
	}
	public void setDescription(String[] strings) {
		this.description = strings;
	}
	

}
