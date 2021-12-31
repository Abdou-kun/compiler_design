%{
#include <stdio.h>
extern int colonne;
extern int ligne;
int yyparse();
int yylex();
int yyerror(char *s);
%}

%union{
	char *str;
	int in;
}

%token pvg coma type parg oprAff IF THEN PROGRAM Begin END FUNCTION RETURN dPoint ELSE VAR pard
%token <in> entier
%token <str> idf

%left or
%left and
%left not
%left operArithmetique
%left operComp

%start Programme

%%
Programme : PROGRAM idf Declaration Inst END pvg {printf("syntaxe correcte\n"); YYACCEPT;}
;

Declaration : VAR ListeVar
|
;

ListeVar : idf dPoint type
| idf dPoint type pvg
| idf dPoint type pvg ListeVar
;

Inst : affectation Inst 
| Inst_IF Inst
| function Inst  
| affectation 
| Inst_IF 
| function
| RETURN Exp
| call_function Inst
| call_function
; 

affectation : idf  oprAff  Exp  pvg
; 

Exp : val  operArithmetique  Exp 
| val 
| parg  Exp  pard
;

val : idf
| entier
;


Inst_IF : IF parg  Liste_expres_logique  pard THEN Inst ELSE Begin Inst END
| IF parg  Liste_expres_logique  pard THEN Inst
| IF Expres_logique THEN Inst
| IF Expres_logique THEN Begin Inst END
| IF Expres_logique THEN Inst ELSE Inst
| IF Expres_logique THEN Inst ELSE Begin Inst END
;

function : FUNCTION idf parg dec_param pard dPoint type Begin Inst END
;

dec_param : idf dPoint type coma dec_param
| idf dPoint type
|
;

call_function : idf parg pard
| idf parg call_param pard
;

call_param : Exp
| Exp coma call_param
;

Liste_expres_logique : Expres_logique  operLog  Liste_expres_logique
| not Liste_expres_logique
| parg Liste_expres_logique pard
| Expres_logique 
;

Expres_logique : Exp  operComp  Exp
;

operLog : and | or
;

%%

int yyerror(char* msg) {
	printf("%s line %d column %d\n", msg, ligne, colonne);
	return 0;
}

int main() {
	yyparse();
	return 0;
}