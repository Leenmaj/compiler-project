%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *msg);
int yylex();  // Declare yylex

extern FILE *yyin;  // Declare yyin as an external variable


int currLine = 1;  // Define currLine
int currPos = 1;   // Define currPos
%}

%define parse.error verbose

%union {
    int ival;
    char *sval;
}

%token PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF READ WRITE IF THEN ELSE ENDIF WHILE LOOP ENDLOOP ADD SUB MULT DIV EQ NEQ LT GT LTE GTE ASSIGN COMMA COLON SEMICOLON L_PAREN R_PAREN
%token <sval> IDENT
%token <ival> NUMBER
%token VAR AND OR NOT TRUE FALSE

%left OR
%left AND
%right NOT

%%

prog:
    PROGRAM IDENT SEMICOLON declarations BEGIN_PROGRAM statements END_PROGRAM
        { 
            printf("prog->PROGRAM IDENT SEMICOLON declarations BEGIN_PROGRAM statements END_PROGRAM\n");
            printf("Program parsed successfully.\n"); 
        }
    ;

declarations:
    /* epsilon */
    { printf("declarations -> epsilon\n"); }
    | declaration SEMICOLON declarations
    { printf("declarations -> declaration SEMICOLON declarations\n"); }
    ;

declaration:
    identifiers COLON INTEGER
        { printf("declaration -> identifiers: INTEGER\n"); }
    | identifiers COLON ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
        { printf("declaration -> identifiers: ARRAY OF INTEGER\n"); }
    ;


identifiers:
    IDENT
        { printf("identifiers -> IDENT\n"); }
    | IDENT COMMA identifiers
        { printf("identifiers -> IDENT COMMA IDENTIFIERS\n"); }
    ;

statements:
    /* epsilon */
      { printf("statements -> epsilon\n"); }
    | statement SEMICOLON statements
        { printf("Parsed statement.\n"); }
    ;

statement:
    var ASSIGN expression
        { printf("statement -> var ASSIGN expression\n"); }
    | IF condition THEN statements ENDIF
        { printf("statement -> IF condition THEN statements ENDIF\n"); }
    | IF condition THEN statements ELSE statements ENDIF
        { printf("statement -> IF condition THEN statements ELSE statements ENDIF\n"); }
    | WHILE condition LOOP statements ENDLOOP
        { printf("statement -> WHILE condition LOOP statements ENDLOOP\n"); }
    | READ vars
        { printf("statement -> READ vars\n"); }
    | WRITE vars
        { printf("statement -> WRITE vars\n"); }
    ;

condition:
    condition OR condition
        { printf("condition -> condition OR condition\n"); }
    | condition AND condition
        { printf("condition -> condition AND condition\n"); }
    | NOT condition
        { printf("condition -> NOT condition\n"); }
    | expression comp_op expression
        { printf("condition -> expression comp_op expression\n"); }
    | TRUE
        { printf("condition -> TRUE\n"); }
    | FALSE
        { printf("condition -> FALSE\n"); }
    ;

comp_op:
    EQ
        { printf("comp_op -> EQ\n"); }
    | NEQ
        { printf("comp_op -> NEQ\n"); }
    | LT
        { printf("comp_op -> LT\n"); }
    | LTE
        { printf("comp_op -> LTE\n"); }
    | GT
        { printf("comp_op -> GT\n"); }
    | GTE
        { printf("comp_op -> GTE\n"); }
    ;

expression:
    term
        { printf("expression -> term\n"); }
    | term ADD expression
        { printf("expression -> term ADD expression\n"); }
    | term SUB expression
        { printf("expression -> term SUB expression\n"); }
    ;

term:
    factor
        { printf("term -> factor\n"); }
    | factor MULT term
        { printf("term -> factor MULT term\n"); }
    | factor DIV term
        { printf("term -> factor DIV term\n"); }
    ;

factor:
    NUMBER
        { printf("factor -> NUMBER\n"); }
    | IDENT
        { printf("factor -> IDENT\n"); }
    | L_PAREN expression R_PAREN
        { printf("factor -> (expression)\n"); }
    | array_subscript
        { printf("factor -> array_subscript\n"); }
    ;

var:
    IDENT
        { printf("var -> IDENT\n"); }
    | array_subscript
        { printf("var -> array_subscript\n"); }
    ;

array_subscript:
    IDENT L_PAREN expression R_PAREN
        { printf("array_subscript -> IDENT L_PAREN expression R_PAREN\n"); }
    ;


vars:
    var
        { printf("vars -> var\n"); }
    | var COMMA vars
        { printf("vars -> var COMMA vars\n"); }
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            fprintf(stderr, "Error: Unable to open file %s\n", argv[1]);
            return 1;
        }
    }
    yyparse();
    return 0;
}

void yyerror(const char *msg) {
       /* implement your error handling */


}
