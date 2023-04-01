package dreamteam.progetto.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dreamteam.progetto.database.UserDao;
import dreamteam.progetto.model.SessionSingleton;
import dreamteam.progetto.model.User;

@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private UserDao userDao= new UserDao();
  

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher= request.getRequestDispatcher("login.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
        String password = request.getParameter("password");
        String scelta= request.getParameter("modalita");
        
        try {
            User user = userDao.checkLogin(email, password, scelta);
            String destPage = "index.jsp";
             
            if (user != null) {
                SessionSingleton userSession = SessionSingleton.getInstance();
                userSession.setEmail(email);
                if(scelta.equalsIgnoreCase("professionista")) {
                	destPage = "homeprofessionista.jsp";
                }else {
                	destPage = "homegestore.jsp";
                }
                
            } else {
                String message = "email/password errata";
                request.setAttribute("message", message);
            }
       
            response.sendRedirect(destPage);
             
        } catch (SQLException | ClassNotFoundException ex) {
            throw new ServletException(ex);
        }
	}

}
