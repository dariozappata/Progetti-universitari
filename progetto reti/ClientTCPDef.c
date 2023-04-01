#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <strings.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <netdb.h>

int main()
{
  int clientsocket;        // socket client connection setup
  int rispconect;          // socket client per scambio dati
  struct sockaddr_in addr; // struct contenente coppia indirizzo:porta del server
  char identita[80];   // nome e cognome cliente
  char tipoveicolo[1]; // tipologia vettura (A = Automobile che occupa 1 posto , V = Veicolo commerciale che occupa 2 posti)
  short port = 9004;   // porta server
  struct hostent *h;   // struct contenente informazioni viste con il dns

  addr.sin_family = AF_INET;   // indirizzi IP versione 4
  addr.sin_port = htons(port); // conversione dati formato big-e

  h = gethostbyname("localhost"); // trova ip del server dal nome host (IP, host name canonico, una list di aliases, il tipo di indirizzo, ecc).
  if (h == 0)
  {
    printf("Traduzione \"hostname to ip\" fallita\n");
    exit(1);
  }

  bcopy(h->h_addr, &addr.sin_addr, h->h_length); // copia indirizzo ip del server letto con gethostbyname in sin_addr

  clientsocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); // socket creata (ipv4, socket tcp ordinata e bidirezionale, protocollo tcp)
  if (clientsocket < 0)
  {
    printf("Errore nella creazione della socket.\n");
    exit(0);
  }

  rispconect = connect(clientsocket, (struct sockaddr *)&addr, sizeof(addr)); // connessione dalla socket appena creata all'indirizzo ip del server
  if (rispconect < 0)
  {
    printf("Connessione con il server non riuscita \n");
    exit(0);
  }

  char buffer[200]; // stringa che contiene il messaggio ricevuto dal server

  printf("\nInserisci nome e cognome: ");
  gets(identita);

  write(clientsocket, identita, sizeof(identita)); // invio stringa identificativa al server

  do
  {
    printf("Inserisci il tipo (A - automobile, V - veicolo commerciale): ");
    gets(tipoveicolo);
  }
  while((tipoveicolo[0]!='A')&&(tipoveicolo[0]!='V'));
 

  write(clientsocket, tipoveicolo, sizeof(tipoveicolo)); // invio carattere veicolo al server

  read(clientsocket, buffer, sizeof(buffer)); //legge e mette in buffer il contenuto del messaggio ricevuto dal server

  printf("Risposta del server:%s\n", buffer);

  if (strcmp(buffer, "OK") == 0){  // se la risposta del server è "OK"
    char message_end[50];

    do
    {
      printf("Inserisci END per terminare la sosta: ");
      gets(message_end);
    }
    while(strcmp(message_end, "END") != 0);
    
    write(clientsocket, message_end, sizeof(message_end)); // invio message_end al server
  }
  else if(strcmp(buffer, "KO") == 0){
    printf("Non c'e' posto nel parcheggio, riprovare piu' tardi.");
  }

  return 0;
}
