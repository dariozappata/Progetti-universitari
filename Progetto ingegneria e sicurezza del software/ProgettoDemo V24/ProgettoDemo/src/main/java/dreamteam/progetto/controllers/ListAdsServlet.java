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

@WebServlet("/listads")
public class ListAdsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("listads.jsp");
        dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		UserFactory factory = new UserFactoryImpl();
		Professionista professionista = factory.getType("Professionista");
		
		SessionSingleton userSession = SessionSingleton.getInstance();
		String email= userSession.getEmail();
		
		int idTeam = Integer.parseInt(request.getParameter("button"));
		int idPosizione = Integer.parseInt(request.getParameter("value2"));
		
		try {
			professionista.addMemberFromAds(email, idTeam, idPosizione);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.sendRedirect("homeprofessionista.jsp");
	}

}
