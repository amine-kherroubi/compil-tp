/*
 * PROBLÈME 11 : CONSTRUCTION D'AST
 * TYPE D'ANALYSE : SYNTAXIQUE + SÉMANTIQUE
 * NOTION : Abstract Syntax Tree (Arbre de Syntaxe Abstraite)
 */
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(const char *s);

typedef struct Node {
    char type;  // 'N' nombre, '+' addition, '*' multiplication
    int value;
    struct Node *left, *right;
} Node;

Node* make_num(int val) {
    Node* n = malloc(sizeof(Node));
    n->type = 'N'; n->value = val;
    n->left = n->right = NULL;
    return n;
}

Node* make_op(char op, Node* l, Node* r) {
    Node* n = malloc(sizeof(Node));
    n->type = op; n->value = 0;
    n->left = l; n->right = r;
    return n;
}

void print_ast(Node* n, int depth) {
    if (!n) return;
    for (int i = 0; i < depth; i++) printf("  ");
    if (n->type == 'N') printf("NUM(%d)\n", n->value);
    else printf("%c\n", n->type);
    print_ast(n->left, depth + 1);
    print_ast(n->right, depth + 1);
}
%}

%union {
    int num;
    struct Node* node;
}

%token <num> NUM
%token PLUS MULT LPAREN RPAREN
%type <node> expr term factor

%%
program: expr { 
    printf("\n=== AST CONSTRUIT ===\n");
    print_ast($1, 0);
}
;

expr: expr PLUS term   { $$ = make_op('+', $1, $3); }
    | term             { $$ = $1; }
    ;

term: term MULT factor { $$ = make_op('*', $1, $3); }
    | factor           { $$ = $1; }
    ;

factor: NUM              { $$ = make_num($1); }
      | LPAREN expr RPAREN { $$ = $2; }
      ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== CONSTRUCTION D'AST ===\n");
    printf("Entrez une expression: ");
    return yyparse();
}
