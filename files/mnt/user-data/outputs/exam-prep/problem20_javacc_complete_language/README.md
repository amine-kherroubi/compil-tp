# Problème 20 : JavaCC - Langage Complet

## Notion Théorique
**Comparaison Bison/JavaCC** : Langage impératif complet en parser LL.

## Type d'Analyse
- **Syntaxique** (LL avec JavaCC)

## Fonctionnalités
- Déclarations, affectations
- Conditions (if/else)
- Boucles (while)
- Return
- Blocs

## Différences Bison
- **JavaCC** : LL (top-down), pas de récursivité gauche
- **Bison** : LR (bottom-up), récursivité gauche OK

## Compilation
```bash
javacc grammar.jj
javac *.java
java CompleteParser
```

## Points Clés
1. Parser LL complet
2. Sans récursivité gauche
3. Comparaison avec problem16 (Bison)
