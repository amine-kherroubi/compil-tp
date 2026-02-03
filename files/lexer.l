%{
#include "y.tab.h"
int line_num = 1;
%}
%%
"int"       { return INT; }
[a-z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"+"         { return PLUS; }
"="         { return ASSIGN; }
";"         { return SEMI; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
[ \t]+      { }
"\n"        { line_num++; }
%%
int yywrap() { return 1; }
