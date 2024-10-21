%{

int column = 0; /* KEEP TRACK OF COULMN NUMBER*/

%}
/* KEEP TRACK OF LINE NUMBER*/
%option yylineno 

%%
"--"[^\n]* { column += yyleng; } // ignore comment
"program"       { column += yyleng; printf("PROGRAM\n"); }
"beginprogram"  { column += yyleng; printf("BEGIN_PROGRAM\n"); }
"endprogram"    { column += yyleng; printf("END_PROGRAM\n"); }
"integer"       { column += yyleng; printf("INTEGER\n"); }
"array"         { column += yyleng; printf("ARRAY\n"); }
"of"            { column += yyleng; printf("OF\n"); }
"if"            { column += yyleng; printf("IF\n"); }
"then"          { column += yyleng; printf("THEN\n"); }
"endif"         { column += yyleng; printf("ENDIF\n"); }
"else"          { column += yyleng; printf("ELSE\n"); }
"while"         { column += yyleng; printf("WHILE\n"); }
"loop"          { column += yyleng; printf("LOOP\n"); }
"endloop"       { column += yyleng; printf("ENDLOOP\n"); }
"read"          { column += yyleng; printf("READ\n"); }
"write"         { column += yyleng; printf("WRITE\n"); }
"and"           { column += yyleng; printf("AND\n"); }     
"or"            { column += yyleng; printf("OR\n"); }     
"not"           { column += yyleng; printf("NOT\n"); }     
"true"          { column += yyleng; printf("TRUE\n"); }   
"false"         { column += yyleng; printf("FALSE\n"); }   



[a-zA-Z]([a-zA-Z0-9_]{0,6}[a-zA-Z0-9])?   {     printf("IDENT %s\n", yytext);
    column += yyleng;
}


[0-9][a-zA-Z0-9_]*[a-zA-Z] {

    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", yylineno, column, yytext);

    /*exit(1);*/
}

"_"[a-zA-Z0-9_]*[a-zA-Z] {

    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" cannot start with an underscore\n", yylineno, column, yytext);

    /*exit(1);*/
}

[a-zA-Z][a-zA-Z0-9_]*"_" {

    fprintf(stderr, "Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", yylineno, column, yytext);

   /* exit(1);*/
}


[0-9]+   {
    printf("NUMBER %s\n", yytext);
    column += yyleng;
}

"-"             { printf("SUB\n"); }
"+"             { printf("ADD\n"); }
"*"             { printf("MULT\n"); }
"/"             { printf("DIV\n"); }

"="             { printf("EQ\n"); }
"<>"            { printf("NEQ\n"); }
"<"             { printf("LT\n"); }
">"             { printf("GT\n"); }
"<="            { printf("LTE\n"); }
">="            { printf("GTE\n"); }

";"             { printf("SEMICOLON\n"); }
":"             { printf("COLON\n"); }
","             { printf("COMMA\n"); }
"("             { printf("L_PAREN\n"); }
")"             { printf("R_PAREN\n"); }
":="            { printf("ASSIGN\n"); }


[ \t]+          { column += yyleng; }  /* Ignore whitespace just update column */

\n              { column = 0;}  /*  reset column number */

. {
    fprintf(stderr, "Error:  at line %d, column %d unrecognized symbol %s\n", yylineno, column, yytext);
    printf(yytext);
    /*exit(1);*/  /*    exit the program */
}


%%




int yywrap() {
    return 1;}



int main(int argc, char *argv[]) {
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Failed to open file");
            return 1;
        }
    } else {
        printf("Please provide an input file.\n");
        return 1;
    }

    yylex();
}
