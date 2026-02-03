# Problème 10 : Gestion d'Erreurs Lexicales

## Notion Théorique
**Erreurs lexicales** : Caractères invalides, récupération et continuation.

## Type d'Analyse
- **Lexicale**

## Compilation
```bash
flex lexer.l && gcc lex.yy.c -o lexer -lfl
```
