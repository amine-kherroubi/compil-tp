# Problème 02 : Ambiguïté Grammaticale

## Notion Théorique Ciblée
**Ambiguïté grammaticale** : Une grammaire est ambiguë si au moins une chaîne du langage possède deux arbres de dérivation distincts.

## Type d'Analyse
- **Syntaxique** (analyse de la structure grammaticale)

## Description du Problème
Ce problème démontre une grammaire volontairement ambiguë pour les expressions arithmétiques :
```
E -> E + E
E -> E * E
E -> (E)
E -> NUMBER
```

Cette grammaire ne spécifie ni priorité ni associativité, créant de l'ambiguïté.

## Pourquoi ce Piège Classique d'Examen ?

### Questions Typiques :
1. "Cette grammaire est-elle ambiguë ? Justifiez."
2. "Donnez deux arbres de dérivation pour la chaîne '2 + 3 * 4'"
3. "Quelle est la différence entre ambiguïté et non-déterminisme ?"
4. "Comment résoudre cette ambiguïté ?"

### Pièges Fréquents :
- **Piège 1** : Confondre "grammaire ambiguë" et "langage ambigu"
  - Une grammaire ambiguë peut générer un langage non-ambigu
  - On peut réécrire la grammaire pour éliminer l'ambiguïté
  
- **Piège 2** : Croire que les conflits shift/reduce prouvent toujours l'ambiguïté
  - Faux : certains conflits viennent de limitations de l'algorithme LR, pas de la grammaire
  
- **Piège 3** : Ne pas savoir construire les deux arbres
  - Il faut MONTRER explicitement les deux dérivations

## Démonstration de l'Ambiguïté

### Chaîne ambiguë : `2 + 3 * 4`

**Arbre 1 : Multiplication prioritaire**
```
        E
      / | \
     E  +  E
    /     / \
   2     E * E
        /     \
       3       4
```
Résultat : 2 + (3 × 4) = 2 + 12 = **14**

**Arbre 2 : Addition prioritaire**
```
        E
      / | \
     E  *  E
    / \     \
   E + E     4
  /     \
 2       3
```
Résultat : (2 + 3) × 4 = 5 × 4 = **20**

**Deux arbres différents → Grammaire ambiguë**

## Compilation et Exécution

### Génération avec Bison et Flex
```bash
bison -d parser.y
flex lexer.l
```

### Compilation
```bash
gcc y.tab.c lex.yy.c -o parser -lfl
```

**Note** : Bison affichera des avertissements de conflits shift/reduce. C'est NORMAL et c'est précisément ce qui prouve l'ambiguïté.

### Exécution
```bash
./parser
```

## Test et Observation

### Test 1 : Expression simple
```
Entrée : 2 + 3
```
Une seule dérivation possible.

### Test 2 : Expression ambiguë
```
Entrée : 2 + 3 * 4
```
Deux dérivations possibles ! Le parser choisira automatiquement (shift par défaut).

### Test 3 : Expression avec parenthèses
```
Entrée : (2 + 3) * 4
```
Les parenthèses forcent un seul arbre.

## Solution à l'Ambiguïté (pour référence)

Pour éliminer l'ambiguïté, il faut :
1. Créer des niveaux de priorité avec des non-terminaux différents
2. Spécifier l'associativité

Voir **problem03** pour la résolution de cette ambiguïté.

## Points Clés pour l'Examen

1. **Définition** : Ambiguïté = plusieurs arbres de dérivation pour une même chaîne
2. **Preuve** : Montrer explicitement deux arbres différents
3. **Conflits** : L'ambiguïté cause des conflits shift/reduce ou reduce/reduce
4. **Résolution** : Réécrire la grammaire avec priorités et associativité
5. **Propriété** : L'ambiguïté est une propriété de la GRAMMAIRE, pas du langage
