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
<link rel="stylesheet" href="CSS/homeuser.css">
<link rel="stylesheet" href="CSS/myTable.css">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@700&family=Rubik:wght@500&display=swap" rel="stylesheet">
<link
    href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap"
    rel="stylesheet">
<title>Ricerca</title>



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

	<br><br><br>
	<div align="center">
		<h1>Lista utenti</h1>
		<input type="text" id="myInput" onkeyup="lista()" placeholder="Cerca"
			title="Filtra">

		<table id="myTable">
			<thead>
			<tr class="header">
				<th>Nome e cognome</th>
				<th>Professione</th>
				<th>Anni d'esperienza</th>
				<th>Parcella</th>
				<th>Ore disponibili</th>
				<th></th>
			</tr>
			</thead>
			<tbody>			<%
			try {
				connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
				statement = connection.createStatement();
				String email = "'" + userSession.getEmail() + "'";
				String idTeam = "'" + userSession.getIdTeam() + "'";
				String sql = "SELECT * FROM user WHERE email <> " + email;
				resultSet = statement.executeQuery(sql);
				while (resultSet.next()) {
			%>
			<tr>
				<td><%=resultSet.getString("firstName") + " " + resultSet.getString("lastName")%></td>
				<td><%=resultSet.getString("profession")%></td>
				<td><%=resultSet.getInt("yearsExperience")%></td>
				<td><%=resultSet.getDouble("parcel")%></td>
				<td><%=resultSet.getInt("hours")%></td>
				<td>
					<form action="<%=request.getContextPath()%>/homeuser" method="get">
						<button name="button" value ="<%=resultSet.getString("email")%>" type="submit">Visualizza</button>
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
	<%
	} else {
	request.setAttribute("notlogged", "notlogged");
	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
	dispatcher.forward(request, response);
	}
	%>



	<script>
		function lista() {
			var input, filter, table, tr, td, i, txtValue;
			input = document.getElementById("myInput");
			filter = input.value.toUpperCase();
			table = document.getElementById("myTable");
			tr = table.getElementsByTagName("tr");
			for (i = 0; i < tr.length; i++) {
				// td = tr[i].getElementsByTagName("td")[0];
				alltags = tr[i].getElementsByTagName("td");
				isFound = false;
				for (j = 0; j < alltags.length; j++) {
					td = alltags[j];
					if (td) {
						txtValue = td.textContent || td.innerText;
						if (txtValue.toUpperCase().indexOf(filter) > -1) {
							tr[i].style.display = "";
							j = alltags.length;
							isFound = true;
						}
					}
				}
				if (!isFound && tr[i].className !== "header") {
					tr[i].style.display = "none";
				}
			}
		}
	</script>




</body>
</html>