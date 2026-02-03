%{
#include "y.tab.h"
%}
%%
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
