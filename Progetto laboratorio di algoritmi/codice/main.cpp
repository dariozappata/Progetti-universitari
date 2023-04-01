#include <iostream>
#include <fstream>
#include <vector>
#include <limits>
#include "Graph.h"
using namespace std;

//funzione utilizzata per saltare righe dal file di testo quando avviene un errore di input
void skipLine(ifstream &in, int n){
    for(int i=0;i<n;i++){
        in.ignore(numeric_limits<std::streamsize>::max(),'\n');
    }
}

int main(){
    int N, S, V, x, y;
    ifstream in("input.txt");
    if(in){
        if (in.eof()){
            cout << "File empty\n";
        }
        else{
            in >> N;
            //ciclo per scandire le operazioni di acquisizione tante volte quanto il numero di test N preso da input 
            for (int i = 0; i < N; i++){
                in >> S;
                in >> V;
                //controllo sul numero di canali satellitari, in caso di errore salta al test successivo
                if (S < 1 || S > 100){
                    cout << "Errore nel test " << i+1 <<"! Inserire un numero di canali satellitari compreso tra 1 e 100!" << endl<< endl;
                    skipLine(in,V+1);
                    continue;
                }
               //controllo sul numero di avamposti, in caso di errore salta al test successivo
                if (V <= S || V > 500){
                    cout << "Errore nel test " << i+1 <<"! Inserire un numero di avamposti maggiore del numero di satelliti e minore di 500!" << endl<< endl;
                    skipLine(in,V+1);
                    continue;
                }

                //utilizziamo la classe Coords per acquisire le coordinate (x,y)
                vector<Coords> outpost;
                bool error=false;
                for (int j = 0; j < V; j++){
                    in >> x >> y;
                    //controllo sulle coordinate
                    if (x < 0 || x > 10000 || y < 0 || y > 10000){
                        error=true;
                        cout << "Errore nel test " << i+1 <<"! Inserire coordinate comprese tra 0 e 10000!" << endl<< endl;
                        skipLine(in,V-j);
                        break;
                    }
                    outpost.push_back(Coords (x,y));
                }
                //in caso di errore sulle coordinate salta al test successivo
                if(error) continue;

                //creazione del grafo
                Graph grafo = Graph(S,V,outpost);

                //grafo.printGraph();

                //calcolo del MST
                grafo.PrimMST();

                cout << "Test " << i+1 << ": " <<endl;
                //stampa della D minima necessaria per collegare la rete
                cout << grafo.setSatellite() << setprecision(2) << fixed << endl;
                //setprecision(2) << fixed è usata per visualizzare soltanto 2 cifre dopo la virgola
                cout << endl;
            }
        }
    }
}