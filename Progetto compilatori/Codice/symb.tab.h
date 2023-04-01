typedef struct ciclista{
    char* nome;
    int pettorale;
    int tempo;
    int tempoParziale;
    struct ciclista *next;
}Ciclista;

//struttura usata per memorizzare i dati dei ciclisti si tratta di un array di liste
Ciclista** hashTable;

typedef struct queue{
    Ciclista* testa;
    Ciclista* coda;
}Queue;
//coda utilizzata per tenere traccia dell'ordine di arrivo dei ciclisti nella tappa specificata 
Queue* classificaTappa;

//lista ordinata per i tempi parziali dei ciclisti per tutte le tappe fino alla data specificata
Ciclista* classificaParziale;

void start();
int hash(int pettorale);
void insertCiclista(int pettorale, char* nome);
Ciclista* ricerca(int pettorale);
void resizeHashTable();
void printHashTable();
int insertTappa(int pettorale, int tempo);
void impostaClassificaParziale(int pettorale, int tempo);
void printTappa(char* dataTappa);
void printClassificaParziale();
void ordinaTempi(char* nome,int tempoParziale);
void freeAll();
