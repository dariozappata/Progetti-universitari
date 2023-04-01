package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.model.Professionista;
import dreamteam.progetto.model.SessionSingleton;
import dreamteam.progetto.model.UserFactory;
import dreamteam.progetto.model.UserFactoryImpl;

@WebServlet("/offersreceived")
public class OffersPServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Professionista professionista;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		RequestDispatcher dispatcher= request.getRequestDispatcher("offersreceived.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		UserFactory factory = new UserFactoryImpl();
		professionista = factory.getType("Professionista");
		
		int value= Integer.parseInt(request.getParameter("button"));
		int idTeam=Integer.parseInt(request.getParameter("idTeam"));
		SessionSingleton userSession = SessionSingleton.getInstance();
		String email=userSession.getEmail();
		
		if(value==1) {
			try {
				professionista.acceptOffer(idTeam,email);
			} catch (Exception e) {
				e.printStackTrace();
				request.getSession().setAttribute("errore", "errore");
				
			}
		}
		
		
		try {
			professionista.deleteOffer(idTeam,email);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("offersreceived.jsp");
	}

}
