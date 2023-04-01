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
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@700&family=Rubik:wght@500&display=swap" rel="stylesheet">
<style><%@include file="/CSS/homegestore.css"%></style>
<style><%@include file="/CSS/myTable.css"%></style>
<meta charset="ISO-8859-1">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="icon" type="image/png" sizes="32x32" href="./images/favicon-32x32.png">
  <link
    href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap"
    rel="stylesheet">
    <title>Gestore</title>
</head>

<body>

<%if(userSession.getEmail()!=null){ %>

<!-- Barra di navigazione -->

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="#popup2">Team Gestiti</a>
  <a href="#popup1">Team Chiusi</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

  
  
<div id="popup2" class="overlay">
	<div class="popup">
	    <a class="cancel" href="#"></a>
		<div class="content">
			<h1>Team gestiti</h1>
	<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th>Durata stimata</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM team WHERE emailFounder = " + email +" AND state=true";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td><%=resultSet.getString("estimatedDuration")%></td>
					<td>
						<form action="<%=request.getContextPath() %>/teamview" method="get">
							<button name="idTeam" value="<%=resultSet.getInt("id")%>" type="submit">Gestisci</button>
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
			
		</div>
	</div>
</div>

<div id="popup1" class="overlay">
	<div class="popup">
	    <a class="cancel" href="#"></a>
		<div class="content">
			<h1>Team Chiusi</h1>

	<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Categoria</th>
					<th>Grandezza</th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM team WHERE emailFounder = " + email +" AND state=false";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
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
			
		</div>
	</div>
</div>

<!-- Contenuto homepage -->

	<div align="center">
	<form action="<%=request.getContextPath()%>/homeuser" method="get">
	<button name="button" value="<%=userSession.getEmail()%>" type="submit"> Visualizza profilo</button>
	</form>
	</div>
 
    <div class="header">
  	<p><%=userSession.getEmail() %></p>
    <h1>Benvenuto nella</h1>
    <h1>Home Gestore</h1>

    <p>Da qui potrai modificare il tuo profilo e i teams da te
      gestiti, o passare alla modalità Professionista.</p>
  </div>
  <div class="row1-container">
    <div class="box box-down cyan">
      <h2><a href="<%=request.getContextPath()%>/userlist" method="get">Ricerca</a></h2>
      <p>Ricerca altri utenti!</p>
      <img src="https://assets.codepen.io/2301174/icon-supervisor.svg" alt="">
    </div>

    <div class="box red">
      <h2><a href="<%=request.getContextPath()%>/createteam" method="get">Crea team</a></h2>
      <p>Crea e gestisci il tuo nuovo team!</p>
      <img src="https://assets.codepen.io/2301174/icon-team-builder.svg" alt="">
    </div>

    <div class="box box-down blue">
      <h2><a href="<%=request.getContextPath() %>/reviewsystem" method="get">Recensioni</a></h2>
     <p>Recensisci il sistema!</p>
      <img src="https://assets.codepen.io/2301174/icon-calculator.svg" alt="">
    </div>
  </div>
  <div class="row2-container">
    <div class="box orange">
      <h2><a href="<%=request.getContextPath() %>/modificaprofilo" method="get">Modifica dati</a></h2>
      <p>Modifica il tuo profilo!</p>
      <img src="https://assets.codepen.io/2301174/icon-karma.svg" alt="">
    </div>
  </div>

	
	<%}
else{ 
	request.setAttribute("notlogged", "notlogged");
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
    dispatcher.forward(request, response);
 }%>
 
 
 
</body>
</html>