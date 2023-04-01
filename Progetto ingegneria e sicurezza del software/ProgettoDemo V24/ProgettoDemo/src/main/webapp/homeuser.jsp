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
<title>Utente</title>
<script type="text/javascript" src="/webjars/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/webjars/bootstrap/js/bootstrap.min.js"></script>

</head>
<body onload="mostra();">


<%if(userSession.getEmail()!=null){ %>

<div class="back"></div>
<nav>
  <a href="#popup2">Info utente</a>
  <a href="<%=request.getContextPath()%>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>



<div id="popup2" class="overlay">
	<div class="popup">
	    <a class="cancel" href="#"></a>
		<div class="content">
			<h1>Info utente</h1>
			<h1>Informazioni utente</h1>
	<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Cognome</th>
					<th>Professione</th>
					<th>Anni d'esperienza</th>
					<th>Ore disponibili</th>
					<th>Parcella</th>
				</tr>
				</thead>
			<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = (String) request.getSession().getAttribute("emailSelected");
					String sql = "SELECT * FROM user WHERE email = '" + email +"' ;";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("profession")%></td>
					<td><%=resultSet.getString("yearsExperience")%></td>
					<td><%=resultSet.getString("hours")%></td>
					<td><%=resultSet.getString("parcel")%></td>
				</tr>
				
			</tbody>
		</table>	
		</div>
	</div>
</div>
	
	
	
	<div class="header">
  	<p><%=resultSet.getString("email") %></p>
		<%
		}
		connection.close();
		} catch (Exception e) {
		e.printStackTrace();
		}
		%>
		<h1>Benvenuto nella</h1>
    <h1>Homepage Utente</h1>

    <p>Da qui potrai visualizzare lo storico delle attività effettuate.</p>
  </div>



<div class="section-one">
  <h1 class="section-one__title">Professionista</h1>
	
	
	
	<div align="center">

	<h3>Storico Team</h3>
	<table>
			<thead>
				<tr>
					<th>Nome</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th>Stato </th>
				</tr>
				</thead>
			<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = (String) request.getSession().getAttribute("emailSelected");
					String sql = "SELECT * FROM partecipa JOIN team on(idTeam=id) WHERE email = '" + email +"' ORDER BY partecipa.state DESC";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td><%=resultSet.getBoolean("partecipa.state")%></td>
					
					
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
		<br><br>
		<h3>Recensioni</h3>
		<table>
			<thead>
				<tr>
					<th>Stelle</th>
					<th>Disponibilit&agrave;</th>
					<th>Professionalit&agrave;</th>
					<th>Condotta</th>
					<th>Descrizione </th>
				</tr>
				</thead>
			<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = (String) request.getSession().getAttribute("emailSelected");
					String sqlreviewp=null;
					String checkpass= "SELECT premium_pass FROM user WHERE email= '"+ userSession.getEmail()+"' ;";
					resultSet = statement.executeQuery(checkpass);
					if(resultSet.next())
					{
						if(resultSet.getBoolean("premium_pass")){
							sqlreviewp = "SELECT * FROM recensioni_Team WHERE emailUser = '" + email +"' ORDER BY id";
						}
						else{
							sqlreviewp = "SELECT * FROM recensioni_Team WHERE emailUser = '" + email +"' ORDER BY id LIMIT 3";
						}
					}
					resultSet = statement.executeQuery(sqlreviewp);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getInt("star")%></td>
					<td><%=resultSet.getInt("availability")%></td>
					<td><%=resultSet.getInt("professionalism")%></td>
					<td><%=resultSet.getInt("behaviour")%></td>
					<td><%=resultSet.getString("description")%></td>
					
					
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

		<div hidden="hidden" id="notvisible">
			<form action="<%=request.getContextPath()%>/buypass" method="get">
				<button type="submit">Acquista il pass</button>
			</form>
		</div>
	</div>
	
	  <!-- begin Separator -->
  <div class="separator">
    <svg class="separator__svg" width="100%" height="200" viewBox="0 0 100 100" preserveAspectRatio="none" fill="#7db9be" version="1.1" xmlns="http://www.w3.org/2000/svg">
       <path d="M 100 100 V 10 L 0 100"/>
       <path d="M 30 73 L 100 18 V 10 Z" fill="#5aa1a8" stroke-width="0"/>
      </svg>
  </div>
  <!-- end Separator -->
</div>

<div class="section-two">
  <h1 class="section-two__title">Gestore</h1>

	
	<div align="center">
	<h3>Team gestiti</h3>
	<table>
			<thead>
				<tr>
					<th>Nome</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th>Stato </th>
				</tr>
			</thead>
			<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = (String) request.getSession().getAttribute("emailSelected");
					String sql = "SELECT * FROM team WHERE emailFounder = '" + email +"' ORDER BY state DESC";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td><%=resultSet.getBoolean("state")%></td>
					
					
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
		<br><br>
		<h3>Recensioni</h3>
		<table>
			<thead>
				<tr>
					<th>Stelle</th>
					<th>Disponibilit&agrave;</th>
					<th>Professionalit&agrave;</th>
					<th>Condotta</th>
					<th>Descrizione </th>
				</tr>
				</thead>
			<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = (String) request.getSession().getAttribute("emailSelected");
					String sqlreviewg=null;
					String checkpass= "SELECT premium_pass FROM user WHERE email= '"+ userSession.getEmail()+"' ;";
					resultSet = statement.executeQuery(checkpass);
					if(resultSet.next())
					{
						if(resultSet.getBoolean("premium_pass")){
							sqlreviewg = "SELECT * FROM recensioni_gestore WHERE emailUser = '" + email +"' ORDER BY id";
						}
						else{
							sqlreviewg = "SELECT * FROM recensioni_gestore WHERE emailUser = '" + email +"' ORDER BY id LIMIT 3";
						}
					}
					resultSet = statement.executeQuery(sqlreviewg);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getInt("star")%></td>
					<td><%=resultSet.getInt("availability")%></td>
					<td><%=resultSet.getInt("professionalism")%></td>
					<td><%=resultSet.getInt("behaviour")%></td>
					<td><%=resultSet.getString("description")%></td>
					
					
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
		<div>
			<form hidden="hidden" id="notvisible2" action="<%=request.getContextPath()%>/buypass" method="get">
				<button type="submit">Acquista il pass</button>
			</form>
		</div>
	</div>
	
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
			String email = "'" + userSession.getEmail() + "'";
			String sql = "SELECT premium_pass FROM user WHERE email= "+ email;
			boolean aus1=false;
			boolean aus2=false;
			resultSet = statement.executeQuery(sql);
			if(resultSet.next()){
				aus1=resultSet.getBoolean("premium_pass");
			}
			if(email.equalsIgnoreCase((String) request.getSession().getAttribute("emailSelected"))){
				aus2=true;
			}
		
			if (aus1 || aus2) {
			%>
				document.getElementById("notvisible").hidden=true;
				document.getElementById("notvisible2").hidden=true;
					
			<%
			} else {
			%>
			document.getElementById("notvisible").hidden=false;
			document.getElementById("notvisible2").hidden=false;
					
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