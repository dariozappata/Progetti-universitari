package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.model.*;


@WebServlet("/createteam")
public class TeamServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Gestore gestore;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		RequestDispatcher dispatcher= request.getRequestDispatcher("createteam.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserFactory factory = new UserFactoryImpl();
		gestore = factory.getType("Gestore");
		
		SessionSingleton sessione =  SessionSingleton.getInstance();
		String email = sessione.getEmail();
		
		String nameTeam = request.getParameter("nameTeam");
		String description = request.getParameter("description");
		String category = request.getParameter("category");
		String largeness = request.getParameter("largeness");
		String estimatedDuration = request.getParameter("estimatedDuration");
		
		Team team = new Team();
		team.setNameTeam(nameTeam);
		team.setDescription(description);
		team.setCategory(category);
		team.setLargeness(largeness);
		team.setEstimatedDuration(estimatedDuration);
		team.setEmailFounder(email);
		
		try {
			gestore.createTeam(team);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("homegestore.jsp");
	}

}
