<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dreamteam.progetto.model.SessionSingleton"%>
<%@ page import="dreamteam.progetto.database.UserDao"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
UserDao userDao = new UserDao();
try {
	Class.forName(userDao.getDriver());
} catch (ClassNotFoundException e) {
	e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
ResultSet resultSet = null;

SessionSingleton userSession = SessionSingleton.getInstance();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="CSS/reviewsystem.css">
<title>Inserisci recensione gestore</title>
</head>
<body onload="mostra();">
	<%
	if (userSession.getEmail() != null) {
	%>
	
		<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath()%>/teamview" method="get">Torna indietro</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>
	

	<div align="center" hidden="hidden" id="notvisible">
		<h1>Recensisci gestore</h1>
		
		<form action="<%=request.getContextPath()%>/reviewfounder" method="post">
			<label>Stelle: </label> 
			
			<div class="rate">
			&emsp;&emsp;&emsp;
    			<input type="radio" id="star5" name="star" value="5" />
    			<label for="star5">&#9733;</label>
			    <input type="radio" id="star4" name="star" value="4" />
			    <label for="star4" >&#9733; </label>
			    <input type="radio" id="star3" name="star" value="3" />
			    <label for="star3" >&#9733; </label>
			    <input type="radio" id="star2" name="star" value="2" />
			    <label for="star2" >&#9733;</label>
			    <input type="radio" id="star1" name="star" value="1" />
			    <label for="star1" >&#9733; </label>
  			</div>
			
			<br> <br>
			<label>Disponibilit&agrave;: </label> <input type="number" name="availability" min="0" max="5" required/> <br> <br>
			<label>Professionalit&agrave;: </label> <input type="number" name="professionalism" min="0" max="5" required/> <br> <br>
			<label>Condotta: </label> <input type="number" name="behaviour" min="0" max="5" required /> <br> <br>
			<label>Descrizione recensione: </label><br>
			<textarea name="description" cols="35" rows="4" required></textarea>
			<br> <br>
			<button type="submit">Invia</button>
		</form>
	</div>
		
	<%
	} else {
	request.setAttribute("notlogged", "notlogged");

	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
	dispatcher.forward(request, response);
	}
	%>
	
	<script>
	function mostra() {
		<%
		try{
			connection = DriverManager.getConnection(userDao.getJdbcURL(),userDao.getDbUser(), userDao.getDbPassword());
			statement = connection.createStatement();
			String TeamVisual = "'" + userSession.getIdTeam() + "'";
			String email = "'" + userSession.getEmail() + "'";
			String sql = "SELECT emailFounder FROM team WHERE id = " + TeamVisual;
			String aus1= null;
			resultSet = statement.executeQuery(sql);
			if(resultSet.next()){
				aus1=resultSet.getString("emailFounder");
			}
			if (!(userSession.getEmail().equalsIgnoreCase(aus1))) {
			%>
				document.getElementById("notvisible").hidden=false;
					
			<%
			} else {
			%>
				alert("Spiecenti, non hai accesso a questa funzionalità.");
					
			<%
			}
			connection.close();
		  } catch (Exception e) {
				e.printStackTrace();
			}
		%>	
	}
	</script>
	

</body>
</html>
