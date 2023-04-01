<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dreamteam.progetto.model.SessionSingleton" %>
<% SessionSingleton userSession = SessionSingleton.getInstance();%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="CSS/modificaprofilo.css" />
<title>Creazione Team</title>

</head>
<body>
<%if(userSession.getEmail()!=null){ %>

	<div class="background"></div>

	<form class="reg" action="<%=request.getContextPath()%>/createteam" method="post">
		<h1>Creazione Team</h1>
		<br> 
		<label>Nome: </label> 
		<input class="in" type="text" name="nameTeam" required /> <br> 
		<label>Descrizione: </label>
		<textarea name="description" cols="35" rows="4"></textarea>
		<br> 
		<label>Categoria: </label> 
		<input class="in" type="text" name="category" required /> <br> 
		<label>Grandezza: </label> 
		<input class="in" type="text" name="largeness" required /> <br> 
		<label>Durata Stimata:</label> 
		<input class="in" type="text" name="estimatedDuration" required/>
		<button type="submit" class="btn btn-primary">Conferma</button>



	</form>
	<%}
else{ 
	request.setAttribute("notlogged", "notlogged");
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("/");
    dispatcher.forward(request, response);
 }%>
</body>
</html>