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

%token pvg not and coma or operComp type operArithmetique parg oprAff IF THEN PROGRAM Begin END FUNCTION RETURN dPoint ELSE VAR eql pard
%token <in> entier
%token <str> idf

%start Programme

%%
Programme : PROGRAM idf Declaration Begin  Inst  END {printf("syntaxe correcte\n"); YYACCEPT;}
;

Declaration : VAR idf dPoint type
| VAR idf dPoint type pvg
| VAR idf dPoint type pvg Declaration
;

Inst : affectation Inst 
| Inst_IF Inst  
| affectation 
| Inst_IF 
| function
| function Inst
| RETURN Inst
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


Inst_IF : IF parg  Liste_expres_logique  pard THEN Inst ELSE Inst
| IF Expres_logique THEN Inst ELSE  Inst
| IF parg  Liste_expres_logique  pard THEN Inst
| IF Expres_logique THEN Inst
;

function : FUNCTION idf parg dec_param pard dPoint type Begin Inst END
| FUNCTION idf parg pard dPoint type Begin Inst END
;

dec_param : idf dPoint type coma dec_param
| idf dPoint type
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

int yyerror(char* msg){
	printf("%s line %d column %d\n", msg, ligne, colonne);
	return 0;
}

int main(){
	yyparse();
	return 0;
}