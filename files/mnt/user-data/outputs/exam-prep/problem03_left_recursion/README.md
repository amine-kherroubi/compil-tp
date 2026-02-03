# Problème 03 : Récursivité Gauche

## Notion Théorique Ciblée
**Récursivité gauche** : Une production de la forme A → A α où le non-terminal A apparaît en première position à droite.

## Type d'Analyse
- **Syntaxique**

## Description du Problème
Démonstration d'une grammaire avec récursivité gauche directe :
```
expr -> expr + term
expr -> expr - term
expr -> term
term -> NUM
```

## Pourquoi ce Piège Classique d'Examen ?

### Questions Typiques :
1. "Cette grammaire contient-elle de la récursivité gauche ?"
2. "Pourquoi la récursivité gauche est-elle problématique pour les parsers LL ?"
3. "Quelle est la différence entre récursivité gauche et droite ?"
4. "Comment cette récursivité affecte-t-elle l'associativité ?"

### Concepts Importants :

#### Récursivité Gauche DIRECTE
```
A -> A α | β
```
Le non-terminal A apparaît immédiatement à gauche.

#### Récursivité Gauche INDIRECTE
```
A -> B α
B -> A β
```
A dépend de B qui dépend de A.

### Pourquoi Problématique pour LL ?

Un parser LL (récursif descendant) tente de dériver de gauche à droite :
```
Pour reconnaître : expr
  1. Essayer : expr -> expr + term
  2. Pour reconnaître expr, retour à 1
  3. BOUCLE INFINIE
```

### Pourquoi Acceptable pour LR (Bison) ?

Les parsers LR (comme Bison) utilisent une pile et des réductions :
- Ils lisent les tokens de gauche à droite
- Ils construisent l'arbre de bas en haut
- Pas de problème de boucle infinie

## Associativité et Récursivité

### Récursivité GAUCHE → Associativité GAUCHE
```
expr -> expr + term

Pour "1 + 2 + 3" :
    expr
   / | \
expr + term(3)
 / | \
expr + term(2)
  |
term(1)

Résultat : ((1 + 2) + 3) = 6
```

### Récursivité DROITE → Associativité DROITE
```
expr -> term + expr

Pour "1 + 2 + 3" :
       expr
      / | \
  term(1) + expr
           / | \
       term(2) + expr
                  |
               term(3)

Résultat : (1 + (2 + 3)) = 6
```

## Compilation et Exécution

### Génération
```bash
bison -d parser.y
flex lexer.l
```

### Compilation
```bash
gcc y.tab.c lex.yy.c -o parser -lfl
```

### Exécution
```bash
./parser
```

## Tests

### Test 1 : Expression simple
```
Entrée : 5 + 3
Trace : term(5) -> expr -> expr + term(3)
```

### Test 2 : Multiple opérations
```
Entrée : 1 + 2 + 3 + 4
Résultat : (((1 + 2) + 3) + 4) = 10
Associativité gauche vérifiée
```

### Test 3 : Soustraction
```
Entrée : 10 - 3 - 2
Résultat : ((10 - 3) - 2) = 5 (PAS 10 - (3 - 2) = 9)
L'associativité gauche est importante pour la soustraction !
```

## Points Clés pour l'Examen

1. **Définition** : A → A α (A en première position à droite)
2. **Types** : Directe vs Indirecte
3. **Impact** :
   - LL : Boucle infinie → INTERDIT
   - LR : Fonctionne parfaitement → AUTORISÉ
4. **Associativité** :
   - Gauche → récursivité gauche
   - Droite → récursivité droite
5. **Élimination** : Nécessaire pour LL (voir problem04)

## Différences Clés

| Aspect | Récursivité Gauche | Récursivité Droite |
|--------|-------------------|-------------------|
| Forme | A → A α | A → α A |
| Parser LL | ❌ Interdit | ✅ Autorisé |
| Parser LR | ✅ Autorisé | ✅ Autorisé |
| Associativité | Gauche | Droite |
| Exemple | expr → expr + term | expr → term + expr |

## Référence Croisée
- **Élimination** : Voir problem04_left_recursion_elimination
- **JavaCC** : Voir problem05_javacc_left_recursion (parsers LL)
