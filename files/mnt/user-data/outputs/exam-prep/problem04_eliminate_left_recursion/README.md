# Problème 04 : Élimination de la Récursivité Gauche

## Notion Théorique Ciblée
**Élimination de la récursivité gauche** : Transformation systématique d'une grammaire pour la rendre compatible avec les parsers LL.

## Type d'Analyse
- **Syntaxique** (transformation de grammaire)

## Description du Problème
Transformation de la grammaire récursive à gauche (problem03) en grammaire équivalente sans récursivité gauche.

## Algorithme d'Élimination

### Forme Générale
**Avant** :
```
A -> A α₁ | A α₂ | ... | A αₘ | β₁ | β₂ | ... | βₙ
```

**Après** :
```
A  -> β₁ A' | β₂ A' | ... | βₙ A'
A' -> α₁ A' | α₂ A' | ... | αₘ A' | ε
```

### Application Concrète
**Avant** :
```
expr -> expr + term
expr -> expr - term
expr -> term
```

**Après** :
```
expr  -> term expr'
expr' -> + term expr'
expr' -> - term expr'
expr' -> ε
```

## Pourquoi ce Piège Classique d'Examen ?

### Questions Typiques :
1. "Éliminez la récursivité gauche de cette grammaire"
2. "Montrez que les deux grammaires génèrent le même langage"
3. "Quelle est l'associativité après transformation ?"
4. "Écrivez un parser récursif descendant pour cette grammaire"

### Pièges Fréquents :

**Piège 1** : Oublier ε
```
❌ FAUX :
expr' -> + term expr'
expr' -> - term expr'

✓ CORRECT :
expr' -> + term expr'
expr' -> - term expr'
expr' -> ε           ← OBLIGATOIRE !
```

**Piège 2** : Oublier A' après β
```
❌ FAUX :
expr -> term

✓ CORRECT :
expr -> term expr'   ← expr' obligatoire !
```

**Piège 3** : Mauvais ordre dans A'
```
❌ FAUX :
expr' -> expr' + term

✓ CORRECT :
expr' -> + term expr'
```

## Changement d'Associativité

### Problème Important
La transformation change l'associativité de GAUCHE à DROITE !

**Original (gauche)** :
```
5 - 2 - 1 = (5 - 2) - 1 = 2 ✓
```

**Transformé (droite)** :
```
5 - 2 - 1 = 5 - (2 - 1) = 4 ✗
```

### Solutions :
1. Traitement sémantique lors de l'évaluation
2. Utiliser des attributs synthétisés
3. Post-traitement de l'AST

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

## Étapes de Transformation

### Étape 1 : Identification
```
A = expr
α₁ = + term
α₂ = - term
β₁ = term
```

### Étape 2 : Créer A'
```
expr' = nouveau non-terminal
```

### Étape 3 : Réécrire A
```
expr -> term expr'
```

### Étape 4 : Définir A'
```
expr' -> + term expr'
expr' -> - term expr'
expr' -> ε
```

## Points Clés pour l'Examen

1. **Algorithme mécanique** : Peut être appliqué systématiquement
2. **ε obligatoire** : Ne jamais oublier la production vide
3. **A' partout** : Ajouter A' après chaque β
4. **Récursivité droite** : Le résultat utilise la récursivité droite
5. **Associativité** : Attention au changement d'associativité
6. **Langage équivalent** : Les deux grammaires génèrent le même langage

## Récursivité Gauche Indirecte

Pour la récursivité indirecte :
```
A -> B α
B -> A β
```

Solution : Substitution puis élimination :
```
A -> A β α | γ
```
Puis appliquer l'algorithme standard.

## Référence Croisée
- **Récursivité gauche** : Voir problem03
- **JavaCC (LL)** : Voir problem05
- **Associativité** : Voir problem06
