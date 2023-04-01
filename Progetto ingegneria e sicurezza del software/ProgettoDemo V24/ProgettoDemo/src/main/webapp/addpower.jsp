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
<title>Aggiungi poteri</title>
</head>
<body onload="mostra();">
<%if(userSession.getEmail()!=null){ %>

<!-- Barra di navigazione -->

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

<br><br><br>

	<div id="notvisible" hidden="hidden" align="center">
		<h1>Lista membri </h1>
		<table id="myTable">
			<thead>
				<tr class="header">
					<th>Nome</th>
					<th>Cognome</th>
					<th>Professione</th>
					<th>Anni d'esperienza</th>
					<th>Aggiungere</th>
					<th></th>
					<th>Rimuovere</th>
					<th></th>
					<th>Modificare</th>
					<th></th>
					<th>Recensire</th>
					<th></th>
			</thead>
				</tr>
			
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String idTeam = "'" + userSession.getIdTeam() + "'";
					String sql = "SELECT * FROM partecipa, user WHERE partecipa.email=user.email AND idTeam = " + idTeam + " AND partecipa.state=true;";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("profession")%></td>
					<td><%=resultSet.getString("yearsExperience")%></td>
					<td><%=resultSet.getBoolean("adder")%></td>
					<td>
						<form action="<%=request.getContextPath()%>/addpower" method="post">
						<input type="text" hidden="hidden" name="abc" value="<%=resultSet.getString("email")%>"></input>
							<button type="submit" name="choose" value="1" >Cambia</button>
						</form>
					</td>
					<td><%=resultSet.getBoolean("remover")%></td>
					<td>
						<form action="<%=request.getContextPath()%>/addpower" method="post">
						<input type="text" hidden="hidden" name="abc" value="<%=resultSet.getString("email")%>"></input>
							<button type="submit" name="choose" value="2">Cambia</button>
						</form>
					</td>
					<td><%=resultSet.getBoolean("updater")%></td>
					<td>
						<form action="<%=request.getContextPath()%>/addpower" method="post">
						<input type="text" hidden="hidden" name="abc" value="<%=resultSet.getString("email")%>"></input>
							<button type="submit" name="choose" value="3">Cambia</button>
						</form>
					</td>
					<td><%=resultSet.getBoolean("reviewer")%></td>
					<td>
						<form action="<%=request.getContextPath()%>/addpower" method="post">
						<input type="text" hidden="hidden" name="abc" value="<%=resultSet.getString("email")%>"></input>
							<button type="submit" name="choose" value="4">Cambia</button>
						</form>
					</td>
				</tr>
				
				<%
				}
				connection.close();
				} catch (Exception e) {
				e.printStackTrace();
				}
				%>
			</tbody>
		</table>
		<br>
		
		</div>
	<%}
else{ 
	request.setAttribute("notlogged", "notlogged");

	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
    dispatcher.forward(request, response);
 }%>		
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
		  }catch (Exception e) {
				e.printStackTrace();
		  }
		%>	
	}
	
</script>
</body>
</html>