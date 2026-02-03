%{
#include "y.tab.h"
%}
%%
"for"       { return FOR; }
"while"     { return WHILE; }
"do"        { return DO; }
"break"     { return BREAK; }
"continue"  { return CONTINUE; }
[a-z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"<"         { return LT; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"++"        { return INCR; }
";"         { return SEMI; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
