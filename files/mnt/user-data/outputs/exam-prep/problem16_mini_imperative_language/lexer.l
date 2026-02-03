%{
#include "y.tab.h"
%}
%%
"int"       { return INT; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"return"    { return RETURN; }
[a-z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"=="        { return EQ; }
"<"         { return LT; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
";"         { return SEMI; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t\n]+    { }
%%
int yywrap() { return 1; }
