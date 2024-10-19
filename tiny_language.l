%{
#include "tiny_language.tab.h"


%}
/* regular definitions */
delim [ \t\n]
ws {delim}+


%%

"program" return PROGRAM;
"endprogram" return END_PROGRAM;
"integer"              { return INTEGER; }
"array"                { return ARRAY; }
"of"                   { return OF; }
"if"                   {return IF;}
"then"                 { return THEN; }
"endif"                { return ENDIF; }
"else"                 { return ELSE; }
"while"                { return WHILE; }
"loop"                 { return LOOP; }
"endloop"              { return ENDLOOP; }
"read"                 { return READ; }
"write"                { return WRITE; }

"+"                   { return PLUS; }
"-"                   { return MINUS; }
"*"                   { return MULT; }
"/"                   { return DIV; }

"="                   { return EQUAL; }
"=="                  { return EQ; }
"<>"                  { return NEQ; }
"<"                   { return LT; }
"<="                  { return LE; }
">"                   { return GT; }
">="                  { return GE; }
"("                   { return LPAREN; }
")"                   { return RPAREN; }
";"                   { return SEMICOLON; }
":="                  { return ASSIGN; }


%%


int yywrap() {
    return 1;}






%%