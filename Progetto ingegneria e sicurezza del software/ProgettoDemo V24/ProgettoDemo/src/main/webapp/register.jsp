<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="stile.css" />
<title>Registrazione</title>
</head>
<body>
<div class="background"></div>

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
		<label>Carta d'identita': </label>
		<input type="file" name="cid" accept="image/png, image/jpeg" required /> <br>
		<br>
		<button type="submit" class="btn btn-primary">Conferma</button>

	</form>
</body>
</html>
