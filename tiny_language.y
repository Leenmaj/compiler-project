%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare yylex() and yyerror()
int yylex(void);
void yyerror(const char *s);

// Declare yyin for input stream
extern FILE *yyin;
%}

// Precedence and associativity rules
%left ADD SUB  // Left-associative addition and subtraction
%left MULT DIV  // Left-associative multiplication and division
%right ASSIGN  // Right-associative assignment

// Token definitions (these should match those in tiny_language.l)
%token PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE LOOP ENDLOOP READ WRITE VAR AND OR NOT TRUE FALSE IDENT NUMBER ADD SUB MULT DIV EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN ASSIGN

%%

// Grammar rules

program:
    PROGRAM IDENT SEMICOLON declarations statements END_PROGRAM
    ;

declarations:
    VAR declaration SEMICOLON declarations
    | /* empty */
    ;

declaration:
    IDENT COLON type
    ;

type:
    INTEGER
    | ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
    ;

conditional:
    IF condition THEN statements ENDIF
    | IF condition THEN statements ELSE statements ENDIF
    ;

loop:
    WHILE condition LOOP statements ENDLOOP
    ;

statements:
    statement SEMICOLON statements
    | statement
    | /* empty */
    ;

statement:
    assignment
    | conditional
    | loop
    | READ IDENT
    | WRITE expression
    ;

expression:
    expression ADD term
    | expression SUB term
    | term
    ;

term:
    term MULT factor
    | term DIV factor
    | factor
    ;

factor:
    NUMBER
    | IDENT
    | L_PAREN expression R_PAREN
    ;

condition:
    TRUE
    | FALSE
    | expression relational_operator expression
    | NOT condition
    | condition AND condition
    | condition OR condition
    | /* empty */
    ;

relational_operator:
    EQ
    | NEQ
    | LT
    | GT
    | LTE
    | GTE
    ;

assignment:
    IDENT ASSIGN expression
    ;

%%

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

// Main function to parse input file
int main(int argc, char *argv[]) {
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
