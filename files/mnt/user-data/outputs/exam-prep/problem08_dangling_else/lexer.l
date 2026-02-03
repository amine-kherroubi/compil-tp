/* PROBLÈME 08 : DANGLING ELSE - Lexer */
%{
#include "y.tab.h"
%}
%%
"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"true"      { return TRUE; }
"false"     { return FALSE; }
[a-z]+      { return ID; }
";"         { return SEMI; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
