#include <iostream>
#include <vector>
#include <list>
#include <cmath>
#include <iomanip>
#include <limits>
#include "PriorityQueue.h"
using namespace std;

//classe Coords per memorizzare le coordinate
class Coords{
public:
    Coords() {}
    Coords(int x, int y){
        this->x = x;
        this->y = y;
    }

    int getX(){
        return this->x;
    }
    int getY(){
        return this->y;
    }
private:
    int x;
    int y;
};

/*classe per memorizzare gli archi nella lista di adiacenza, il vertice di partenza è l'indice dell'array adj
l'oggetto edge contiene solo il vertice di arrivo e il costo dell'arco*/
class Edge{
public:
    Edge() {}
    Edge(int v, double cost){
        this->v = v;
        this->cost = cost;
    }

    int getV(){
        return this->v;
    }
    double getCost(){
        return this->cost;
    }

private:
    int v;
    double cost;
};

class Graph{
public:
    Graph(int S, int V, vector<Coords> outpost);
    void INSERT_EDGE(int v, int u, double cost);
    void printGraph();

    void PrimMST();
    void prim(int s);
    void scan(int v);
    double setSatellite();

private:
    vector<list<Edge>> adj_list;        //lista di adiacenza
    int V, S;                           //numero di vertici e canali satellitari
    vector<int> edgeTo;                 //vettore che contiene i vertici di partenza degli archi del MST 
    vector<double> distTo;              //costo di tali archi
    vector<bool> marked;                //indica i vertici già inseriti nel MST, evita la creazione di cicli
    PriorityQueue pq;                   //coda a priorità sui vertici per l'estrazione dell'arco di costo minimo
    PriorityQueue maxEdge;              //coda a priorità sui vertici per l'estrazione dell'arco di costo masssimo
};

/*costruttore che inizializza il grafo con numero di nodi pari al numero di avamposti
ciascun arco sarà etichettato con la distanza euclidea tra le coordinate dei vari avamposti*/
Graph::Graph(int S, int V, vector<Coords> outpost){
    this->S=S;
    this->V=V;
    for (int i = 0; i < V; i++){
        list<Edge> list;
        adj_list.push_back(list);
    }

    double c;
    for (int i = 0; i < V; i++){
        for (int j = i+1; j < V; j++){
            c = sqrt(pow((outpost[i].getX() - outpost[j].getX()), 2) + pow((outpost[i].getY() - outpost[j].getY()), 2));
            this->INSERT_EDGE(i, j, c);
        }
    }
}

void Graph::INSERT_EDGE(int v, int u, double cost){
    Edge edge(u, cost);
    this->adj_list[v].push_front(edge);
}

void Graph::printGraph(){
    cout<<endl;
    cout <<"Lista delle adiacenze" << endl;
    for (int i = 0; i < adj_list.size(); i++){
        cout << i << ": ";
        list<Edge>::iterator pos = adj_list[i].begin();
        for (; pos != this->adj_list[i].end(); pos++)
            cout << "  " << pos->getV() << " -> " << setprecision(2) << fixed << pos->getCost();
        cout << endl;
    }
}

void Graph::PrimMST(){
    this->edgeTo.resize(V);
    this->distTo.resize(V);
    this->marked.resize(V);
    this->pq = PriorityQueue(V,false);
    this->maxEdge = PriorityQueue(V,true);

    //inizializzazione del vettore delle distanze ad inf
    for(int i=0; i<V;i++){
        this->distTo[i]=numeric_limits<double>::infinity();
    }

    //invocazione dell'algoritmo di prim sul primo nodo
    prim(0);
}

void Graph::prim(int s){
    this->distTo[s]=0.0;
    this->edgeTo[s]=0;
    this->pq.insert(s,distTo[s]);

    //scansione fatta prima del while per non inserire l'arco che dal vertice sorgente va a se stesso nella coda a priorità
    scan(this->pq.deleteM()); 
    while(!this->pq.isEmpty()){
        //estrazione del nodo di arrivo dell'arco di peso minimo
        int v= this->pq.deleteM();
        //maxEdge tiene traccia degli archi del MST ordinati in ordine crescente di costo
        this->maxEdge.insert(v,distTo[v]);

        //cout <<edgeTo[v] << " -> " << v << " c: " << distTo[v] << endl;

        scan(v);
    } 
}

//scan visita i veritici adiacenti a v
void Graph::scan(int v){
    this->marked[v]=true;

    list<Edge>::iterator adj = this->adj_list[v].begin();
    for (; adj != this->adj_list[v].end(); adj++){
        //w indica un nodo adiaciente a v e cost il relativo costo dell'arco
        int w=adj->getV();                  
        double cost=adj->getCost();
        //se w è già nel MST attualmente computato, non viene preso in considerazione
        if(this->marked[w]) continue;
          
        if(cost< this->distTo[w]){
            this->distTo[w]=cost;
            this->edgeTo[w] = v;
            /*se troviamo un costo dell'arco per andare a w che risulta essere minore
            rispetto a quello di cui siamo attualmente a conoscenza aggiorniamo il suo valore*/
            if(this->pq.contains(w)) {
                this->pq.decreaseKey(w,this->distTo[w]);
            }
            //altrimenti lo inserisci nella coda a priorità
            else{
                this->pq.insert(w,this->distTo[w]);
            }
        }
    }
}
//metodo per il calcolo della D minima necessaria per collegare la rete
double Graph::setSatellite(){
    //vettore per marcare i vertici su cui abbiamo disposto i canali satellitari
    vector<bool> satellite(V);
    //fintantoché possiamo assegnare canali satellitari prendiamo gli estremi dell'arco di peso massimo del MST
    while(this->S != 0){
        int w=this->maxEdge.getRoot(); //vertice di arrivo
        int v=this->edgeTo[w];  //vertice di partenza
        
        /*se v non ha un canale satellitare, gli viene assegnato marcandolo a true
        e inoltre viene diminuito il numero di canali satellittari rimanenti*/
        if(!satellite[v]){
            satellite[v]=true;
            this->S--;
        }
        /*stesso ragionamento per w, considerando inoltre che 
        se il numero di canali satellitari si è esaurito non possiamo assegnarlo a w*/
        if(!satellite[w] && this->S>=1){
            satellite[w]=true;
            this->S--;
        }
        /*una volta marcati entrambi gli estremi possiamo estrarre l'arco dalla coda a priorità 
        per considerare il successivo arco di peso massimo alla prossima interazione*/
        if(satellite[v] && satellite[w]){
            this->maxEdge.deleteM();
        }
    }
    //restituisce il peso dell'arco di costo massimo rimanente, corrispondente all D minima necessaria per collegare la rete
    return this->maxEdge.getValue(this->maxEdge.getRoot()); 
}

