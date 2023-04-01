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
<style><%@include file="CSS/homegestore.css"%></style>
<style><%@include file="CSS/myTable.css"%></style>
<head>
<meta charset="ISO-8859-1">
<title>Professionista</title>

</head>
<body>
<%if(userSession.getEmail()!=null){ %>

<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath()%>/offersreceived" method="get">Offerte Ricevute</a>
  <a href="#popup1">Teams</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

<!-- Popup con le tabelle -->

<div id="popup2" class="overlay">
	<div class="popup">
	    <a class="cancel" href="#"></a>
		<div class="content">
<h1>Lista offerte ricevute</h1>
	
	<table id="myTable">
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
				</tr>
		
			
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
					
				</tr>
				
				<tr>
					<td>
						<form action="<%=request.getContextPath() %>/offersreceived" method="post"> 
							<button name="button" value="1" type="submit">Accetta</button>
							<input type="hidden" name="idTeam" value="<%= resultSet.getInt("idTeam")%>" ></input>				 
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
			
		</div>
	</div>
</div>


<div id="popup1" class="overlay">
	<div class="popup">
	    <a class="cancel" href="#"></a>
		<div class="content">
			<h1>Teams</h1>
	<table id="myTable">
			<thead>
				<tr>
					<th>Stato</th>
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
					String sql = "SELECT * FROM team, partecipa WHERE id=idTeam and email = " + email + "AND partecipa.state=true";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getBoolean("state")%></td>
					<td><%=resultSet.getString("nameTeam")%></td>
					<td><%=resultSet.getString("category")%></td>
					<td><%=resultSet.getString("largeness")%></td>
					<td><%=resultSet.getString("estimatedDuration")%></td>
					<td>
						<form action="<%=request.getContextPath() %>/teamview" method="get">
							<button name="idTeam" value="<%=resultSet.getInt("id")%>" type="submit">Visualizza</button>
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

	
<!-- Contenuto homepage -->

<div align="center">
<form action="<%=request.getContextPath()%>/homeuser" method="get">
  <button name="button" value="<%=userSession.getEmail()%>" type="submit">Visualizza profilo</button>
  </form>
</div>
 
  <div class="header">
  	<p><%=userSession.getEmail() %></p>
    <h1>Benvenuto nella</h1>
    <h1>Home Professionista</h1>

    <p>Da qui potrai modificare il tuo profilo, viualizzare i team di cui fai parte e le offerte ricevute, o passare alla modalità Gestore.</p>
  </div>
  <div class="row1-container">
    <div class="box box-down cyan">
      <h2><a href="<%=request.getContextPath()%>/userlist" method="get">Ricerca</a></h2>
      <p>Ricerca altri utenti!</p>
      <img src="https://assets.codepen.io/2301174/icon-supervisor.svg" alt="">
    </div>

    <div class="box red">
      <h2><a href="<%=request.getContextPath()%>/listads" method="get">Bacheca</a></h2>
      <p>Visualizza la tua bacheca!</p>
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