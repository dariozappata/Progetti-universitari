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
<link rel="stylesheet" href="CSS/createads.css">
<title>Crea annuncio</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
    var maxField = 10; //numero massimo di campi
    var addButton = $('.add_button');
    var wrapper = $('.field_wrapper'); 
    var fieldHTML = '<div class="table_form"><div class="sub_table"><label>Professione: </label>&emsp;&emsp;&emsp;&emsp;</div><div class="autocomplete sub_table"><input class="myInput" type="text" name="profession[]" value="" required/></div><div class="sub_table"><label>Parcella:</label>&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="sub_table"><input type="number" name="parcel[]" min="0" step="any" value="" required/></div><div class="sub_table"><label>Ore:</label></div>	<div class="sub_table">	<input type="number" name="duration[]" min="0" value="" required/></div><a href="javascript:void(0);" class="remove_button"><img src="icon/minus.png"/></a></div>'   	
    var x = 1; //contatore campi
    
    $(addButton).click(function(){
        if(x < maxField){ 
            $(wrapper).append(fieldHTML);
            autocomplete(document.getElementsByClassName("myInput")[x], profession);
            x++;
        }
    });
    
    $(wrapper).on('click', '.remove_button', function(e){
        e.preventDefault();
        $(this).parent('div').remove();
        x--; 
    });
});
</script>
</head>
<body onload="mostra();">
<%if(userSession.getEmail()!=null){ %>
<div align="center">
		<form class="nav_form" action="<%=request.getContextPath()%>/homegestore" method="get">
			<button type="submit">Torna ad Home Gestore</button>
		</form>
		<form class="nav_form" action="<%=request.getContextPath()%>/logout" method="get">
			<button type="submit">Logout</button>
		</form>
</div>
<div align="center" hidden="hidden" id="notvisible">
<h1>Crea annuncio</h1>
<form autocomplete="off" action="<%=request.getContextPath()%>/createads" method="post">
	<label>Descrizione: </label>
	<br>
	<textarea name="description" cols="55" rows="2" required></textarea>
	<br>
	<br>
	<div class="field_wrapper">
	<div class="table_form">
			<div class="sub_table">
    		<label>Professione: </label>&emsp;&emsp;&emsp;&emsp;
    		</div>
    		<div class="autocomplete sub_table">
    		<input class="myInput" type="text" name="profession[]" value="" required/>  
    		</div>

			<div class="sub_table">
    		<label>Parcella: </label>&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    		</div>
    		<div class="sub_table">
    		<input type="number" name="parcel[]" min="0" step="any" value="" required/> 
			</div>

			<div class="sub_table">
    		<label>Ore: </label>
    		</div>
    		<div class="sub_table">
    		<input type="number" name="duration[]" min="0" value="" required/>
  	 	  	</div>  	     
      	  	
        	<a href="javascript:void(0);" class="add_button" title="Aggiungi"><img src="icon/plus.png"/></a>
    </div>
	</div>
	<br>
	<div>
	<button type="submit">Conferma</button>
	</div>
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
			String sql = "SELECT emailFounder FROM team WHERE id = " + TeamVisual;
			
			String aus1= null;
			resultSet = statement.executeQuery(sql);
			if(resultSet.next()){
				aus1=resultSet.getString("emailFounder");
			}
			
			if ((userSession.getEmail().equalsIgnoreCase(aus1))) {
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
	
autocomplete(document.getElementsByClassName("myInput")[0], profession);


</script>
</body>
</html>