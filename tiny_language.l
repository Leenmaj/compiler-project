%{
#include "y.tab.h"  // Include Bison-generated header for token definitions
#include <stdlib.h>
#include <string.h>
int column = 0;     // Keep track of column number
%}

%option yylineno

%%

"--"[^\n]* {
    column += yyleng;
} // Ignore comments

"program" { return PROGRAM; }
"beginprogram" { return BEGIN_PROGRAM; }
"endprogram" { return END_PROGRAM; }
"integer" { return INTEGER; }
"array" { return ARRAY; }
"of" { return OF; }
"if" { return IF; }
"then" { return THEN; }
"endif" { return ENDIF; }
"else" { return ELSE; }
"while" { return WHILE; }
"loop" { return LOOP; }
"endloop" { return ENDLOOP; }
"read" { return READ; }
"write" { return WRITE; }
"var" { return VAR; }
"and" { return AND; }
"or" { return OR; }
"not" { return NOT; }
"true" { return TRUE; }
[a-zA-Z][a-zA-Z0-9_]* {
    yylval.sval = strdup(yytext); // Allocate memory for string value
    return IDENT;                // Return IDENT token
}

[0-9]+ {
    yylval.ival = atoi(yytext);  // Convert string to integer
    return NUMBER;               // Return NUMBER token
}

"-" { return SUB; }
"+" { return ADD; }
"*" { return MULT; }
"/" { return DIV; }
"=" { return EQ; }
"<>" { return NEQ; }
"<" { return LT; }
">" { return GT; }
"<=" { return LTE; }
">=" { return GTE; }

";" { return SEMICOLON; }
":" { return COLON; }
"," { return COMMA; }
"(" { return L_PAREN; }
")" { return R_PAREN; }
":=" { return ASSIGN; }

[ \t]+ { column += yyleng; }  // Ignore whitespace
\n { column = 0; }           // Reset column number on new line

. {
    fprintf(stderr, "Error: at line %d, column %d unrecognized symbol %s\n", yylineno, column, yytext);
    exit(1);  // Exit the program on error
}

%%

int yywrap() {
    return 1;  // End of input handling
}
