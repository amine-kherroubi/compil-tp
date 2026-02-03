/* PROBLÈME 07 : ASSOCIATIVITÉ - Lexer */
%{
#include "y.tab.h"
%}
%%
[0-9]+      { return NUM; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"^"         { return POWER; }
"="         { return ASSIGN; }
[a-z]       { return VAR; }
[ \t]+      { }
"\n"        { return NEWLINE; }
%%
int yywrap() { return 1; }
