# Problème 07 : Associativité des Opérateurs

## Notion Théorique
**Associativité** : Ordre d'évaluation pour opérateurs de même priorité.

## Type d'Analyse
- **Syntaxique**

## Description
Démonstration de l'associativité gauche (+ -) vs droite (^).

## Exemples Critiques

### Soustraction (gauche)
```
5 - 2 - 1 = (5 - 2) - 1 = 2 ✓
5 - 2 - 1 ≠ 5 - (2 - 1) = 4 ✗
```

### Puissance (droite)
```
2 ^ 3 ^ 2 = 2 ^ (3 ^ 2) = 512 ✓
2 ^ 3 ^ 2 ≠ (2 ^ 3) ^ 2 = 64 ✗
```

## Implémentation

**Gauche** : `expr -> expr OP term` (récursivité gauche)
**Droite** : `power -> factor OP power` (récursivité droite)

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl && ./parser
```

## Points Clés
1. **Priorité ≠ Associativité**
2. **Gauche** : opérations arithmétiques
3. **Droite** : puissance, affectation
4. Impact crucial sur résultats
