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
<title>Inserisci recensione team</title>
</head>
<body onload="mostra();">
	<%
	if (userSession.getEmail() != null) {
	%>

	<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>


	<div align="center" hidden="hidden" id="notvisible">
		<h1>Recensisci membri</h1>
		<%
			try {
				connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
				statement = connection.createStatement();
				int idTeam =userSession.getIdTeam();
				String sql = "SELECT * FROM team JOIN partecipa ON (partecipa.idTeam=team.id) JOIN user ON (user.email=partecipa.email) WHERE team.id = " + idTeam+" ;";
				resultSet = statement.executeQuery(sql);
				while (resultSet.next()) {
		%>
		<form action="<%=request.getContextPath()%>/reviewteam" method="post">

			<table>
				<thead>
					<tr>
						<th>Nome</th>
						<th>Cognome</th>
						<th>Professione</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><%=resultSet.getString("firstName")%></td>
						<td><%=resultSet.getString("lastName")%></td>
						<td><%=resultSet.getString("user.profession")%></td>
					</tr>
					</tbody>
			</table>
			<input type="text" hidden="hidden" name="email[]" value=<%=resultSet.getString("user.email")%>></input>
			<br>
			<label>Stelle: </label> <input type="number" name="star[]" min="0" max="5" required/> <br> <br>
			<label>Disponibilit&agrave;: </label> <input type="number" name="availability[]" min="0" max="5" required/> <br> <br>
			<label>Professionalit&agrave;: </label> <input type="number" name="professionalism[]" min="0" max="5" required/> <br> <br>
			<label>Condotta: </label> <input type="number" name="behaviour[]" min="0" max="5" required /> <br> <br>
			<label>Descrizione recensione: </label>
			<textarea name="description[]" cols="35" rows="4" required></textarea>
			<br> <br> <br>
		<%
				}
		%>
				<button type="submit">Invia</button>
				</form>
				<%
				connection.close();
				
				} catch (Exception e) {
				e.printStackTrace();
				}
		%>
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
			String sql = "SELECT emailFounder FROM team WHERE id = " + TeamVisual;
			
			String aus1= null;
			resultSet = statement.executeQuery(sql);
			if(resultSet.next()){
				aus1=resultSet.getString("emailFounder");
			}
			
			if ((userSession.getEmail().equalsIgnoreCase(aus1))) {
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
