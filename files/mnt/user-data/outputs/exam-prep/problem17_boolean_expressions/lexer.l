%{
#include "y.tab.h"
%}
%%
"true"      { return TRUE; }
"false"     { return FALSE; }
"and"       { return AND; }
"or"        { return OR; }
"not"       { return NOT; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
