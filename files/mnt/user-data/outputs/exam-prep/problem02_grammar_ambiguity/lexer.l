/*
 * PROBLÈME 02 : AMBIGUÏTÉ GRAMMATICALE
 * 
 * TYPE D'ANALYSE : LEXICALE (support pour l'analyse syntaxique)
 * 
 * Ce fichier fournit uniquement les tokens pour le parser.
 * La notion d'ambiguïté est traitée dans parser.y
 */

%{
#include "y.tab.h"
#include <stdio.h>
int line_num = 1;
%}

%%

"+"         { return PLUS; }
"*"         { return MULT; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[0-9]+      { return NUMBER; }
[ \t]+      { /* ignore whitespace */ }
"\n"        { line_num++; return NEWLINE; }
.           { printf("Caractère illégal: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
