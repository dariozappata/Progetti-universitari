package dreamteam.progetto.controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dreamteam.progetto.model.Professionista;

import dreamteam.progetto.model.UserFactory;
import dreamteam.progetto.model.UserFactoryImpl;

@WebServlet("/reviewfounder")
public class ReviewFounderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.getSession().setAttribute("email", request.getParameter("reviewfounder"));
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("reviewfounder.jsp");
        dispatcher.forward(request, response);
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email=(String) request.getSession().getAttribute("email");
		int star= Integer.parseInt(request.getParameter("star"));
		int availability= Integer.parseInt(request.getParameter("availability"));
		int professionalism= Integer.parseInt(request.getParameter("professionalism"));
		int behaviour= Integer.parseInt(request.getParameter("behaviour"));
		String description= request.getParameter("description");
		
		try {
			UserFactory factory = new UserFactoryImpl();
			Professionista professionista = factory.getType("Professionista");
			professionista.reviewFounder(email,star,availability,professionalism,behaviour,description);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.sendRedirect("teamview.jsp");
	}

}
