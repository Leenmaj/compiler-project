%{
#include <stdio.h>
#include <stdlib.h>

int yylex();            // Declare yylex function
int yyerror(char *s);   // Declare yyerror function
%}


%token EQUAL NEQ LT  GT  LTE GTE

%%
relational_operator:
    EQUAL
    | NEQ
    | LT
    | GT
    | LTE
    | GTE
    ;



%%
int main() {

    yyparse();   // Call the parser
    return 0;
}

int yyerror(char *s) {
    // define eror function
    return 0;
}