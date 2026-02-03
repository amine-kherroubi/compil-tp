# Problème 09 : Gestion d'Erreurs Syntaxiques

## Notion Théorique
**Gestion d'erreurs syntaxiques** : Détection, rapport et récupération après erreurs.

## Type d'Analyse
- **Syntaxique**

## Mécanisme
Token spécial `error` dans Bison permet récupération.

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```
