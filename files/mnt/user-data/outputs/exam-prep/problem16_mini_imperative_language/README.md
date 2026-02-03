# Problème 16 : Mini-Langage Impératif

## Notion Théorique
**Langage impératif complet** : Variables, conditions, boucles, affectations.

## Type d'Analyse
- **Syntaxique + Sémantique**

## Fonctionnalités
- Déclarations: `int x;`
- Affectations: `x = 5;`
- Conditions: `if (x < 10) { }`
- Boucles: `while (x < 10) { }`
- Return: `return x;`

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Test
```
int x;
x = 5;
while (x < 10) {
    x = x + 1;
}
return x;
```
