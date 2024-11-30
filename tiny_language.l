%{
#include "y.tab.h"  // Include Bison-generated header for token definitions

int column = 0; /* KEEP TRACK OF COLUMN NUMBER */
%}

/* KEEP TRACK OF LINE NUMBER */
%option yylineno

%%

"--"[^\n]* {
    column += yyleng;
} // ignore comment

"program" {
    column += yyleng;
    return PROGRAM;  
}

"beginprogram" {
    column += yyleng;
    return BEGIN_PROGRAM;  
}

"endprogram" {
    column += yyleng;
    return END_PROGRAM;  
}

"integer" {
    column += yyleng;
    return INTEGER;  
}

"array" {
    column += yyleng;
    return ARRAY;  
}

"of" {
    column += yyleng;
    return OF;  
}

"if" {
    column += yyleng;
    return IF; 
}

"then" {
    column += yyleng;
    return THEN; 
}

"endif" {
    column += yyleng;
    return ENDIF; 
}

"else" {
    column += yyleng;
    return ELSE; 
}

"while" {
    column += yyleng;
    return WHILE; 
}

"loop" {
    column += yyleng;
    return LOOP; 
}

"endloop" {
    column += yyleng;
    return ENDLOOP; 
}

"read" {
    column += yyleng;
    return READ;  
}

"write" {
    column += yyleng;
    return WRITE;  
}

"var" {
    column += yyleng;
    return VAR;  // Return VAR token (for ambiguity)
}

"and" {
    column += yyleng;
    return AND;  
}

"or" {
    column += yyleng;
    return OR;  
}

"not" {
    column += yyleng;
    return NOT;  
}

"true" {
    column += yyleng;
    return TRUE;  
}

"false" {
    column += yyleng;
    return FALSE;  
}

[a-zA-Z]([a-zA-Z0-9_]{0,6}[a-zA-Z0-9])? {
    column += yyleng;
    return IDENT; 
}

[0-9][a-zA-Z0-9_]*[a-zA-Z] {
    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", yylineno, column, yytext);
    exit(1);
}

"_"[a-zA-Z0-9_]*[a-zA-Z] {
    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" cannot start with an underscore\n", yylineno, column, yytext);
    exit(1);
}

[a-zA-Z][a-zA-Z0-9_]*"_" {
    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", yylineno, column, yytext);
    exit(1);
}

[0-9]+ {
    column += yyleng;
    return NUMBER; 
}

"-" {
    return SUB; 
    column += yyleng; 
}

"+" {
    return ADD;  
    column += yyleng; 
}

"*" {
    return MULT;  
    column += yyleng; 
}

"/" {
    return DIV; 
    column += yyleng; 
}

"=" {
    return EQ;  
    column += yyleng; 
}

"<>" {
    return NEQ;  
    column += yyleng; 
}

"<" {
    return LT; 
    column += yyleng; 
}

">" {
    return GT;  
    column += yyleng; 
}

"<=" {
    return LTE;  
    column += yyleng; 
}

">=" {
    return GTE;  
    column += yyleng; 
}

";" {
    return SEMICOLON; 
    column += yyleng; 
}

":" {
    return COLON; 
    column += yyleng; 
}

"," {
    return COMMA; 
    column += yyleng; 
}

"(" {
    return L_PAREN; 
    column += yyleng; 
}

")" {
    return R_PAREN;  
    column += yyleng; 
}

":=" {
    return ASSIGN;  
    column += yyleng; 
}

[ \t]+ {
    column += yyleng; 
}

\n {
    column = 0;  // Reset column number
}

. {
    fprintf(stderr, "Error:  at line %d, column %d unrecognized symbol %s\n", yylineno, column, yytext);
    exit(1);  // Exit the program on error
}

%%

int yywrap() {
    return 1;
}


