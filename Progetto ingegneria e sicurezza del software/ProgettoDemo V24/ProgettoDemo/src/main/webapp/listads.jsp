<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dreamteam.progetto.model.SessionSingleton"%>
<%@ page import="dreamteam.progetto.database.UserDao"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%

UserDao userDao= new UserDao();
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
<link rel="stylesheet" href="CSS/homeuser.css">
<link rel="stylesheet" href="CSS/myTable.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@700&family=Rubik:wght@500&display=swap" rel="stylesheet">
<title>Bacheca</title>
</head>
<body>
<%if(userSession.getEmail()!=null){ %>

<!-- Barra di navigazione -->

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

	<br><br><br>
	<div align="center">
	<h1>Lista annunci</h1>
	<br>
	<table id="myTable">
			<thead>
				<tr>
					<th>Nome Team</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th>Professione</th>
					<th>Ore</th>
					<th>Parcella</th>
					<th>Descrizione</th>
					<th></th>
				</tr>
		</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					int idTeam=0;
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM annuncio, posizione, team, user WHERE annuncio.idTeam=posizione.idTeam AND annuncio.idTeam=team.id AND user.profession=posizione.profession"+
							" AND user.email= "+ email + " AND annuncio.idTeam NOT IN (SELECT user.email FROM user JOIN partecipa ON (user.email=partecipa.email) WHERE user.email= "+ email +
							" AND partecipa.state= true ) AND team.emailFounder <> " + email + " AND user.hours >= posizione.estimatedDuration"+ " AND posizione.state='Disponibile';";
					resultSet = statement.executeQuery(sql);
					
					while (resultSet.next()) {
						
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("team.category")%></td>
					<td><%=resultSet.getString("team.largeness")%></td>
					<td><%=resultSet.getString("posizione.profession")%></td>
					<td><%=resultSet.getInt("posizione.estimatedDuration")%></td>
					<td><%=resultSet.getDouble("posizione.parcel")%></td>
					<td><%=resultSet.getString("annuncio.description")%></td>
					<td>
						<form action="<%=request.getContextPath() %>/listads" method="post">
							<input type="text" name="value2" hidden="hidden" value="<%=resultSet.getInt("posizione.id")%>"></input>
							<button name="button" value="<%=resultSet.getInt("annuncio.idTeam")%>" type="submit">Entra</button>
						</form>
					</td>
				</tr>
				</tbody>
				<%
				}
				connection.close();
				} catch (Exception e) {
				e.printStackTrace();
				}
				%>
			
		</table>
		<br>
	</div>
	<%}
else{ 
	request.setAttribute("notlogged", "notlogged");
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
    dispatcher.forward(request, response);
 }%>

</body>
</html>