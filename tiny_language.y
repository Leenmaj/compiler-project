%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare yylex() and yyerror()
int yylex(void);
void yyerror(const char *s);

// Declare yyin for input stream
extern FILE *yyin;
extern int yylineno; // Line number from lexer
extern char *yytext; // Current token text
%}

// Enable debugging support
%debug



%left ADD SUB
%left MULT DIV
%right ASSIGN
%left OR
%left AND
%right NOT
%left EQ NEQ LT GT LTE GTE
%union {
    int ival;   // For integer values
    char *sval; // For strings like identifiers
}


%token <sval> IDENT
%type <ival> type
%type <ival> declaration
%token <ival> NUMBER

%token PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE LOOP ENDLOOP READ WRITE VAR AND OR NOT TRUE FALSE
%token ADD SUB MULT DIV EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN ASSIGN

%%

program:
    PROGRAM IDENT SEMICOLON declarations BEGIN_PROGRAM statements END_PROGRAM
    {
        printf("Program parsed successfully.\n");
    }
    ;

declarations:
    declaration SEMICOLON declarations
    | /* empty */
    ;

declaration:
    IDENT COLON type
    {
        printf("Declared variable '%s' of type '%s'.\n", $1, ($3 == 1 ? "INTEGER" : "ARRAY"));
    }
    ;


type:
    INTEGER
    {
        $$ = 1; // 1 represents INTEGER type
    }
    | ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
    {
        printf("Array of size %d declared.\n", $3);
        $$ = 2; // 2 represents ARRAY type
    }
    ;

statements:
    statement SEMICOLON statements
    | statement
    | /* empty */
    ;

statement:
    assignment
    | READ IDENT
    | WRITE NUMBER
    ;

assignment:
    IDENT ASSIGN NUMBER
    {
        printf("Assignment: %s := %d\n", $1, $3);
    }
    ;



    

%%

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s at line %d, near '%s'\n", s, yylineno, yytext);
}

// Main function to parse input file
int main(int argc, char *argv[]) {
    extern int yydebug;
    yydebug = 1;  // Enable parser debugging

    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("File not found");
            return 1;
        }
        yyin = file;  // Set input stream
    } else {
        printf("Please provide an input file.\n");
        return 1;
    }

    yyparse();  // Start parsing
    return 0;
}
