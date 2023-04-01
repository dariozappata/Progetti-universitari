package dreamteam.progetto.model;


import java.io.InputStream;
import java.sql.SQLException;


import dreamteam.progetto.database.UserDao;

public abstract class User {
	protected UserDao userdao =new UserDao();

	private String firstName;
	private String lastName;
	private String email;
	private String password;
	private Integer hours;
	private InputStream cid;
	private String profession;
	private Integer yearsExperience;
	private Double parcel;
	private InputStream cv;
	
	
	
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	
	public String getProfession() {
		return profession;
	}
	public void setProfession(String profession) {
		this.profession = profession;
	}
	
	public Integer getYearsExperience() {
		return yearsExperience;
	}
	public void setYearsExperience(Integer yearsExperience) {
		this.yearsExperience = yearsExperience;
	}
	public Double getParcel() {
		return parcel;
	}
	public void setParcel(Double parcel) {
		this.parcel = parcel;
	}
	public InputStream getCv() {
		return cv;
	}
	public void setCv(InputStream cv) {
		this.cv = cv;
	}
	public Integer getHours() {
		return this.hours;
	}
	public void setHours(Integer hours) {
		this.hours = hours;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public InputStream getCid() {
		return cid;
	}
	public void setCid(InputStream cid) {
		this.cid = cid;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	
	public void registerUser(User utente) throws ClassNotFoundException, SQLException {
		userdao.registerUser(utente);
	}
	
	public void updateData(User utente) throws SQLException, ClassNotFoundException{
		userdao.updateData(utente);
	}
	
	
	
}
