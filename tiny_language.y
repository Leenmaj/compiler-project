//main program structure
program:
    PROGRAM IDENT SEMICOLON declarations statements ENDPROGRAM
    ;

//declarations (variables and arrays)
declarations:
    VAR declaration SEMICOLON declarations //VAR avoids ambiguity between declarations and assignments starting with IDENT
    | /* empty */
    ;

declaration:
    IDENT COLON type
    ;

type:
    INTEGER
    | ARRAY L_PAREN NUMBER R_PAREN OF INTEGER
    ;

//control structures (if, while)
conditional:
    IF condition THEN statements ENDIF
    | IF condition THEN statements ELSE statements ENDIF
    ;

loop:
    WHILE condition LOOP statements ENDLOOP
    ;


//what is left is statements statements, expressions, and conditions 