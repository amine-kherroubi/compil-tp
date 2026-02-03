# Problème 06 : Priorité des Opérateurs

## Notion Théorique Ciblée
**Priorité (précédence) des opérateurs** : Ordre d'évaluation des opérateurs dans une expression.

## Type d'Analyse
- **Syntaxique**

## Description
Implémentation correcte de la priorité mathématique standard : `* /` avant `+ -`.

## Pourquoi ce Piège d'Examen ?

### Questions Typiques :
1. "Pourquoi 2+3*4 donne 14 et non 20 ?"
2. "Modifiez la grammaire pour ajouter l'opérateur ^"
3. "Comment les parenthèses forcent-elles la priorité ?"

### Hiérarchie des Non-Terminaux
```
expr   → term + term        [Priorité BASSE]
  ↑
term   → factor * factor    [Priorité HAUTE]
  ↑
factor → NUMBER | (expr)    [Atomes]
```

**Règle mnémotechnique** : Plus "bas" dans la grammaire = plus haute priorité.

## Exemples

### Exemple 1
```
Input: 2 + 3 * 4
Parse: 
  factor(2) -> term -> expr
  +
  factor(3) -> term  }
  *              } term
  factor(4)      }
  
Résultat: 2 + (3 * 4) = 14 ✓
```

### Exemple 2
```
Input: (2 + 3) * 4
Parse:
  ( expr(2+3) ) -> factor }
  *                        } term
  factor(4)                }
  
Résultat: (5) * 4 = 20 ✓
```

## Compilation
```bash
bison -d parser.y
flex lexer.l
gcc y.tab.c lex.yy.c -o parser -lfl
./parser
```

## Points Clés
1. **Hiérarchie** : expr > term > factor
2. **Règle** : Plus bas = plus haute priorité
3. **Parenthèses** : Forcent l'évaluation (factor → (expr))
4. **Ne jamais** : Mettre tous les opérateurs au même niveau
