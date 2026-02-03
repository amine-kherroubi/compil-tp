# Problème 12 : Évaluation via AST

## Notion Théorique
**Évaluation d'AST** : Parcours post-ordre de l'arbre pour calculer le résultat.

## Type d'Analyse
- **Sémantique**

## Algorithme
```c
eval(node):
  if node is NUM: return node.value
  left = eval(node.left)
  right = eval(node.right)
  return apply_op(node.op, left, right)
```

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Test
```
Input: 2 + 3 * 4
Résultat = 14
```

## Points Clés
1. **Parcours post-ordre** : évaluer enfants avant parent
2. **Récursivité** : fonction eval récursive
3. **Priorité automatique** : structure AST encode priorité
