package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.database.UserDao;
import dreamteam.progetto.model.*;

@WebServlet("/contactmember")
public class ContactMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private String emailUser;
    private UserDao userDao= new UserDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		emailUser=request.getParameter("button");
		RequestDispatcher dispatcher= request.getRequestDispatcher("contactmember.jsp");
		dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Offer offer= new Offer();
		SessionSingleton userSession = SessionSingleton.getInstance();
		offer.setIdTeam(userSession.getIdTeam());
		offer.setDescription(request.getParameter("description"));
		offer.setEmailUser(emailUser);
		offer.setParcel(Double.parseDouble(request.getParameter("parcel")));
		offer.setEstimatedDuration(Integer.parseInt(request.getParameter("estimatedDuration")));
	
		
		try {
			if(userDao.isFounder(userSession.getEmail())) {
				UserFactory factory = new UserFactoryImpl();
				Gestore gestore = factory.getType("Gestore");
				gestore.contactUser(offer);
			}else {
				Component professionista= new Professionista();
				professionista= new AdderProfessional(professionista);
				professionista.contactUser(offer);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("teamview.jsp");
	}

}
