#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symb.tab.h"

//i valori di SIZE e threshold sono usati per modificare le performance dell'hashTable
int SIZE= 3;                //indica la dimensione dell'hashTable
double threshold= 0.75;     //valore di sogliatura per controllare il fattore di carico
int n= 0;                   //numero di elementi nell'hashTable

int posizione= 1, ciclistiInTappa=1;        //valori usati nel calcolo dei tempi parziali

//inizializzazione strutture dati
void start(){
    classificaTappa=(Queue*) malloc(sizeof(Queue));
    classificaTappa->testa= NULL;
    classificaTappa->coda= NULL;

    classificaParziale= NULL;

    hashTable= malloc(SIZE*sizeof(*hashTable));
    for(int i=0; i<SIZE; i++)
        hashTable[i]=NULL;
}

//funzione hash modulare
int hash(int pettorale){
    return pettorale%SIZE;
}

//funzione per l'inserimento dei ciclisti nell'hashTable
void insertCiclista(int pettorale, char* nome){
    Ciclista* cicl;
    //se non è già presente il ciclista viene inserito
    if((cicl=ricerca(pettorale))==NULL){
        cicl=(Ciclista*)malloc(sizeof(*cicl));
        cicl->pettorale= pettorale;
        cicl->nome= nome;
        cicl->tempo= 0;
        cicl->tempoParziale= 0;
        cicl->next= hashTable[hash(pettorale)];
        hashTable[hash(pettorale)]= cicl;
        n++;
    }
    else{
        fprintf(stderr,"Sono presenti due ciclisti con il pettorale: %d\n",pettorale);
		exit(1);
    }
}

//verifica se un ciclista è presente nell'hashTable
Ciclista* ricerca(int pettorale){
    Ciclista* ciclista;
    for(ciclista=hashTable[hash(pettorale)]; ciclista!=NULL; ciclista=ciclista->next){
        if(ciclista->pettorale==pettorale)
            return ciclista;
    }
    return NULL;
}

//ridimensionamento dell'hashTable
void resizeHashTable(){
    double loadFactor= (double)n/(double)SIZE;
    if(loadFactor >= threshold){
        Ciclista** oldHashTable=hashTable;
        n=0;
        SIZE*=2;
        hashTable=NULL;
        //doubling della dimensione dell'hashTable
        hashTable= malloc(SIZE*sizeof(*hashTable));
        for(int i=0; i<SIZE; i++)
            hashTable[i]=NULL;
        //per ciascuno dei ciclisti presenti nell'hashTable ricalcola 
        //la funzione hash e li dispone nelle rispettive nuove celle
        for(int i=0; i<SIZE/2; i++){
            Ciclista* ciclista= oldHashTable[i];
            while(ciclista!=NULL){
                insertCiclista(ciclista->pettorale, ciclista->nome);
                ciclista=ciclista->next;
            }
        }
        free(oldHashTable);
    }
}

//funzione di debug
void printHashTable(){
    Ciclista* ciclista;
    for(int i=0; i<SIZE;i++){
        printf("%d: ",i);
        for(ciclista=hashTable[i]; ciclista!=NULL; ciclista=ciclista->next)
            printf("%s ",ciclista->nome);
        printf("\n");
    }
}

//inserisci in coda in base all'ordine di arrivo i ciclisti della tappa specificata
int insertTappa(int pettorale, int tempo){
    Ciclista* ciclista= hashTable[hash(pettorale)];
    while((ciclista!=NULL) && ((ciclista->pettorale)!=pettorale)){
        ciclista=ciclista->next;
    }

    if(ciclista==NULL){
        fprintf(stderr,"Il ciclista %d non e' presente nell'elenco dei partecipanti\n", pettorale);
		exit(1);
    }
    
    Ciclista* temp=(Ciclista*) malloc(sizeof(Ciclista));
    temp->nome= ciclista->nome;
    temp->pettorale= pettorale;
    temp->tempo= tempo;
    temp->next=NULL;

    if(classificaTappa->coda==NULL){
        classificaTappa->coda= temp;
        classificaTappa->testa= temp;
    }
    else{
        classificaTappa->coda->next= temp;
        classificaTappa->coda= temp;
    } 
}

//calcolo dei tempi parziali con eventuali bonus in base alla posizione di arrivo
void impostaClassificaParziale(int pettorale, int tempo){
    Ciclista* ciclista= hashTable[hash(pettorale)];
    while((ciclista!=NULL) && ((ciclista->pettorale)!=pettorale)){
        ciclista=ciclista->next;
    }
    if(ciclista==NULL){
        fprintf(stderr,"Il ciclista %d non e' presente nell'elenco dei partecipanti\n",pettorale);
		exit(1);
    }
    //se ciclistiInTappa è maggiore di n significa che stiamo iniziando ad analizzare la tappa successiva
    //e quindi resetta le posizioni per il calcolo dei bonus
    if(ciclistiInTappa>n){
        ciclistiInTappa=1;
        posizione=1;
    }

    int tempoBonus= 0;
    if(posizione==1)
        tempoBonus= 60;
    else if(posizione==2)
        tempoBonus= 30;
    else if(posizione==3)
        tempoBonus= 10;
    ciclista->tempoParziale+=(tempo-tempoBonus);
    
    ciclistiInTappa++;
    posizione++;
}

//stampa della classifica della tappa specificata mediante la coda
void printTappa(char* dataClassifica){
    Ciclista* ciclista= classificaTappa->testa;
    int posto=1;
    printf("\nCLASSIFICA TAPPA %s\n",dataClassifica);
    while(ciclista!=NULL){
        printf("   %d.%25s   ",posto++,ciclista->nome);
        //conversione da secondi a hh:mm:ss
        int h= (ciclista->tempo)/3600;
        int m= ((ciclista->tempo)-(3600*h))/60;
        int s= ((ciclista->tempo)-(3600*h)- (m*60));
        printf("%.2d:%.2d:%.2d\n",h,m,s);
        ciclista=ciclista->next;
    }
}

//inserimento ordinato nella lista classificaParziale in base ai tempi parziali dei ciclisti
void ordinaTempi(char* nome,int tempoParziale){
    Ciclista* temp =(Ciclista*) malloc(sizeof(Ciclista));
	temp->nome = nome;
	temp->tempoParziale= tempoParziale;
	temp->next = NULL;

    Ciclista *prev = NULL,*current = classificaParziale;
    //ricerca della posizione corretta nella lista
    while((current!=NULL) && ((temp->tempoParziale)>(current->tempoParziale))){
        prev= current;
        current= current->next;
    }

    if(prev== NULL){
        temp->next= classificaParziale;
        classificaParziale= temp;
    }
    else{
        prev->next= temp;
        temp->next= current;
    }
}

//stampa della classifica parziale fino alla data specificata
void printClassificaParziale(){
    Ciclista* ciclista= classificaTappa->testa;
    int posto=1;
    //scorre gli elementi nella coda della tappa per creare la lista ordinata per tempi parziali
    while(ciclista!=NULL){
        Ciclista* cicl= hashTable[hash(ciclista->pettorale)];
        while((cicl->pettorale != ciclista->pettorale)){
            cicl= cicl->next;
        }
        ordinaTempi(cicl->nome, cicl->tempoParziale);
        ciclista= ciclista->next;
    }

    //stampa classifica
    Ciclista* listaOrdinata= classificaParziale;
    printf("\nCLASSIFICA PARZIALE\n");
    while(listaOrdinata!=NULL){
        printf("   %d.%25s   ",posto++,listaOrdinata->nome);
        //conversione da secondi a hh:mm:ss
        int h= (listaOrdinata->tempoParziale)/3600;
        int m= ((listaOrdinata->tempoParziale)-(3600*h))/60;
        int s= ((listaOrdinata->tempoParziale)-(3600*h)- (m*60));
        printf("%.2d:%.2d:%.2d\n",h,m,s);
        listaOrdinata= listaOrdinata->next;
    }
}

//funzione per liberare la memoria allocata per le strutture utilizzate
void freeAll(){
    Ciclista* temp= classificaTappa->testa;
    while(classificaParziale!=NULL){
        classificaTappa->testa= classificaTappa->testa->next;
        free(temp);
        temp= classificaParziale;
        classificaParziale= classificaParziale->next;
        free(temp);
    }

    for(int i=0; i<SIZE; i++){
        Ciclista* temp2= hashTable[i];
        while(temp2!=NULL){
            temp= temp2;
            temp2= temp2->next;
            free(temp);
        }
    }
    free(hashTable);
}
