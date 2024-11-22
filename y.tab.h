/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     SUB = 258,
     ADD = 259,
     DIV = 260,
     MULT = 261,
     ASSIGN = 262,
     PROGRAM = 263,
     BEGIN_PROGRAM = 264,
     END_PROGRAM = 265,
     INTEGER = 266,
     ARRAY = 267,
     OF = 268,
     IF = 269,
     THEN = 270,
     ENDIF = 271,
     ELSE = 272,
     WHILE = 273,
     LOOP = 274,
     ENDLOOP = 275,
     READ = 276,
     WRITE = 277,
     VAR = 278,
     AND = 279,
     OR = 280,
     NOT = 281,
     TRUE = 282,
     FALSE = 283,
     IDENT = 284,
     NUMBER = 285,
     EQ = 286,
     NEQ = 287,
     LT = 288,
     GT = 289,
     LTE = 290,
     GTE = 291,
     SEMICOLON = 292,
     COLON = 293,
     COMMA = 294,
     L_PAREN = 295,
     R_PAREN = 296
   };
#endif
/* Tokens.  */
#define SUB 258
#define ADD 259
#define DIV 260
#define MULT 261
#define ASSIGN 262
#define PROGRAM 263
#define BEGIN_PROGRAM 264
#define END_PROGRAM 265
#define INTEGER 266
#define ARRAY 267
#define OF 268
#define IF 269
#define THEN 270
#define ENDIF 271
#define ELSE 272
#define WHILE 273
#define LOOP 274
#define ENDLOOP 275
#define READ 276
#define WRITE 277
#define VAR 278
#define AND 279
#define OR 280
#define NOT 281
#define TRUE 282
#define FALSE 283
#define IDENT 284
#define NUMBER 285
#define EQ 286
#define NEQ 287
#define LT 288
#define GT 289
#define LTE 290
#define GTE 291
#define SEMICOLON 292
#define COLON 293
#define COMMA 294
#define L_PAREN 295
#define R_PAREN 296




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

