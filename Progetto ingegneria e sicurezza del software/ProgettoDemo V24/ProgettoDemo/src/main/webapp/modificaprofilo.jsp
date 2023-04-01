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
<link rel="stylesheet" href="CSS/modificaprofilo.css">
<link rel="stylesheet" href="CSS/myTable.css">
<link
    href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,200;0,400;0,600;1,200;1,400;1,600&display=swap"
    rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@700&family=Rubik:wght@500&display=swap" rel="stylesheet">
<meta charset="ISO-8859-1">
<title>Modifica</title>

</head>
<body>
	<%if(userSession.getEmail()!=null){ %>
	
	<div class="back"></div>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>


	<div align="center">
		<h1>Informazioni utente</h1>
	</div>

	<div align="center">
		<table id="myTable">
			<thead>
				<tr>
					<th>Nome</th>
					<th>Cognome</th>
					<th>Ore disponibili</th>
					<th>Professione</th>
					<th>Anni di esperienza</th>
					<th>Parcella</th>
				</tr>
			</thead>
			<tbody>
				<%
				try {
					connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
					statement = connection.createStatement();
					String email = "'" + userSession.getEmail() + "'";
					String sql = "SELECT * FROM user WHERE email = " + email;
					resultSet = statement.executeQuery(sql);
					if (resultSet.next()) {
				%>
				<tr>
					<td><%=resultSet.getString("firstName")%></td>
					<td><%=resultSet.getString("lastName")%></td>
					<td><%=resultSet.getInt("hours")%></td>
					<td><%=resultSet.getString("profession")%></td>
					<td><%=resultSet.getInt("yearsExperience")%></td>
					<td><%=resultSet.getDouble("parcel")%></td>
				</tr>
				
			</tbody>
		</table>
		<br> <br> <br>
		<div>
			<h1>Modifica dati</h1>
			<form autocomplete="off" action="<%=request.getContextPath()%>/modificaprofilo" enctype="multipart/form-data" method="post">
				<label>Professione: </label>
				<div class="autocomplete"> 
				<input id="myInput" type="text" name="profession" />
				</div>
				<br> 
				<br> 
				<label>Anni di esperienza: </label> 
				<input type="number" name="years" min="0"/> 
				<br> 
				<br> 
				<label>Ore disponibili: </label> 
				<input type="number" name="hours" min="0" max="<%=resultSet.getInt("hours")%>"/> 
				<br> 
				<br> 
				<label>Parcella: </label> 
				<input type="number" min="0" step="any" name="parcel" /> 
				<br> 
				<br> 
				<label>Curriculum:(Max 4MB) </label> 
				<br> 
				<br> 
				<input type="file" name="cv" accept="application/pdf,application/vnd.ms-excel" /> <br> <br>
				<button type="submit">Aggiorna</button>

			</form>
		</div>
		<%
				}
				connection.close();
				} catch (Exception e) {
				e.printStackTrace();
				}
				%>
	</div>
	<%}
else{ 
	request.setAttribute("notlogged", "notlogged");
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
    dispatcher.forward(request, response);
 }%>
 
 <script>
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