/*
 * PROBLÈME 01 : ANALYSE LEXICALE PURE - RECONNAISSANCE DE TOKENS
 * 
 * TYPE D'ANALYSE : LEXICALE (scanner uniquement, pas de parser)
 * 
 * NOTION THÉORIQUE : Reconnaissance et classification des tokens
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Fondamental : comprendre la première phase de compilation
 * - Teste la capacité à définir des patterns regex corrects
 * - Vérifie la compréhension de la priorité des règles lexicales
 * 
 * ERREURS CLASSIQUES DES ÉTUDIANTS :
 * 1. Confondre l'ordre des règles (les plus spécifiques doivent être en premier)
 * 2. Oublier de gérer les espaces et commentaires
 * 3. Ne pas distinguer mots-clés et identifiants
 * 4. Mal gérer les nombres (entiers vs flottants)
 * 
 * SOLUTION RETENUE :
 * - Mots-clés déclarés AVANT les identifiants génériques
 * - Gestion explicite des espaces/tabulations/retours ligne
 * - Classification claire : keywords, identifiers, numbers, operators, delimiters
 */

%{
#include <stdio.h>
#include <string.h>

int line_num = 1;
int token_count = 0;
%}

/* Définitions de patterns réutilisables */
DIGIT       [0-9]
LETTER      [a-zA-Z]
ALPHANUM    [a-zA-Z0-9]
IDENTIFIER  {LETTER}{ALPHANUM}*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
WHITESPACE  [ \t]+

%%

    /* MOTS-CLÉS - DOIVENT ÊTRE AVANT LES IDENTIFIANTS */
    /* Erreur fréquente : placer ces règles après {IDENTIFIER} */
"if"        { printf("Token %d: KEYWORD_IF\n", ++token_count); }
"else"      { printf("Token %d: KEYWORD_ELSE\n", ++token_count); }
"while"     { printf("Token %d: KEYWORD_WHILE\n", ++token_count); }
"for"       { printf("Token %d: KEYWORD_FOR\n", ++token_count); }
"int"       { printf("Token %d: KEYWORD_INT\n", ++token_count); }
"float"     { printf("Token %d: KEYWORD_FLOAT\n", ++token_count); }
"return"    { printf("Token %d: KEYWORD_RETURN\n", ++token_count); }

    /* OPÉRATEURS - Attention à l'ordre : "==" avant "=" */
"=="        { printf("Token %d: OP_EQ [%s]\n", ++token_count, yytext); }
"!="        { printf("Token %d: OP_NEQ [%s]\n", ++token_count, yytext); }
"<="        { printf("Token %d: OP_LEQ [%s]\n", ++token_count, yytext); }
">="        { printf("Token %d: OP_GEQ [%s]\n", ++token_count, yytext); }
"<"         { printf("Token %d: OP_LT [%s]\n", ++token_count, yytext); }
">"         { printf("Token %d: OP_GT [%s]\n", ++token_count, yytext); }
"="         { printf("Token %d: OP_ASSIGN [%s]\n", ++token_count, yytext); }
"+"         { printf("Token %d: OP_PLUS [%s]\n", ++token_count, yytext); }
"-"         { printf("Token %d: OP_MINUS [%s]\n", ++token_count, yytext); }
"*"         { printf("Token %d: OP_MULT [%s]\n", ++token_count, yytext); }
"/"         { printf("Token %d: OP_DIV [%s]\n", ++token_count, yytext); }

    /* DÉLIMITEURS */
"("         { printf("Token %d: LPAREN\n", ++token_count); }
")"         { printf("Token %d: RPAREN\n", ++token_count); }
"{"         { printf("Token %d: LBRACE\n", ++token_count); }
"}"         { printf("Token %d: RBRACE\n", ++token_count); }
";"         { printf("Token %d: SEMICOLON\n", ++token_count); }
","         { printf("Token %d: COMMA\n", ++token_count); }

    /* NOMBRES - Float AVANT Integer pour éviter reconnaissance partielle */
{FLOAT}     { printf("Token %d: FLOAT_LITERAL [%s]\n", ++token_count, yytext); }
{INTEGER}   { printf("Token %d: INTEGER_LITERAL [%s]\n", ++token_count, yytext); }

    /* IDENTIFIANTS - APRÈS les mots-clés */
{IDENTIFIER} { printf("Token %d: IDENTIFIER [%s]\n", ++token_count, yytext); }

    /* GESTION DES ESPACES */
{WHITESPACE} { /* Ignorer silencieusement */ }
"\n"        { line_num++; }

    /* CARACTÈRES NON RECONNUS - Erreur lexicale */
.           { printf("ERREUR LEXICALE ligne %d: caractère illégal '%s'\n", line_num, yytext); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    printf("=== ANALYSEUR LEXICAL - RECONNAISSANCE DE TOKENS ===\n");
    printf("Entrez du code (Ctrl+D pour terminer):\n\n");
    
    yylex();
    
    printf("\n=== FIN DE L'ANALYSE ===\n");
    printf("Total de tokens reconnus: %d\n", token_count);
    printf("Nombre de lignes analysées: %d\n", line_num);
    
    return 0;
}
