package dreamteam.progetto.model;


public interface UserFactory {
    public <T extends User> T  getType(String utenteType);
    
    
}