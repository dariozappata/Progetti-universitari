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
<link rel="stylesheet" href="CSS/teamview.css">
<link rel="stylesheet" href="CSS/myTable.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500&display=swap" rel="stylesheet">


<html>
<head>
<meta charset="ISO-8859-1">
<title>Offerte ricevute</title>
</head>
<body>
<%if(userSession.getEmail()!=null){ %>

<% String a=String.valueOf(request.getSession().getAttribute("errore"));
if(a!=null && a.equals("errore")){%> 
<script>alert("Ore non sufficienti!");</script>
<%request.getSession().setAttribute("errore",null);	}%> 

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath()%>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

<br><br><br>
<div align="center">
	<h1>Lista offerte ricevute</h1>
	<br>
	<table>
				<thead>
				<tr>
					<th>Nome team</th>
					<th>Nome gestore</th>
					<th>Cognome gestore</th>
					<th>Categoria</th>
					<th>Grandezza</th>
					<th></th>
					<th>Parcella</th>
					<th>Ore di lavoro stimate</th>
					<th>Messaggio</th>
					<th></th>
				</tr>
				</thead>
		
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT idTeam, nameTeam, g.firstName, g.lastName, category, largeness, contatta.parcel, contatta.estimatedDuration, contatta.description "+
							"FROM contatta, team, user AS p, user AS g "+
							"WHERE contatta.idTeam=team.id AND p.email=contatta.emailProfession AND g.email=team.emailFounder AND  p.email = "+ email;
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td></td>
					<td><%=resultSet.getDouble("parcel")%></td>
					<td><%=resultSet.getInt("estimatedDuration")%></td>
					<td><%=resultSet.getString("description")%></td>
					<td>
						<%-- <form action="<%=request.getContextPath() %>/contactmember" method="get">
							<button name="button" value="<%=resultSet.getString("email")%>" type="submit">Contatta</button>
						</form> --%>
					</td>
				</tr>
				
				<tr>
					<td>
						<form action="<%=request.getContextPath() %>/offersreceived" method="post">
							<button name="button" value="1" type="submit">Accetta</button>
							<input type="hidden" name="idTeam" value="<%= resultSet.getInt("idTeam")%>" />					 
					</td>
					<td>
							<button name="button" value="2" type="submit">Rifiuta</button>
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