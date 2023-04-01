package dreamteam.progetto.controllers;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dreamteam.progetto.model.Gestore;
import dreamteam.progetto.model.Review;
import dreamteam.progetto.model.UserFactory;
import dreamteam.progetto.model.UserFactoryImpl;

@WebServlet("/reviewteam")
public class ReviewTeamServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("reviewteam.jsp");
        dispatcher.forward(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		Review review= new Review();
		review.setEmailUser(request.getParameterValues("email[]"));
		review.setDescription(request.getParameterValues("description[]"));
		review.setStar(Arrays.stream(request.getParameterValues("star[]")).mapToInt(Integer::parseInt).toArray());
		review.setAvailability(Arrays.stream(request.getParameterValues("availability[]")).mapToInt(Integer::parseInt).toArray());
		review.setProfessionalism(Arrays.stream(request.getParameterValues("professionalism[]")).mapToInt(Integer::parseInt).toArray());
		review.setBehaviour(Arrays.stream(request.getParameterValues("behaviour[]")).mapToInt(Integer::parseInt).toArray());
		
		UserFactory factory = new UserFactoryImpl();
		Gestore gestore = factory.getType("Gestore");
		
		
		try {
			gestore.reviewTeam(review);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("homegestore.jsp");
	}

}
