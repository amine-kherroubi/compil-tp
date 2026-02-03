%{
#include "y.tab.h"
int line_num = 1;
%}
%%
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"+"         { return PLUS; }
"*"         { return MULT; }
";"         { return SEMI; }
[ \t]+      { }
"\n"        { line_num++; }
.           { return yytext[0]; }
%%
int yywrap() { return 1; }
