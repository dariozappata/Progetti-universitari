package dreamteam.progetto.model;

public class UserFactoryImpl implements UserFactory{

    @SuppressWarnings("unchecked")
	@Override
    public <T extends User> T  getType(String utenteType){
        if (utenteType == null){
            return null; 
        } 
        if (utenteType.equalsIgnoreCase("Professionista")){
            return (T) new Professionista();
        }
        else if (utenteType.equalsIgnoreCase("Gestore")){
            return (T) new Gestore();
        }
        return null;
    }
}