%{
	#include <stdio.h>
    #include <stdbool.h>
    #include <stdlib.h>
    #include <string.h>
	#include "symb.tab.h"
	int yylex();
    void yyerror (char const *);
    bool controlloData(char* dataClassifica, char* dataTappa); 

    char *dataClassifica, *dataTappa, *nome;
    int nPettorale;
%}

%union {
	char *string;
	int intero;
}

%token <string> DATA_T CODICE_T SQUADRA_T DATA_TAPPA_T NOME_COGN_T CITTA
%token <intero> PETTORALE_T TEMPO
%token DATA SEP_SEZ_1 CODICE NOME_COGN SQUADRA PETTORALE SEP_ATL SEP_SEZ_2 TRATTINO APRI_P CHIUDI_P DUE_PUNTI FRECCIA

%start s 
%error-verbose

%%
s: data SEP_SEZ_1 elenco_ciclisti SEP_SEZ_2 lista_tappe
 ;

data: DATA DATA_T {dataClassifica= $2;}
    ;

elenco_ciclisti: elenco_ciclisti ciclista 
        | ciclista
        ;

ciclista: codice nome_cogn squadra n_pettorale SEP_ATL {insertCiclista(nPettorale,nome);
                                                        resizeHashTable();}
        ;

codice: CODICE CODICE_T
      ;

nome_cogn: NOME_COGN NOME_COGN_T {nome= $2;}
         ;

squadra: SQUADRA SQUADRA_T
       ;

n_pettorale: PETTORALE PETTORALE_T {nPettorale= $2;}
           ;

lista_tappe: lista_tappe tappa
           | tappa
           ;

tappa: competizione TRATTINO classifica
     ;

competizione: DATA_TAPPA_T TRATTINO CITTA TRATTINO CITTA {dataTappa= $1;}
            ;

classifica: classifica FRECCIA tempo 
          | tempo 
          ;

tempo: APRI_P PETTORALE_T DUE_PUNTI TEMPO CHIUDI_P {if((strncmp(dataClassifica, dataTappa, 5))==0) {insertTappa($2,$4);}
                                                    if(controlloData(dataClassifica,dataTappa)){ impostaClassificaParziale($2,$4);} 
                                                    }
     ;

%%

//restistuisce true quando la dataTappa è minore uguale alla dataClassifica
bool controlloData(char* dataClassifica, char* dataTappa){  
    int gc,gt,mc,mt;
    mc= ((dataClassifica[3]-'0')*10)+(dataClassifica[4]-'0');
    mt= ((dataTappa[3]-'0')*10)+(dataTappa[4]-'0');
    if(mt<mc)
        return true;
    else if(mt==mc){
        gc= ((dataClassifica[0]-'0')*10)+(dataClassifica[1]-'0');
        gt= ((dataTappa[0]-'0')*10)+(dataTappa[1]-'0');
        if(gt<=gc)
            return true;
    }
    return false;
}

void yyerror (char const *s) {
    fprintf(stderr, "Sono presenti degli errori sintattici\n%s\n", s);
}

int main() {
    start();
    if(yyparse() == 0){  //se non ci sono errori sintattici
        printTappa(dataClassifica);
        printClassificaParziale();
        freeAll();
    }
    return 0;
}