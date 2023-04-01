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


@WebServlet("/modifyteam")
public class ModifyTeamServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private UserDao userDao= new UserDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher= request.getRequestDispatcher("modifyteam.jsp");
		dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		SessionSingleton userSession = SessionSingleton.getInstance();
		Team team= new Team();
		team.setID(userSession.getIdTeam());
		team.setNameTeam(request.getParameter("name"));
		team.setCategory(request.getParameter("category"));
		team.setLargeness(request.getParameter("largeness"));
		team.setEstimatedDuration(request.getParameter("estimatedDuration"));
		team.setDescription(request.getParameter("description"));
		
		try {
			if(userDao.isFounder(userSession.getEmail())) {
				UserFactory factory = new UserFactoryImpl();
				Gestore gestore = factory.getType("Gestore");
				gestore.updateInfoTeam(team);
			}else {
				Component professionista= new Professionista();
				professionista= new UpdaterProfessional(professionista);
				professionista.updateInfoTeam(team);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		response.sendRedirect("modifyteam.jsp");

	}

}