%{
#include "y.tab.h"
%}
%%
"int"       { return INT; }
"float"     { return FLOAT; }
[a-z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"="         { return ASSIGN; }
";"         { return SEMI; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
