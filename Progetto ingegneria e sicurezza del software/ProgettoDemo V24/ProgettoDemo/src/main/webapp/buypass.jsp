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
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="CSS/buypass.css">
</head>
<body>
<%if(userSession.getEmail()!=null){ %>
<title>Buy pass</title>
<nav>
  <a href="<%=request.getContextPath() %>/homegestore" method="get">Home Gestore</a>
  <a href="<%=request.getContextPath() %>/homeprofessionista" method="get">Home Professionista</a>
  <a href="<%=request.getContextPath() %>/logout"  method="get">Logout</a>
</nav>

	<br><br><br>
	<h1>Modulo di pagamento</h1>
<p>Acquisto dell'abbonamento che prevede la visualizzazione di tutte le recensioni di qualsiasi utente</p>
<div class="row">
  <div class="col-75">
    <div class="container">
      <form action="<%=request.getContextPath() %>/buypass"  method="post">
      
        <div class="row">
          <div class="col-50">
            <h3>Informazioni di fatturazione</h3>
            <label for="name"><i class="fa fa-user"></i> Nome e cognome</label>
            <input type="text" id="name" name="name" placeholder="Mario Rossi" required>
            <label for="email"><i class="fa fa-envelope"></i> Email</label>
            <input type="text" id="email" name="email" placeholder="mario@esempio.it" required>
            <label for="indirizzo"><i class="fa fa-address-card-o"></i> Indirizzo</label>
            <input type="text" id="indirizzo" name="indirizzo" placeholder="Via Roma 152" required>
            <label for="citta"><i class="fa fa-institution"></i> Citt&agrave;</label>
            <input type="text" id="citta" name="citta" placeholder="Palermo" required>

            <div class="row">
              <div class="col-50">
                <label for="nazione">Nazione</label>
                <input type="text" id="nazione" name="nazione" placeholder="Italia" required>
              </div>
              <div class="col-50">
                <label for="zip">CAP</label>
                <input type="text" id="cap" name="cap" placeholder="90100" required>
              </div>
            </div>
          </div>

          <div class="col-50">
            <h3>Pagamento</h3>
            <label for="fname">Carte accettate</label>
            <div class="icon-container">
              <i class="fa fa-cc-visa" style="color:navy;"></i>
              <i class="fa fa-cc-amex" style="color:blue;"></i>
              <i class="fa fa-cc-mastercard" style="color:red;"></i>
              <i class="fa fa-cc-discover" style="color:orange;"></i>
            </div>
            <label for="cardname">Nome sulla carta</label>
            <input type="text" id="cardname" name="cardname" placeholder="Mario Rossi" required>
            <label for="cardnumber">Numero carta</label>
            <input type="text" id="cardnumber" name="cardnumber" placeholder="1111-2222-3333-4444" required>
            <label for="expmonth">Mese scadenza</label>
            <input type="text" id="expmonth" name="expmonth" placeholder="September" required>
            <div class="row">
              <div class="col-50">
                <label for="expyear">Anno scadenza</label>
                <input type="text" id="expyear" name="expyear" placeholder="2022" required>
              </div>
              <div class="col-50">
                <label for="cvv">CVV</label>
                <input type="text" id="cvv" name="cvv" placeholder="123" required>
              </div>
            </div>
          </div>
          
        </div>
        <button type="submit" name="button" class="btn" value="<%=userSession.getEmail()%>">Conferma pagamento</button>
      </form>
    </div>
  </div>
  <div class="col-25">
    <div class="container">
      <h4>Carrello <span class="price" style="color:black"><i class="fa fa-shopping-cart"></i> <b>1</b></span></h4>
      <p>Abbonamento annuale <span class="price">&euro;10</span></p>
      <hr>
      <p>Totale <span class="price" style="color:black"><b>&euro;10</b></span></p>
    </div>
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
