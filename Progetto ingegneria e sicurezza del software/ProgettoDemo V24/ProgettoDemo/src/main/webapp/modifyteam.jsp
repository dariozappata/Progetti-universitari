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
<link rel="stylesheet" href="CSS/modifyteam.css">
<link rel="stylesheet" href="CSS/myTable.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap"
    rel="stylesheet">
<title>Modifica informazioni</title>
</head>
<body onload="mostra();">
	<%
	if (userSession.getEmail() != null) {
	%>
	
	<!-- Barra di navigazione -->

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>
	


	<div id="notvisible" hidden="hidden" align="center">
		<h1>Informazioni team</h1>
		<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th>Durata stimata</th>
					<th>Descrizione</th>			
					<th>Nome gestore</th>
					<th>Cognome gestore</th>
					<th>Stato</th>
					<th></th>

				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String idTeam = "'" + userSession.getIdTeam() + "'";
					String sql = "SELECT * FROM team JOIN user on (team.emailFounder=user.email) WHERE id = " + idTeam;
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td><%=resultSet.getString("estimatedDuration")%></td>
					<td><%=resultSet.getString("description")%></td>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("state")%></td>
					<td>
					<form action="<%=request.getContextPath()%>/homegestore" method="post">
						<button type="submit" id="notvisible2" hidden="hidden">Chiudi team</button>
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
	<br>
	<br>
		<h1>Modifica dati</h1>
		<form action="<%=request.getContextPath()%>/modifyteam" method="post">
			<label>Nome: </label> <input type="text" name="name" /> <br> <br>
			<label>Categoria: </label> <input type="text" name="category" /> <br>
			<br> <label>Grandezza: </label> <input type="text"
				name="largeness" /> <br> <br> <label>Durata
				stimata: </label> <input type="text" name="estimatedDuration" /> <br> <br>
			<label>Descrizione: </label>
			<textarea name="description" cols="35" rows="4"></textarea>
			<br> <br>
			<button type="submit">Aggiorna</button>
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
			String sql2="SELECT updater FROM partecipa WHERE idTeam= "+ TeamVisual +" AND email= "+email+";";
			String aus1= null;
			boolean aus2= false;
			resultSet = statement.executeQuery(sql);
			if(resultSet.next()){
				aus1=resultSet.getString("emailFounder");
			}
			resultSet = statement.executeQuery(sql2);
			if(resultSet.next()){
				aus2=resultSet.getBoolean("updater");
			}
			if((userSession.getEmail().equalsIgnoreCase(aus1))){
			%>
				document.getElementById("notvisible2").hidden=false;
			<%
			}
		
			if ((userSession.getEmail().equalsIgnoreCase(aus1)) || (aus2)) {
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
