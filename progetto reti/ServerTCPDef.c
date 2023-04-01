#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <pthread.h>

struct sockaddr_in clientAddr[10]; 
int Clientsd[10]; // socket dei client
int Serversd; //socket del server
int parking0 = 10; //posti liberi parcheggio piano terra
int parking1 = 10; //posti liberi parcheggio primo piano

void *my_thread(void *arg){
  int ind = *(unsigned int *)arg-1;  //identificativo del thread
  int parking_flag = 0; //flag per capire in quale piano si sta parcheggiando (0 terra - 1 primo)
  int vehicle_flag = 0; //flag per il tipo di veicolo che sto parcheggiando   (0 auto - 1 veicolo comm)
  int end_flag=0;       //flag per capire se sto uscendo (0 no - 1 si)

  char identita[80];
  char tipoveicolo[80];
  char END[10];
  char ok[20] = "OK";
  char ko[20] = "KO";

  printf("Posti disponibili piano terra: %d \n", parking0);
  printf("Posti disponibili primo piano: %d \n\n", parking1);

  read(Clientsd[ind],identita, sizeof(identita)); //ind-1 perchè ogni volta che si esegue my thread crea il successivo e non l'attuale
  printf("Nome e cognome cliente: %s \n", identita);
  
  read(Clientsd[ind], tipoveicolo, 1);
  printf("Tipo del veicolo: %s \n", tipoveicolo);

  if (tipoveicolo[0] == 'A'){
      if(parking1 >= 1){
        printf("Posto prenotato correttamente.\n");
        write(Clientsd[ind],&ok,sizeof(ok));
       
        parking1 -= 1;
      
        parking_flag = 1;
        vehicle_flag = 0;
        end_flag = 0;
      }else if(parking0 >= 1){
        printf("Posto prenotato correttamente.\n");
        write(Clientsd[ind],&ok,sizeof(ok));
       
        parking0 -= 1;
        
        parking_flag = 0;
        vehicle_flag = 0;
        end_flag = 0;
      }else{
        printf("Posto non prenotato, spazio insufficiente.\n");
         write(Clientsd[ind],&ko,sizeof(ko));
        }
   }else if(tipoveicolo[0] == 'V'){
      if(parking0 >= 2){
        printf("Posto prenotato correttamente.\n");
        write(Clientsd[ind],&ok,sizeof(ok));
       
        parking0 -= 2;
        
        parking_flag = 0;
        vehicle_flag = 1;
        end_flag = 0;

      }else{
        write(Clientsd[ind],&ko,sizeof(ko));
        printf("Posto non prenotato, spazio insufficiente.\n");
      }
   }
   printf("Posti disponibili piano terra: %d \n", parking0);
   printf("Posti disponibili primo piano: %d \n\n", parking1);
 

 if(end_flag == 0){
  
  read(Clientsd[ind], END, sizeof(END));
  printf("Client %d: %s \n",ind, END);
  
  if((strcmp(END, "END") == 0)||(strcmp(END, "end") == 0)){
    if(parking_flag == 0 && vehicle_flag == 0){
     parking0 +=1;
    }else if(parking_flag == 1 && vehicle_flag == 0){
     parking1 +=1;
    }else if(parking_flag == 0 && vehicle_flag == 1){
     parking0 +=2;
    }
  }
  printf("Posti disponibili piano terra: %d \n", parking0);
  printf("Posti disponibili primo piano: %d \n\n", parking1);
 }

close(*Clientsd);
}

int main(int argc, char *argv[])
{ 
  int rc,ls_result;
  struct sockaddr_in ServerAddr; //myaddr
  
  int indtid=0; //indice del thread
  pthread_t  threads[10];
  
  socklen_t sin_size = sizeof(ServerAddr); //dimensione indirizzo server
  if(argc<2){
    printf("usage : %s <Server PORT>  \n", argv[0]);
    exit(1);
  } 

  Serversd = socket(AF_INET,SOCK_STREAM,0); // creazione socket
  if(Serversd<0){
    printf("%s: Impossibile aprire la socket \n",argv[0]);
    exit(1);
  }
   
  printf("Socket aperta \n\n");

  ServerAddr.sin_family = AF_INET;
  ServerAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  ServerAddr.sin_port = htons(atol(argv[1]));

  rc = bind(Serversd, (struct sockaddr *) &ServerAddr,sizeof(ServerAddr));
  if(rc<0){
    printf("%s: Impossibile associare la porta %ld \n", argv[0], atol(argv[1]));
    exit(1);
  }

  ls_result = listen(Serversd, 10);  
  if(ls_result< 0){
    printf("Server: errore durante l'ascolto.\n");
    exit(0);
  } 
  else printf("La socket e' in ascolto\n");

  while(1) 
   {
    Clientsd[indtid]= accept(Serversd, (struct sockaddr *)&clientAddr[indtid],&sin_size); // La socket accetta la richiesta del client  connection setup

    printf("Connessione con il client effettuata:%s\n",inet_ntoa(clientAddr[indtid].sin_addr));
    pthread_create(&threads[indtid],NULL,my_thread,&indtid);
    
    indtid++;
    if(indtid==11) indtid=0;
  }
  
 
return 1;
}

