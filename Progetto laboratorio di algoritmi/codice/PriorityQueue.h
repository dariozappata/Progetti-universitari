#include <iostream>
#define INF 2147483647
using namespace std;

/*la classe PriorityQueue è stato realizzata appositamente per il problema in esame
ed è implementata mediante heap*/
class PriorityQueue{
private:
    int num;                //rappresenta il numero di elementi memorizzati nell'heap
    int *pq;                //heap per massimo o minimo
    int *qp;                //array che tiene traccia della posizione dei vertici nell'heap
    double *key;            //array per memorizzare i costi degli archi 
    bool max;               //variabile booleana che se posta a true permette di gestire il max heap, viceversa il min heap

public:
    PriorityQueue() {}
    /*inizializza una coda a priorità per contenere V elementi
    il secondo parametro del costruttore è un booleano utilizzato per specificare max heap o min heap*/
    PriorityQueue(int V, bool max){
        num = 0;
        pq = new int[V + 1];          //la prima posizione utile di pq è l'indice 1, per sfruttare la relazione padre-figli: 2i e 2i+1
        qp = new int[V];              //qp[i] indica la posizione del vertice i in pq
        key = new double[V];          //key[i] indica il costo per arrivare al vertice i
        this->max=max;                  
        for(int i=0;i<V;i++){         //ciclo per iniziallare qp ad inf utile per il metodo contains
            qp[i]=INF;
        }
    }

    void insert(int i, double key){
        this->num++;
        this->qp[i] = this->num;        //il vertice i si troverà nella posizione num
        this->pq[this->num] = i;        //oltre che indicare il numero di elementi num funge da indice per l'inserimento in pq
        this->key[i] = key;
        bubbleUp(num);                  //richiama bubbleUP per mantenere la relazione di min/max heap
    }

    void decreaseKey(int i, double key){
        if (this->key[i] > key)
            this->key[i] = key;
        bubbleUp(qp[i]);
    }

    void bubbleUp(int num){
        /*num è l'indice del vertice su cui stiamo effettuando l'operazione di bubleUp
        parent è l'indice del padre*/
        int parent = num / 2;
        /*nel caso di min heap se la chiave del figlio risulta essere minore di quella del padre 
        all'interno dell'if effettuiamo lo scambio dei due valori e viceversa per max heap*/
        if (num != 1 && operation(this->key[this->pq[num]],this->key[this->pq[parent]]) )
        {
            //scambio tramite xor dei vertici nella pq
            this->pq[num]= this->pq[num]^this->pq[parent];
            this->pq[parent]=this->pq[parent]^this->pq[num];
            this->pq[num]= this->pq[num]^this->pq[parent];

            //scambio tramite xor delle posizioni dei vertici in qp
            this->qp[pq[num]]=this->qp[pq[num]]^this->qp[pq[parent]];
            this->qp[pq[parent]]=this->qp[pq[parent]]^this->qp[pq[num]];
            this->qp[pq[num]]=this->qp[pq[num]]^this->qp[pq[parent]];

            //ricorsivamente risale verso la radice
            bubbleUp(parent);
        }
    }

//cancellazione del max/min
    int deleteM(){
        int r = this->pq[1];                //il max/min si trova alla radice dell'heap
        this->pq[1] = this->pq[num];        //una volta estratto mette alla radice l'ultimo nodo dell'array
        this->qp[pq[1]] = 1;                
        this->qp[r] = INF;                  //teniamo traccia dei vertici cancellati assegnadogli come posizione nell'heap inf
        this->num--;
        bubbleDown(1);                      //richiama bubbleDown per mantenere la relazione di min/max heap
        return r;
    }

//restituisce il vertice alla radice senza eliminarlo
    int getRoot(){
        return this->pq[1];
    }

    void bubbleDown(int i){
        //sx rappresenta l'indice del filgio sinistro di i viceversa dx
        //m contiene l'indice del filgio con valore minore nel caso di min heap e viceversa per max heap
        int m = 0, sx = 2 * i, dx = sx + 1;
        //verifica se esiste il figlio sinistro
        if (sx <= this->num){
            m = sx;
        }
        //il filgio destro può esistere solo se il sinistro esiste
        if (dx <= this->num){
            //confrontando le chiavi dei figlio riusciamo a comprendere chi dei due è il min/max
            if ( operation(this->key[pq[sx]],this->key[pq[dx]]))
                m = sx;
            else
                m = dx;
        }
        //se m ha il valore 0 il vertice di indice i non ha alcun figlio, caso base
        if(m==0)
            return;
        //confrontiamo la chiave dell'vertice i con il figlio con chiave minima nel caso di min heap 
        if (operation(this->key[pq[m]],this->key[pq[i]])){
            //scambio come per il bubbleUp per mantenere la relazione di heap
            this->pq[i]=this->pq[i]^this->pq[m];
            this->pq[m]=this->pq[m]^this->pq[i];
            this->pq[i]=this->pq[i]^this->pq[m];

            this->qp[pq[i]]=this->qp[pq[i]]^this->qp[pq[m]];
            this->qp[pq[m]]=this->qp[pq[m]]^this->qp[pq[i]];
            this->qp[pq[i]]=this->qp[pq[i]]^this->qp[pq[m]];

            //ricorsivamente scnedo verso il basso
            bubbleDown(m);
        }
    }

    bool isEmpty(){
        return this->num==0;
    }

    bool contains(int v){
        return !(this->qp[v] == INF);   //se qp[v]==INF il vertice v non è contenuto nell'heap
    }

    /*opeartion è utilizzato per sostituire i confronti in tutte le funzioni 
    della coda a priorità, opportunamente per gestire max or min heap*/
    bool operation(double a, double b){
        if(this->max) return a > b;
        return a < b;
    }

    double getValue(int v){
        return this->key[v];
    }
};