/* Declarations C */

%{
#include <stdio.h>
#include <string.h>
#include "analyse_syntaxique.tab.h"
int ligne = 1, colonne = 0, i;
%}

/* Definitions regulieres */

entier "-"?[0-9]+

operArithmetique "+"|"-"|"*"|"/"

blanc " "

operComp "<"|">"|"<="|">="|"="|"!="

identificateur [a-z](([a-z]|[0-9]|"_")*([a-z]|[0-9]))?

commentaire ("/*"(.|\n)*"*/")|("//"[^\n]*)

/* Regles de traduction */

%%
PROGRAM { colonne += yyleng; return PROGRAM;}
BEGIN { colonne += yyleng; return Begin;}
END { colonne += yyleng; return END;}
IF { colonne += yyleng; return IF;}
ELSE { colonne += yyleng; return ELSE;}
THEN { colonne += yyleng; return THEN;}
FUNCTION { colonne += yyleng; return FUNCTION;}
RETURN { colonne += yyleng; return RETURN;}
VAR {colonne += yyleng; return VAR;}
INT { colonne += yyleng; return type;}
":=" {colonne += yyleng; return oprAff;}
"," { colonne++; return coma; }
"!" { colonne += yyleng; return not;}
"(" { colonne++; return parg;}
")" { colonne++; return pard;}
";" { colonne++; return pvg;}
":" { colonne++; return dPoint;}
"||" { colonne++; return or;}
"&&" { colonne++; return and;}
[\t] {colonne += yyleng;}
\n {ligne++; colonne=0;}
{blanc} {colonne++;}
{operComp} { colonne += yyleng; return operComp;}
{identificateur} { colonne += yyleng; return idf;}
{operArithmetique} { colonne += yyleng; return operArithmetique;}
{entier} { colonne += yyleng; return entier;}
{commentaire} {
    for (i=0; yytext[i] != '\0'; i++) {
        if (yytext[i]  == '\n') {
            ligne++; colonne=0;
        }
        else colonne++;
    }
}

. { printf("erreur Lexicale a la ligne %d et colonne %d \n", ligne, colonne); colonne++; }

%%

int yywrap(void){
    return 0;
}