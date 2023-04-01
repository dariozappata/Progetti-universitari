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
<style><%@include file="/CSS/contactmember.css"%></style>
<title>Offerta</title>
<style>
textarea {
  resize: none;
  display: block;
    height: 50px;
    width: 100%;
    background-color: rgba(255,255,255,0.07);
    border-radius: 3px;
    padding: 0 10px;
    margin-top: 8px;
    font-size: 14px;
    font-weight: 300;
}</style>
</head>
<body onload="mostra();" >
<%if(userSession.getEmail()!=null){ %>

<div align="center">
		<form class="nav_form" action="<%=request.getContextPath()%>/homegestore" method="get">
			<button type="submit">Torna ad Home Gestore</button>
		</form>
		<form class="nav_form" action="<%=request.getContextPath()%>/logout" method="get">
			<button type="submit">Logout</button>
		</form>
</div>

<div id="notvisible" hidden="hidden">
	<form class="reg" action="<%=request.getContextPath()%>/contactmember" method="post">
		<h3>Offerta</h3>
		<br> 
		<label>Testo: </label>
		<textarea name="description" cols="35" rows="4"></textarea>
		<br> 
		<label>Parcella: </label> 
		<input class="in" type="number" min="0" step="any" name="parcel" required/>  <br> 
		<label>Ore di lavoro stimate: </label> 
		<input class="in" type="number" min="0" name="estimatedDuration" required /> <br> 
		<button type="submit" class="btn btn-primary">Invia</button>



	</form>
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
				String email = "'" + userSession.getEmail() + "'";
				String sql = "SELECT emailFounder FROM team WHERE id = " + TeamVisual;
				String sql2="SELECT adder FROM partecipa WHERE idTeam= "+ TeamVisual +" AND email= "+email+";";
				String aus1= null;
				boolean aus2= false;
				resultSet = statement.executeQuery(sql);
				if(resultSet.next()){
					aus1=resultSet.getString("emailFounder");
				}
				resultSet = statement.executeQuery(sql2);
				if(resultSet.next()){
					aus2=resultSet.getBoolean("adder");
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
			  } catch (Exception e) {
					e.printStackTrace();
				}
			%>	
		}
		
	</script>
</body>
</html>