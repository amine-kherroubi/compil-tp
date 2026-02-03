/*
 * PROBLÈME 12 : ÉVALUATION VIA AST
 * TYPE D'ANALYSE : SÉMANTIQUE
 * NOTION : Évaluation d'expressions via traversée d'AST
 */
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(const char *s);

typedef struct Node {
    char op;
    int val;
    struct Node *l, *r;
} Node;

Node* make_num(int v) {
    Node* n = malloc(sizeof(Node));
    n->op = 'N'; n->val = v; n->l = n->r = NULL;
    return n;
}

Node* make_op(char o, Node* l, Node* r) {
    Node* n = malloc(sizeof(Node));
    n->op = o; n->val = 0; n->l = l; n->r = r;
    return n;
}

int eval(Node* n) {
    if (!n) return 0;
    if (n->op == 'N') return n->val;
    int lval = eval(n->l);
    int rval = eval(n->r);
    switch (n->op) {
        case '+': return lval + rval;
        case '-': return lval - rval;
        case '*': return lval * rval;
        case '/': return lval / rval;
    }
    return 0;
}
%}

%union { int num; struct Node* node; }
%token <num> NUM
%token PLUS MINUS MULT DIV LPAREN RPAREN
%type <node> expr term factor

%%
program: expr { 
    printf("Résultat = %d\n", eval($1));
}
;

expr: expr PLUS term   { $$ = make_op('+', $1, $3); }
    | expr MINUS term  { $$ = make_op('-', $1, $3); }
    | term             { $$ = $1; }
    ;

term: term MULT factor { $$ = make_op('*', $1, $3); }
    | term DIV factor  { $$ = make_op('/', $1, $3); }
    | factor           { $$ = $1; }
    ;

factor: NUM                 { $$ = make_num($1); }
      | LPAREN expr RPAREN  { $$ = $2; }
      ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== ÉVALUATION VIA AST ===\n");
    printf("Entrez une expression: ");
    return yyparse();
}
