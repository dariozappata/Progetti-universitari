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

@WebServlet("/teamview")
public class TeamViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private UserDao userDao= new UserDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		SessionSingleton userSession = SessionSingleton.getInstance();
        userSession.setIdTeam(Integer.parseInt(request.getParameter("idTeam")));
		RequestDispatcher dispatcher = request.getRequestDispatcher("teamview.jsp");
        dispatcher.forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		SessionSingleton userSession= SessionSingleton.getInstance();
		int idTeam=userSession.getIdTeam();
		String email= request.getParameter("buttonremove");
		try {
			if(userDao.isFounder(userSession.getEmail())) {
				UserFactory factory = new UserFactoryImpl();
				Gestore gestore = factory.getType("Gestore");
				gestore.removeUser(idTeam, email);
			}else {
				Component professionista= new Professionista();
				professionista= new RemoverProfessional(professionista);
				professionista.removeUser(idTeam, email);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.sendRedirect("teamview.jsp");
		
	}

}
