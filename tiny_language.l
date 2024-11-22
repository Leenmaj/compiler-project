%{
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
    return BEGIN_PROGRAM;  /
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
}

"+" {
    return ADD;  
}

"*" {
    return MULT;  
}

"/" {
    return DIV; 
}

"=" {
    return EQ;  
}

"<>" {
    return NEQ;  
}

"<" {
    return LT; 
}

">" {
    return GT;  
}

"<=" {
    return LTE;  
}

">=" {
    return GTE;  
}

";" {
    return SEMICOLON; 
}

":" {
    return COLON; 
}

"," {
    return COMMA; 
}

"(" {
    return L_PAREN; 
}

")" {
    return R_PAREN;  
}

":=" {
    return ASSIGN;  
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


