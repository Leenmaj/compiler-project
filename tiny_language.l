%{
#include "tiny_language.tab.h"


%}
/* regular definitions */
delim [ \t\n]
ws {delim}+


%%


{ws} {/* no action and no return */}
"--".*    { /* ignore   comments}
"program" return PROGRAM;
"if" return IF;
"endprogram" return END_PROGRAM;


%%


int yywrap() {
    return 1;}






%%