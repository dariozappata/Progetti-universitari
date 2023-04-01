package dreamteam.progetto.controllers;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import dreamteam.progetto.model.*;


@WebServlet("/modificaprofilo")
@MultipartConfig(
		  fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
		  maxFileSize = 1024 * 1024 * 10,      // 10 MB
		  maxRequestSize = 1024 * 1024 * 100   // 100 MB
		)
public class ModificaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher= request.getRequestDispatcher("modificaprofilo.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		SessionSingleton userSession = SessionSingleton.getInstance();
		
		String profession = request.getParameter("profession");
		Integer years =null;
		Integer hours =null;
		Double parcel =null;
		InputStream inputStream= null;
		
        Part filePart = request.getPart("cv");
        if (filePart.getSize() != 0) {
        	inputStream = filePart.getInputStream();
        }
        
		if(!(request.getParameter("years").equals(""))) {
			years =Integer.parseInt(request.getParameter("years"));
		}
		if(!(request.getParameter("hours").equals(""))) {
			hours =Integer.parseInt(request.getParameter("hours"));
		}
		if(!(request.getParameter("parcel").equals(""))) {
			parcel =Double.parseDouble(request.getParameter("parcel"));
		}
		
		UserFactory factory = new UserFactoryImpl();
    	Professionista utente = factory.getType("Professionista");
    	
    	utente.setEmail(userSession.getEmail());
    	utente.setProfession(profession);
    	utente.setYearsExperience(years);
    	utente.setHours(hours);
    	utente.setParcel(parcel);
    	utente.setCv(inputStream);
    	
    	try {
			utente.updateData(utente);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
    	response.sendRedirect("modificaprofilo.jsp");
    	
	}

}
