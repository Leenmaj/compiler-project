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
    | error
    {
        yyerror("Invalid declaration or missing semicolon.");
        yyerrok; // Recover and continue parsing
    }
    ;

declaration:
    IDENT COLON type
    {
        printf("Declared variable '%s' of type '%s'.\n", $1, ($3 == 1 ? "INTEGER" : "ARRAY"));
    }
    | error
    {
        yyerror("Invalid declaration syntax.");
        yyerrok;
    }
    ;

type:
    INTEGER
    {
        $$ = 1; // Represents INTEGER type
    }
    | ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
    {
        if ($3 <= 0) {
            yyerror("Array size must be positive.");
            $$ = 2; // Assign a default value to continue parsing
        } else {
            printf("Array of size %d declared.\n", $3);
            $$ = 2; // Represents ARRAY type
        }
    }
    | error { yyerror("Expected type (INTEGER or ARRAY)."); yyerrok;}
  ;


statements:
    statement SEMICOLON statements
    {
        printf("Parsed a statement followed by a semicolon.\n");
    }
    | statement
    {
        yyerror("Missing semicolon after statement.");
        yyerrok; // Recover and continue parsing
    }
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
    | error{ yyerror("Invalid statement."); yyerrok; }
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
    | IDENT EQ expression
    {
        yyerror(":= expected");
        yyerrok; 
    }
    | IDENT L_PAREN expression R_PAREN EQ expression
    {
        yyerror(":= expected");
        yyerrok; 
    }
    | IDENT ASSIGN error
    {
        yyerror("Invalid expression in assignment.");
        yyerrok; 
    }
    | IDENT L_PAREN expression R_PAREN ASSIGN error
    {
        yyerror("Invalid expression in array assignment.");
        yyerrok; 
    }
    | error
    {
        yyerror("Invalid assignment syntax.");
        yyerrok; 
    }
    ;

    loop:
    WHILE condition LOOP statements ENDLOOP
    {
        printf("While loop evaluated.\n");
    }
    | WHILE error LOOP statements ENDLOOP
    {
        yyerror("Invalid or missing condition in while loop.");
        yyerrok;
    }
    | WHILE condition error
    {
        yyerror("Missing 'LOOP' keyword in while loop.");
        yyerrok; 
    }
    | WHILE condition LOOP error ENDLOOP
    {
        yyerror("Error in loop body (statements).");
        yyerrok; 
    }
    | WHILE condition LOOP statements error
    {
        yyerror("Missing 'ENDLOOP' keyword in while loop.");
        yyerrok; 
    }
    | error
    {
        yyerror("Invalid while loop syntax.");
        yyerrok; 
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
    | IF error THEN statements ENDIF
    {
        yyerror("Invalid or missing condition in IF statement.");
        yyerrok;
    }
    | IF condition error
    {
        yyerror("Missing 'THEN' keyword in IF statement.");
        yyerrok; 
    }
    | IF condition THEN error ENDIF
    {
        yyerror("Error in statements within IF block.");
        yyerrok; 
    }
    | IF condition THEN statements ELSE error ENDIF
    {
        yyerror("Error in statements within ELSE block.");
        yyerrok;
    }
    | IF condition THEN statements error
    {
        yyerror("Missing 'ENDIF' keyword in IF statement.");
        yyerrok; 
    }
    | error
    {
        yyerror("Invalid IF statement syntax.");
        yyerrok; 
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
            default: 
                yyerror("Invalid relational operator.");
        }
        printf("Relational expression: %d %d %d = %d\n", $1, $2, $3, $$);
    }
    | TRUE {    $$ = 1; }
    | FALSE {    $$ = 0; }
    | condition OR error
    {
        yyerror("Invalid condition after 'OR'.");
        yyerrok; 
        $$ = 0; // Assign a default value
    }
    | condition AND error
    {
        yyerror("Invalid condition after 'AND'.");
        yyerrok;
        $$ = 0; // Assign a default value
    }
    | expression error expression
    {
        yyerror("Missing or invalid relational operator.");
        yyerrok;
        $$ = 0; // Assign a default value
    }
    | error
    {
        yyerror("Invalid condition syntax.");
        yyerrok;
        $$ = 0; // Assign a default value
    }
    ;


relational_operator:
    EQ  { $$ = EQ; }
    | NEQ { $$ = NEQ; }
    | LT  { $$ = LT; }
    | GT  { $$ = GT; }
    | LTE { $$ = LTE; }
    | GTE { $$ = GTE; }
    | error
    {
        yyerror("Invalid or missing relational operator.");
        yyerrok; 
        $$ = 0; // Assign a default operator to avoid uninitialized variables
    }
    ;

expression:
    expression ADD term { $$ = $1 + $3; }
    | expression SUB term { $$ = $1 - $3; }
    | term { $$ = $1; }
    | expression ADD error
    {
        yyerror("Invalid or missing operand after '+'.");
        yyerrok;
        $$ = $1; // Use the left-hand side value to continue
    }
    | expression SUB error
    {
        yyerror("Invalid or missing operand after '-'.");
        yyerrok; 
        $$ = $1; // Use the left-hand side value to continue
    }
    | error
    {
        yyerror("Invalid expression syntax.");
        yyerrok;
        $$ = 0; // Assign a default value to avoid uninitialized variables
    }
    ;

factor:
    NUMBER { $$ = $1; }
    | IDENT
    {
        if (!lookup_variable($1)) {
            yyerror("Undefined variable.");
            $$ = 0; // Assign a default value to recover
        } else {
            printf("Referenced variable: %s\n", $1);
            $$ = 0; // Replace with the variable's value once symbol table integration is complete
        }
    }
    | IDENT L_PAREN expression R_PAREN
    {
        if (!lookup_array($1)) {
            yyerror("Undefined array.");
            $$ = 0; // Assign a default value to recover
        } else {
            printf("Array access: %s[%d]\n", $1, $3);
            $$ = 0; // Replace with array value access logic
        }
    }
    | IDENT L_PAREN error R_PAREN
    {
        yyerror("Invalid array index.");
        yyerrok; 
        $$ = 0; // Assign a default value
    }
    | L_PAREN expression R_PAREN { $$ = $2; }
    | L_PAREN error
    {
        yyerror("Unmatched opening parenthesis.");
        yyerrok; 
        $$ = 0; // Assign a default value
    }
    | error
    {
        yyerror("Invalid factor syntax.");
        yyerrok; 
        $$ = 0; // Assign a default value
    }
    ;


term:
    term MULT factor
    {
        $$ = $1 * $3;
        printf("Multiplication: %d * %d = %d\n", $1, $3, $$);
    }
    | term DIV factor
    {
        if ($3 == 0) {
            yyerror("Division by zero.");
            $$ = 0; // Assign a default value to recover
        } else {
            $$ = $1 / $3;
            printf("Division: %d / %d = %d\n", $1, $3, $$);
        }
    }
    | factor
    {
        $$ = $1;
    }
    | error
    {
        yyerror("Invalid term syntax.");
        yyerrok; 
        $$ = 0; // Assign a default value
    }
    ;

%%

int yywrap() {
    return 1;  // Continue until EOF
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
