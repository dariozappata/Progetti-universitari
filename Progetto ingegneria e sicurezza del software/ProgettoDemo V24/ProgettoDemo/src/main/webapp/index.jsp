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
<%String message="";
if(request.getAttribute("message")!=null){
    message= (String) request.getAttribute("message");
}%>
<html>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>Dream Team</title>
<link rel="stylesheet" href="CSS/homestyle.css">

<head>

</head>

    <div class="nav-top">
      <div class="nav-bar nav-white nav-padding nav-card">
        <div class="nav-right">
         	<a class="button-one btn-pill" href="#popup1">
                	<span>Login</span>
              	</a>
         	<a class="button-one btn-pill" href="#popup2">
                	<span>Sign Up</span>
              	</a>
        </div>
       </div>
     </div>

<body>

	<div id="popup1" class="overlay">
	    <div class="popup">
	        
	        <a class="cancel" href="#"></a>
	        <div class="content">
	            <form action="<%= request.getContextPath() %>/login" method="post">
			        <h3>Login</h3>
			        <label for="email">Email:</label> 
			        <input class="in" name="email" size="30" />
			        <br> 
			        <label for="password">Password:</label> 
			        <input class="in" type="password" name="password" size="30" /> 
			        <br>
			        <label>Seleziona la modalità di accesso: </label> 
			        <br>
			        <input type="radio" id="professionista" name="modalita" value="professionista" checked /> 
			        <label for="professionista">Professionista</label> 
			        <br>
			        <input type="radio" id="gestore" name="modalita" value="gestore" /> 
			        <label for="gestore">Gestore</label> <br>
			        <% out.println(message);%>	  
			        <br>      
			        <button class="button-one btn-pill form-button" type="submit" class="btn btn-primary"><span>Login</span></button>
	    		</form>
	        </div>
	    </div>
	</div>

	<div id="popup2" class="overlay">
	    <a class="cancel" href="#"></a>
	    <div class="popup">
	        <div class="content">
	        	<form class="reg" action="<%= request.getContextPath() %>/register" method="post" enctype="multipart/form-data">
			        <h3>Registrazione</h3>
			        <br>
			        <label>E-mail: </label> 
			        <input class="in" type="email" name="email" required />
			        <br> 
			        <label>Password: </label> 
			        <input class="in" type="password" name="password" required minlength="6" maxlength="10" /> 
			        <br>
			        <label>Nome: </label> 
			        <input class="in" type="text" name="firstName" required minlength="2" maxlength="20" /> 
			        <br>
			        <label>Cognome: </label> 
			        <input class="in" type="text" name="lastName" required minlength="2" maxlength="20" /> 
			        <br>
			        <label>Carta d'identità: </label>
			        <input type="file" name="cid" accept="image/png, image/jpeg" required /> <br>
			        <br>
			        <button class="button-one btn-pill form-button" type="submit" class="btn btn-primary"><span>Conferma</span></button>
	    		</form>
	        </div>
	    </div>
	</div>



	<div class="slideshow-container" >
		<%
		int i = 0;
		try {
			connection = DriverManager.getConnection(userDao.getJdbcURL(), userDao.getDbUser(), userDao.getDbPassword());
			statement = connection.createStatement();
			String sql = "SELECT * FROM recensioni_sistema";
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				i++;
		%>
		<div class="mySlides">
			<q> <%=resultSet.getString("description")%></q>
			<p class="author">-<%=resultSet.getString("emailUser")%></p>
		</div>
		<%
}
connection.close();
} catch (Exception e) {
e.printStackTrace();
}
%>

		<a class="prev" onclick="plusSlides(-1)">&laquo;</a> <a class="next"
			onclick="plusSlides(1)">&raquo;</a>
	</div>

	


	<script>
var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
showSlides(slideIndex += n);
}

function currentSlide(n) {
showSlides(slideIndex = n);
}

function showSlides(n) {
var i;
var slides = document.getElementsByClassName("mySlides");
var dots = document.getElementsByClassName("dot");
if (n > slides.length) {slideIndex = 1}
if (n < 1) {slideIndex = slides.length}
for (i = 0; i < slides.length; i++) {
slides[i].style.display = "none";
}
for (i = 0; i < dots.length; i++) {
dots[i].className = dots[i].className.replace(" active", "");
}
slides[slideIndex-1].style.display = "block";
dots[slideIndex-1].className += " active";
}
</script>


</body>
</html>