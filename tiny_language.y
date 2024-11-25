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

%debug

%union {
    int ival;   // For integer values
    char *sval; // For strings like identifiers
}

%token <sval> IDENT
%token <ival> NUMBER
%type <ival> program declarations declaration type statement statements assignment conditional loop condition relational_operator expression term factor

%token PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE LOOP ENDLOOP READ WRITE VAR AND OR NOT TRUE FALSE 
%token ADD SUB MULT DIV EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN ASSIGN

%left ADD SUB
%left MULT DIV
%right ASSIGN
%left OR
%left AND
%right NOT
%left EQ NEQ LT GT LTE GTE

%%

program:
    PROGRAM IDENT SEMICOLON declarations BEGIN_PROGRAM statements END_PROGRAM
    {
        printf("Program parsed successfully.\n");
    }
    ;

declarations:
    declaration SEMICOLON declarations
    | /* empty */ { $$ = 0; }
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
    | /* empty */ { $$ = 0; }
    ;

statement:
    assignment
    | conditional
    | loop
    | READ IDENT
    {
        printf("Read operation for variable: %s\n", $2);
    }
    | WRITE expression
    {
        printf("Write operation for value: %d\n", $2);
    }
    ;

assignment:
    IDENT ASSIGN expression
    {
        printf("Assignment: %s := %d\n", $1, $3);
    }
    | IDENT L_PAREN expression R_PAREN ASSIGN expression
    {
        printf("Array assignment: %s[%d] := %d\n", $1, $3, $6);
    }
    ;
    loop:
    WHILE condition LOOP statements ENDLOOP
    {
        printf("While loop evaluated.\n");
    }
    ;

conditional:
    IF condition THEN statements ENDIF
    {
        printf("Conditional statement evaluated (without ELSE).\n");
    }
    | IF condition THEN statements ELSE statements ENDIF
    {
        printf("Conditional statement evaluated (with ELSE).\n");
    }
    ;



condition:
    condition OR condition
    {
        $$ = $1 || $3;
        printf("Logical OR: %d OR %d = %d\n", $1, $3, $$);
    }
    | condition AND condition
    {
        $$ = $1 && $3;
        printf("Logical AND: %d AND %d = %d\n", $1, $3, $$);
    }
    | expression relational_operator expression
    {
        switch ($2) {
            case LT: $$ = $1 < $3; break;
            case LTE: $$ = $1 <= $3; break;
            case GT: $$ = $1 > $3; break;
            case GTE: $$ = $1 >= $3; break;
            case EQ: $$ = $1 == $3; break;
            case NEQ: $$ = $1 != $3; break;
            default: yyerror("Invalid relational operator");
        }
        printf("Relational expression: %d %d %d = %d\n", $1, $2, $3, $$);
    }
    | TRUE { $$ = 1; }
    | FALSE { $$ = 0; }
    
    ;

relational_operator:
    EQ  { $$ = EQ; }
    | NEQ { $$ = NEQ; }
    | LT  { $$ = LT; }
    | GT  { $$ = GT; }
    | LTE { $$ = LTE; }
    | GTE { $$ = GTE; }
    ;



expression:
    expression ADD term { $$ = $1 + $3; }
    | expression SUB term { $$ = $1 - $3; }
    | term { $$ = $1; }
    ;

factor:
    NUMBER { $$ = $1; }
    | IDENT { printf("Referenced variable: %s\n", $1); $$ = 0; /* Placeholder */ }
    | IDENT L_PAREN expression R_PAREN
      { 
          printf("Array access: %s[%d]\n", $1, $3); 
          $$ = 0; /* Placeholder */
      }
    | L_PAREN expression R_PAREN { $$ = $2; }
    ;

term:
    term MULT factor { $$ = $1 * $3; }
    | term DIV factor
    {
        $$ = $1 / $3;
    }
    | factor { $$ = $1; }
    ;

%%

int ywrap() {
    return 1;  // Return 1 to indicate end of input
}

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s at line %d, near '%s'\n", s, yylineno, yytext);
}

// Main function to parse input file
int main(int argc, char *argv[]) {
    extern int yydebug;
    yydebug = 0;  // Enable parser debugging

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
