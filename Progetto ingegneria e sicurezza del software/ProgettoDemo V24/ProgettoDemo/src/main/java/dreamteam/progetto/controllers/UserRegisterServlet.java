package dreamteam.progetto.controllers;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.springframework.security.crypto.bcrypt.BCrypt;

import dreamteam.progetto.model.*;

@WebServlet("/register")
@MultipartConfig(
		  fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
		  maxFileSize = 1024 * 1024 * 10,      // 10 MB
		  maxRequestSize = 1024 * 1024 * 100   // 100 MB
		)
public class UserRegisterServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher= request.getRequestDispatcher("index.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String email = request.getParameter("email");
		String password = BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt());
		String firstName =request.getParameter("firstName");
		String lastName =request.getParameter("lastName");
		
		InputStream inputStream= null;
        Part filePart = request.getPart("cid");
        if (filePart != null) {
        	inputStream = filePart.getInputStream();
        }
		
		UserFactory factory = new UserFactoryImpl();
    	Professionista utente = factory.getType("Professionista");
    	
		utente.setEmail(email);
		utente.setPassword(password);
		utente.setFirstName(firstName);
		utente.setLastName(lastName);
		utente.setHours(200);
		utente.setCid(inputStream);
		
		try {
			utente.registerUser(utente);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("index.jsp");
	}

}
