# Problème 11 : Construction d'AST

## Notion Théorique
**AST (Abstract Syntax Tree)** : Représentation en arbre de la structure syntaxique abstraite du code.

## Type d'Analyse
- **Syntaxique + Sémantique**

## Description
Construction d'un arbre de syntaxe abstraite pour expressions arithmétiques.

## Compilation
```bash
bison -d parser.y
flex lexer.l
gcc y.tab.c lex.yy.c -o parser -lfl
./parser
```

## Test
```
Input: 2 + 3 * 4
AST:
  +
    NUM(2)
    *
      NUM(3)
      NUM(4)
```

## Points Clés
1. **Structure récursive** : nœuds internes = opérateurs
2. **Feuilles** : valeurs numériques
3. **Actions sémantiques** : construction pendant parsing
4. **Union type** : transmission de pointeurs
