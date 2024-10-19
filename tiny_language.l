%{
#include "tiny_language.tab.h"
int column = 0; /* KEEP TRACK OF COULMN NUMBER*/

%}
/* KEEP TRACK OF LINE NUMBER*/
%option yylineno 

%%

"program"       { column += yyleng; return PROGRAM; }
"beginprogram"  { column += yyleng; return BEGIN_PROGRAM; }
"endprogram"    { column += yyleng; return END_PROGRAM; }
"integer"       { column += yyleng; return INTEGER; }
"array"         { column += yyleng; return ARRAY; }
"of"            { column += yyleng; return OF; }
"if"            { column += yyleng; return IF; }
"then"          { column += yyleng; return THEN; }
"endif"         { column += yyleng; return ENDIF; }
"else"          { column += yyleng; return ELSE; }
"while"         { column += yyleng; return WHILE; }
"loop"          { column += yyleng; return LOOP; }
"endloop"       { column += yyleng; return ENDLOOP; }
"read"          { column += yyleng; return READ; }
"write"         { column += yyleng; return WRITE; }
"and"           { column += yyleng; return AND; }     
"or"            { column += yyleng; return OR; }     
"not"           { column += yyleng; return NOT; }     
"true"          { column += yyleng; return TRUE; }   
"false"         { column += yyleng; return FALSE; }  

"-"             { column++; return SUB; }
"+"             { column++; return ADD; }
"*"             { column++; return MULT; }
"/"             { column++; return DIV; }

"="             { column++; return EQ; }
"<>"            { column += 2; return NEQ; }
"<"             { column++; return LT; }
">"             { column++; return GT; }
"<="            { column += 2; return LTE; }
">="            { column += 2; return GTE; }

";"             { column++; return SEMICOLON; }
":"             { column++; return COLON; }
","             { column++; return COMMA; }
"("             { column++; return L_PAREN; }
")"             { column++; return R_PAREN; }
":="            { column += 2; return ASSIGN; }

[ \t]+          { column += yyleng; }  /* Ignore whitespace just update column */
\n              { column = 0;}  /*  reset column number */

.       {
    fprintf(stderr, "Error:  at line %d, column %d unrecognized symbol %s\n", yylineno, column, yytext);
    exit(1);  /*    exit the program */
}



%%




int yywrap() {
    return 1;}




