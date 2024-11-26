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
    char *idlist;   // For lists of identifiers or expr list
}

%token <sval> IDENT
%token <ival> NUMBER
%type <ival> program declarations declaration type statement statements assignment conditional loop condition relational_operator expression term factor
%type <idlist> IDENT_LIST  EXPRESSION_LIST
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
        printf("program -> PROGRAM IDENT SEMICOLON declarations BEGIN_PROGRAM statements END_PROGRAM\n");
        //printf("Parsing the program named '%s'.\n", $2);not sure if we really need this
    }
    ;

declarations:
    declaration SEMICOLON declarations
    {
    printf("declarations -> declaration SEMICOLON declarations\n");
    }
    | /* empty */ 
    { 
    printf("declarations -> ε\n");
    $$ = 0; 
    }
    ;

declaration:
    IDENT_LIST COLON type
    {
        printf("declaration -> IDENT_LIST COLON type\n");
    //  printf("Declared variables '%s' of type '%s'.\n", $1, ($3 == 1 ? "INTEGER" : "ARRAY")); not sure if we need this as well
        free($1); // Free memory for the identifier list
    }
    ;


IDENT_LIST:
    IDENT
    {
         
        printf("IDENT_LIST -> IDENT\n");
    
        $$ = strdup($1); //copy the identifier to store its value as $1 may be reused or overwritten later
    }
    | IDENT_LIST COMMA IDENT
     {
        $$ = malloc(strlen($1) + strlen($3) + 3); //allocate memory for the list
        sprintf($$, "%s, %s", $1, $3); //concatenate ident
        printf("IDENT_LIST -> IDENT_LIST COMMA IDENT\n");
        free($1); //free the previous list memory
    }
    ;
 EXPRESSION_LIST:
     expression
    {
        $$ = malloc(32); // Allocate space for a single expression
        if ($$ == NULL) {
            yyerror("Memory allocation failed");
            exit(1);
        }
        sprintf($$, "%d", $1); // Store the numeric value as a string
        printf("EXPRESSION_LIST -> expression (%s)\n", $$);
    }
  | EXPRESSION_LIST COMMA expression
    {
        $$ = malloc(strlen($1) + 32); // Allocate space for the new concatenated list
          if ($$ == NULL) {
            yyerror("Memory allocation failed");
            exit(1);
        }
        sprintf($$, "%s, %d", $1, $3); // Append the new expression to the existing list
        printf("EXPRESSION_LIST -> EXPRESSION_LIST COMMA expression (%s)\n", $$);
        free($1); // Free the memory allocated for the old list
    }
    ;


type:
    INTEGER
    {
        printf("type -> INTEGER\n");
        //printf("The type was parsed as INTEGER.\n");not sure we need this 3
        $$ = 1; // 1 represents INTEGER type
    }
    | ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
    {
        printf("type -> ARRAY L_PAREN NUMBER R_PAREN OF INTEGER\n");
        //printf("Parsed an ARRAY of size %d.\n", $3);
        //printf("Array of size %d declared.\n", $3);
        $$ = 2; // 2 represents ARRAY type
    }
    ;

statements:
    statement SEMICOLON statements
    {
        printf("statements -> statement SEMICOLON statements\n");
       // printf("Parsed a statement followed by more statements.\n");   
    }
    | /* empty */ {
        printf("statements -> ε\n");
       // printf("No further statements found.\n");
         $$ = 0; } //without this parsers might produce warnings or undefined behaviour
    ;

statement:
    assignment
     {
        printf("statement -> assignment\n");
    }
    | conditional  
    {
        printf("statement -> conditional\n");
    }
    | loop
     {
        printf("statement -> loop\n");
    }
    | READ IDENT_LIST
    {   printf("statement -> READ IDENT_LIST\n");
        printf("Read operation for variables: %s\n", $2);
        free($2); //free memory after use
    }
    | WRITE EXPRESSION_LIST
    {
        printf("statement -> WRITE EXPRESSION_LIST\n");
        printf("Write operation for expressions: %s\n", $2);
        free($2);
    }
    ;

assignment:
    IDENT ASSIGN expression
    {
        printf("assignment -> IDENT ASSIGN expression\n");
    }
    | IDENT L_PAREN expression R_PAREN ASSIGN expression
    {
        printf("assignment -> IDENT L_PAREN expression R_PAREN ASSIGN expression\n");
        //printf("Array assignment: %s[%d] := %d\n", $1, $3, $6);
    }
    ;


    loop:
    WHILE condition LOOP statements ENDLOOP
    {
        printf("loop -> WHILE condition LOOP statements ENDLOOP\n");
        printf("While loop evaluated.\n");
    }
    ;

conditional:
    IF condition THEN statements ENDIF
    {
        printf("conditional -> IF condition THEN statements ENDIF\n");
        printf("Conditional statement evaluated (without ELSE).\n");
    }
    | IF condition THEN statements ELSE statements ENDIF
    {
        printf("conditional -> IF condition THEN statements ELSE statements ENDIF\n");
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
            

        // to print relational operators need to map to readable strings
        const char *op_str = "";
        switch ($2) {
            case LT: op_str = "<"; break;
            case LTE: op_str = "<="; break;
            case GT: op_str = ">"; break;
            case GTE: op_str = ">="; break;
            case EQ: op_str = "=="; break;
            case NEQ: op_str = "!="; break;
        }

        //printing the relational expression
      printf("Relational expression: %d %s %d = %d\n", $1, op_str, $3, $$);
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
    | IDENT 
    { 
        //printf("Referenced variable: %s\n", $1); $$ = 0; /* Placeholder */ 
        $$ = 0; //placeholder for variable evaluation
    }
    | IDENT L_PAREN expression R_PAREN
      { 
          //printf("Array access: %s[%d]\n", $1, $3); 
          $$ = 0; /* Placeholder for array access evaluation */
      }
    | L_PAREN expression R_PAREN 
    {
         $$ = $2;
          }
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
