package dreamteam.progetto.controllers;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.model.*;

@WebServlet("/createads")
public class CreateAdsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("createads.jsp");
        dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Advertisement ads= new Advertisement();
		SessionSingleton userSession = SessionSingleton.getInstance();
		ads.setIdTeam(userSession.getIdTeam());
		ads.setDescription(request.getParameter("description"));
		ads.setProfession(request.getParameterValues("profession[]"));
		ads.setDuration(Arrays.stream(request.getParameterValues("duration[]")).mapToInt(Integer::parseInt).toArray());
		ads.setParcel(Arrays.stream(request.getParameterValues("parcel[]")).mapToDouble(Double::parseDouble).toArray());
		
		UserFactory factory = new UserFactoryImpl();
		Gestore gestore = factory.getType("Gestore");
		
		try {
			gestore.createAds(ads);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("homegestore.jsp");
	}

}
