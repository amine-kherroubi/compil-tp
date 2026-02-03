/*
 * PROBLÈME 10 : GESTION D'ERREURS LEXICALES
 * TYPE D'ANALYSE : LEXICALE
 * NOTION : Caractères illégaux et récupération
 */
%{
int line_num = 1;
int error_count = 0;
%}
%%
[0-9]+      { printf("NUM: %s\n", yytext); }
[a-zA-Z]+   { printf("ID: %s\n", yytext); }
"+"         { printf("PLUS\n"); }
[ \t]+      { }
"\n"        { line_num++; }
[@#$%]      { 
    printf("ERREUR LEXICALE ligne %d: caractère illégal '%s'\n", line_num, yytext);
    error_count++;
}
.           { 
    printf("ERREUR: caractère inconnu '%s' ligne %d\n", yytext, line_num);
    error_count++;
}
%%
int yywrap() { return 1; }
int main() {
    printf("=== GESTION D'ERREURS LEXICALES ===\n\n");
    yylex();
    printf("\nTotal erreurs: %d\n", error_count);
    return error_count > 0 ? 1 : 0;
}
