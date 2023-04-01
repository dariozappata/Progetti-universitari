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

@WebServlet("/reviewsystem")
public class ReviewSystemServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("reviewsystem.jsp");
        dispatcher.forward(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		UserFactory factory = new UserFactoryImpl();
		Professionista professionista = factory.getType("Professionista");
		
		SessionSingleton userSession = SessionSingleton.getInstance();
		String email = userSession.getEmail();
		
		String description = request.getParameter("description");
		int star = Integer.parseInt(request.getParameter("star"));
		
		try {
			professionista.reviewSystem(email,description,star);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.sendRedirect("reviewsystem.jsp");
	}

}
