package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.database.UserDao;
import dreamteam.progetto.model.Component;
import dreamteam.progetto.model.Gestore;
import dreamteam.progetto.model.Professionista;
import dreamteam.progetto.model.ReviewerProfessional;
import dreamteam.progetto.model.SessionSingleton;
import dreamteam.progetto.model.UserFactory;
import dreamteam.progetto.model.UserFactoryImpl;

@WebServlet("/reviewmember")
public class ReviewMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDao userDao= new UserDao();
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getSession().setAttribute("email", request.getParameter("buttonreview"));
		RequestDispatcher dispatcher = request.getRequestDispatcher("reviewmember.jsp");
        dispatcher.forward(request, response);
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email=(String) request.getSession().getAttribute("email");
		int star= Integer.parseInt(request.getParameter("star"));
		int availability= Integer.parseInt(request.getParameter("availability"));
		int professionalism= Integer.parseInt(request.getParameter("professionalism"));
		int behaviour= Integer.parseInt(request.getParameter("behaviour"));
		String description= request.getParameter("description");
		SessionSingleton userSession= SessionSingleton.getInstance();
		try {
			if(userDao.isFounder(userSession.getEmail())) {
				UserFactory factory = new UserFactoryImpl();
				Gestore gestore = factory.getType("Gestore");
				gestore.reviewMember(email,star,availability,professionalism,behaviour,description);
			}else {
				Component professionista= new Professionista();
				professionista= new ReviewerProfessional(professionista);
				professionista.reviewMember(email,star,availability,professionalism,behaviour,description);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.sendRedirect("teamview.jsp");
	}

}
