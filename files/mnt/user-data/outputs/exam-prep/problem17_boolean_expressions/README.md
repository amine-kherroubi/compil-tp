# Problème 17 : Expressions Booléennes

## Notion Théorique
**Logique booléenne** : Opérateurs logiques et priorité.

## Type d'Analyse
- **Syntaxique + Sémantique**

## Priorité
1. NOT (plus haute)
2. AND
3. OR (plus basse)

## Exemples
```
not true and false = (not true) and false = false
true or false and true = true or (false and true) = true
```

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```
