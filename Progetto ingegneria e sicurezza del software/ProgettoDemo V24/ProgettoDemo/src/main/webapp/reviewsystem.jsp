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
<link rel="stylesheet" href="CSS/reviewsystem.css" type="text/css" media="all">
<link rel="stylesheet" href="CSS/myTable.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@700&family=Rubik:wght@500&display=swap" rel="stylesheet">
<title>Inserisci recensione</title>
</head>
<body>
	<%
	if (userSession.getEmail() != null) {
	%>
	
	<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>


	<div align="center">
		<h1>Inserisci recensione</h1>
		
		<form action="<%=request.getContextPath()%>/reviewsystem" method="post">
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
			<label>Descrizione recensione: </label>
			<textarea name="description" cols="35" rows="4" required></textarea>
			<br> <br>
			<button type="submit">Invia</button>
		</form>

	</div>
	
	<div align="center">
	<h1>Recensioni precedenti</h1>
	<table id="myTable">
			<thead>
				<tr>
					<th>Data</th>
					<th>Stelle</th>
					<th>Descrizione</th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM recensioni_Sistema JOIN user ON (user.email=recensioni_Sistema.emailUser) WHERE emailUser = " + email+" ORDER BY id DESC;";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getDate("date")%></td>
					<td><%=resultSet.getInt("star")%></td>
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
		<br>
	</div>
	
	
	<%
	} else {
	request.setAttribute("notlogged", "notlogged");

	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
	dispatcher.forward(request, response);
	}
	%>
	

</body>
</html>
