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
<title>Lista membri</title>
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
	<h1>Lista professionisti</h1>
	<br>
	<form autocomplete="off">
	<div class="autocomplete"> 
	<input type="text" id="myInput" name="profession" onkeyup="lista()" placeholder="Cerca per professione" title="Filtra per professione">
	</div>
	</form>
	<table id="myTable">
			
			<thead>
				<tr>
					<th>Nome</th>
					<th>Cognome</th>
					<th>Professione</th>
					<th>Anni d'esperienza</th>
					<th>Parcella</th>
					<th>Ore disponibili</th>
					<th></th>
				</tr>
				</thead>
		<tbody>
			
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String idTeam = "'" + userSession.getIdTeam() + "'";
					String sql = "SELECT * FROM user WHERE email <> "+email+" AND email NOT IN (SELECT user.email FROM user JOIN partecipa ON (user.email=partecipa.email) WHERE idTeam = "+ idTeam +" AND partecipa.state= true ) AND email NOT IN (SELECT user.email FROM user JOIN team on (user.email=team.emailFounder) WHERE id = "+ idTeam +") ORDER BY user.yearsExperience DESC";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getString("profession")%></td>
					<td><%=resultSet.getInt("yearsExperience")%></td>
					<td><%=resultSet.getDouble("parcel")%></td>
					<td><%=resultSet.getInt("hours")%></td>
					<td>
						<form action="<%=request.getContextPath() %>/contactmember" method="get">
							<button name="button" value="<%=resultSet.getString("email")%>" type="submit">Contatta</button>
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
		function lista() {
			var input, filter, table, tr, td, i, txtValue;
			input = document.getElementById("myInput");
			filter = input.value.toUpperCase();
			table = document.getElementById("myTable");
			tr = table.getElementsByTagName("tr");
			for (i = 0; i < tr.length; i++) {
				td = tr[i].getElementsByTagName("td")[2];
				if (td) {
					txtValue = td.textContent || td.innerText;
					if (txtValue.toUpperCase().indexOf(filter) > -1) {
						tr[i].style.display = "";
					} else {
						tr[i].style.display = "none";
					}
				}
			}
		}
		
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
					alert("Spiacenti, non hai accesso a questa funzionalità.");
						
				<%
				}
				connection.close();
			  } catch (Exception e) {
					e.printStackTrace();
				}
			%>	
		}
		
		function autocomplete(inp, arr) {
			  var currentFocus;
			  inp.addEventListener("input", function(e) {
			      var a, b, i, val = this.value;
			      closeAllLists();
			      if (!val) { return false;}
			      currentFocus = -1;
			      a = document.createElement("DIV");
			      a.setAttribute("id", this.id + "autocomplete-list");
			      a.setAttribute("class", "autocomplete-items");
			      this.parentNode.appendChild(a);
			      for (i = 0; i < arr.length; i++) {
			        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
			          b = document.createElement("DIV");
			          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
			          b.innerHTML += arr[i].substr(val.length);
			          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
			          b.addEventListener("click", function(e) {
			              inp.value = this.getElementsByTagName("input")[0].value;
			              closeAllLists();
			          });
			          a.appendChild(b);
			        }
			      }
			  });
			  
			  inp.addEventListener("keydown", function(e) {
			      var x = document.getElementById(this.id + "autocomplete-list");
			      if (x) x = x.getElementsByTagName("div");
			      if (e.keyCode == 40) {
			        currentFocus++;
			        addActive(x);
			      } else if (e.keyCode == 38) { 
			        currentFocus--;
			        addActive(x);
			      } else if (e.keyCode == 13) {
			        e.preventDefault();
			        if (currentFocus > -1) {
			          if (x) x[currentFocus].click();
			        }
			      }
			  });
			  function addActive(x) {
			    if (!x) return false;
			    removeActive(x);
			    if (currentFocus >= x.length) currentFocus = 0;
			    if (currentFocus < 0) currentFocus = (x.length - 1);
			    x[currentFocus].classList.add("autocomplete-active");
			  }
			  function removeActive(x) {
			    for (var i = 0; i < x.length; i++) {
			      x[i].classList.remove("autocomplete-active");
			    }
			  }
			  function closeAllLists(elmnt) {
			    var x = document.getElementsByClassName("autocomplete-items");
			    for (var i = 0; i < x.length; i++) {
			      if (elmnt != x[i] && elmnt != inp) {
			        x[i].parentNode.removeChild(x[i]);
			      }
			    }
			  }
			  document.addEventListener("click", function (e) {
			      closeAllLists(e.target);
			  });
			}

			var profession=[];
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String sql = "SELECT * FROM professioni ;";
					resultSet = statement.executeQuery(sql);
					while (resultSet.next()){
						%>profession.push("<%=resultSet.getString("profession")%>");
						<% 
					}
				connection.close();
				} catch (Exception e) {
				e.printStackTrace();
				}%>
				
			autocomplete(document.getElementById("myInput"), profession);
		
	</script>


</body>
</html>