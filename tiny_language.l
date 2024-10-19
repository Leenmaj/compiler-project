%{
#include "tiny_language.tab.h"


%}


%%
[ \t\n]+ ; /* Ignore whitespace */

"program"       return PROGRAM;
"beginprogram"  return BEGIN_PROGRAM;
"endprogram"    return END_PROGRAM;
"integer"       return INTEGER;
"array"         return ARRAY;
"of"            return OF;
"if"            return IF;
"then"          return THEN;
"endif"         return ENDIF;
"else"          return ELSE;
"while"         return WHILE;
"loop"          return LOOP;
"endloop"       return ENDLOOP;
"read"          return READ;
"write"         return WRITE;
"and"           return AND;     
"or"            return OR;     
"not"           return NOT;     
"true"          return TRUE;   
"false"         return FALSE;  



"-"             return MINUS;
"+"             return PLUS;
"*"             return MULT;
"/"             return DIV;

"="             return EQUAL;
"<>"            return NEQ;
"<"             return LT;
">"             return GT;
"<="            return LTE;
">="            return GTE;

";"             return SEMICOLON;
":"             return COLON;
","             return COMMA;
"("             return L_PAREN;
")"             return R_PAREN;
":="            return ASSIGN;


%%


int yywrap() {
    return 1;}






%%