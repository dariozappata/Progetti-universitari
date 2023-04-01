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
<link rel="stylesheet" href="CSS/teamview.css">
<link
    href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap"
    rel="stylesheet">
   
<title>Gestione team</title>
</head>

<body onload="mostra();">

<%if(userSession.getEmail()!=null){ %>

<div class="back">
<nav>
  <a href="<%=request.getContextPath()%>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>
</div>
				
		<div style="width: 100%;height: 65px;margin-top: 85px;text-align-last: center;">
    
        <form action="http://localhost:8080/ProgettoDemo/createads" method="get">
            <button  hidden="hidden" id="notvisible10" type="submit">Crea annuncio</button>
        </form>

        <form action="http://localhost:8080/ProgettoDemo/addmember" method="get">
            <button  hidden="hidden" id="notvisible" type="submit">Aggiungi membri</button>
        </form>
        
        <form action="http://localhost:8080/ProgettoDemo/modifyteam" method="get">
            <button hidden="hidden" id="notvisible7" type="submit">Modifica informazioni</button>
        </form>
        
        <form action="http://localhost:8080/ProgettoDemo/addpower" method="get">
            <button hidden="hidden" id="notvisible9" type="submit">Modifica poteri</button>
        </form>
    </div>
		
	
	<div align="center">
		<h3>Informazioni team</h3>
	</div>

	<div align="center">
	
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
					<td> 
					<form action="<%=request.getContextPath() %>/reviewfounder" method="get">
						<button hidden="hidden" id="notvisible12" name="reviewfounder" value="<%=resultSet.getString("email") %>" type="submit">Recensisci Gestore</button>
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
		
		<div align="center">
		<h3>Lista membri </h3>
		</div>
		
		<div align="center">
		<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Cognome</th>
					<th>Professione</th>
					<th>Anni d'esperienza</th>
					
					<th></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String idTeam = "'" + userSession.getIdTeam() + "'";
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM partecipa, user WHERE partecipa.email=user.email AND idTeam = " + idTeam +" AND user.email <> "+email+ " AND partecipa.state=true;";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("profession")%></td>
					<td><%=resultSet.getString("yearsExperience")%></td>
					
					<td>
					<form action="<%=request.getContextPath() %>/teamview" method="post">
						<button hidden="hidden" class="notvisible2"  name="buttonremove" value="<%=resultSet.getString("email")%>" type="submit">Rimuovi</button>
					</form>
					</td>
					<td>
					<form action="<%=request.getContextPath() %>/reviewmember" method="get">
						<button hidden="hidden" class="notvisible8" name="buttonreview" value="<%=resultSet.getString("email")%>" type="submit">Recensisci</button>
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
		
	<br><br><br>

	<div align="center">
		<h3>Annuncio</h3>
		<table id="myTable">
			<thead>
				<tr>
					<th>Professione</th>
					<th>Ore</th>
					<th>Parcella</th>
					<th>Stato</th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String idTeam = "'" + userSession.getIdTeam() + "'";
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM team JOIN annuncio ON (team.id=annuncio.idTeam) JOIN posizione ON (team.id=posizione.idTeam) WHERE emailFounder = " + email + 
					" AND team.state=true AND team.id = "+ idTeam + ";";
					resultSet = statement.executeQuery(sql);
					if (resultSet.next()) {
					%>
						<p><%=resultSet.getString("annuncio.description")%></p>
						<form action="<%=request.getContextPath() %>/closeads" method="post">
							<button hidden="hidden" id="notvisible11" name="buttonclose" type="submit">Chiudi annuncio</button>
						</form>
					<% 
					}
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {%>
					<tr>
						<td><%=resultSet.getString("posizione.profession")%></td>
						<td><%=resultSet.getInt("posizione.estimatedDuration")%></td>
						<td><%=resultSet.getDouble("posizione.parcel")%></td>
						<td><%=resultSet.getString("posizione.state")%></td>
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
				String email = "'" + userSession.getEmail() + "'";
				String TeamVisual = "'" + userSession.getIdTeam() + "'";
				String sql = "SELECT emailFounder FROM team WHERE id = " + TeamVisual;
				resultSet = statement.executeQuery(sql);
				String emailFounder=null;
				Boolean adder=false;
				Boolean remover=false;
				Boolean updater=false;
				Boolean reviewer=false;
				if (resultSet.next()) {
					emailFounder= resultSet.getString("emailFounder");
				}
				
				String sql2="SELECT adder, remover, updater, reviewer FROM partecipa WHERE email = " + email + " AND idTeam = " + TeamVisual;
				ResultSet resultSet2 = statement.executeQuery(sql2);
				if (resultSet2.next()){
					adder = resultSet2.getBoolean("adder");
					remover = resultSet2.getBoolean("remover");
					updater = resultSet2.getBoolean("updater");
					reviewer = resultSet2.getBoolean("reviewer");
				}
				 %>document.getElementById("notvisible12").hidden=false;<%
					if(adder){
					%>
						document.getElementById("notvisible").hidden=false;
						<%
					} if(remover){
					%>
						var array=document.getElementsByClassName("notvisible2");
						for (var i = 0; i < array.length; i ++) {
					    	array[i].hidden=false;
						}
						<%
					} if(updater){
					%>
						document.getElementById("notvisible7").hidden=false;
						<%
					} if(reviewer){
					%>
						var array=document.getElementsByClassName("notvisible8");
						for (var i = 0; i < array.length; i ++) {
				    		array[i].hidden=false;
						}
						<%
					} if (userSession.getEmail().equalsIgnoreCase(emailFounder)) {
					%>
					document.getElementById("notvisible12").hidden=true;
					document.getElementById("notvisible10").hidden=false;
					document.getElementById("notvisible").hidden=false;
					var array=document.getElementsByClassName("notvisible2");
					for (var i = 0; i < array.length; i ++) {
					    array[i].hidden=false;
					}
					
					document.getElementById("notvisible7").hidden=false;
					document.getElementById("notvisible9").hidden=false;
					array=document.getElementsByClassName("notvisible8");
					for (var i = 0; i < array.length; i ++) {
					    array[i].hidden=false;
					}
					document.getElementById("notvisible11").hidden=false;
					
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