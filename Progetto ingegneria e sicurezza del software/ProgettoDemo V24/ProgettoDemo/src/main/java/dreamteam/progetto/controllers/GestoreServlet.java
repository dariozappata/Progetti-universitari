package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.model.Gestore;
import dreamteam.progetto.model.SessionSingleton;
import dreamteam.progetto.model.UserFactory;
import dreamteam.progetto.model.UserFactoryImpl;

@WebServlet("/homegestore")
public class GestoreServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Gestore gestore;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher= request.getRequestDispatcher("homegestore.jsp");
		dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserFactory factory = new UserFactoryImpl();
		gestore = factory.getType("Gestore");
		SessionSingleton userSession = SessionSingleton.getInstance();
		int idTeam=userSession.getIdTeam();
		
		try {
			gestore.closeTeam(idTeam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("reviewteam.jsp");
	}

}
