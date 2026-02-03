# BASE DE CODE COMPLÈTE - PRÉPARATION D'EXAMEN DE COMPILATION

## Vue d'Ensemble
Cette base contient **20 problèmes distincts et totalement indépendants** couvrant l'ensemble des notions fondamentales et avancées pour les examens de compilation.

**Caractéristiques** :
- ✅ 20 problèmes autonomes
- ✅ Aucun code partagé entre problèmes
- ✅ Commentaires pédagogiques exhaustifs
- ✅ README détaillé par problème
- ✅ Flex/Bison + JavaCC
- ✅ Exemples de commandes complètes

## Structure du Répertoire
```
exam-prep/
├── problem01_token_recognition/          # Analyse lexicale pure
├── problem02_grammar_ambiguity/          # Ambiguïté grammaticale
├── problem03_left_recursion/             # Récursivité gauche
├── problem04_eliminate_left_recursion/   # Élimination récursivité gauche
├── problem05_javacc_left_recursion/      # JavaCC vs Bison (LL vs LR)
├── problem06_operator_precedence/        # Priorité des opérateurs
├── problem07_operator_associativity/     # Associativité
├── problem08_dangling_else/              # Problème du dangling else
├── problem09_syntax_error_handling/      # Gestion erreurs syntaxiques
├── problem10_lexical_error_handling/     # Gestion erreurs lexicales
├── problem11_ast_construction/           # Construction d'AST
├── problem12_ast_evaluation/             # Évaluation via AST
├── problem13_symbol_table/               # Table des symboles
├── problem14_type_checking/              # Vérification de types
├── problem15_semantic_analysis/          # Analyse sémantique complète
├── problem16_mini_imperative_language/   # Mini-langage impératif
├── problem17_boolean_expressions/        # Expressions booléennes
├── problem18_loop_structures/            # Structures de boucles
├── problem19_error_recovery/             # Récupération d'erreurs
└── problem20_javacc_complete_language/   # Langage complet en JavaCC
```

## Classification des Problèmes par Type d'Analyse

### ANALYSE LEXICALE (3 problèmes)
1. **Problem 01** : Reconnaissance de tokens
10. **Problem 10** : Gestion d'erreurs lexicales
   - Support lexical pour autres problèmes

### ANALYSE SYNTAXIQUE (11 problèmes)
2. **Problem 02** : Ambiguïté grammaticale
3. **Problem 03** : Récursivité gauche
4. **Problem 04** : Élimination récursivité gauche
5. **Problem 05** : JavaCC et récursivité gauche (LL vs LR)
6. **Problem 06** : Priorité des opérateurs
7. **Problem 07** : Associativité
8. **Problem 08** : Dangling else
9. **Problem 09** : Gestion erreurs syntaxiques
16. **Problem 16** : Mini-langage impératif
18. **Problem 18** : Structures de boucles
19. **Problem 19** : Récupération d'erreurs
20. **Problem 20** : JavaCC langage complet

### ANALYSE SÉMANTIQUE (6 problèmes)
11. **Problem 11** : Construction d'AST
12. **Problem 12** : Évaluation via AST
13. **Problem 13** : Table des symboles
14. **Problem 14** : Vérification de types
15. **Problem 15** : Analyse sémantique complète
17. **Problem 17** : Expressions booléennes

## Notions Théoriques Couvertes

### Concepts Fondamentaux
- ✅ Tokens et patterns lexicaux
- ✅ Grammaires formelles
- ✅ Arbres de dérivation
- ✅ Ambiguïté
- ✅ Récursivité gauche/droite

### Analyse Syntaxique
- ✅ Parsers LL (top-down, récursif descendant)
- ✅ Parsers LR (bottom-up, shift/reduce)
- ✅ Priorité des opérateurs
- ✅ Associativité
- ✅ Conflits shift/reduce et reduce/reduce

### Analyse Sémantique
- ✅ AST (Abstract Syntax Tree)
- ✅ Table des symboles
- ✅ Vérification de types
- ✅ Portée (scope)
- ✅ Analyse de flot

### Gestion d'Erreurs
- ✅ Détection d'erreurs lexicales
- ✅ Détection d'erreurs syntaxiques
- ✅ Récupération d'erreurs
- ✅ Messages d'erreur informatifs

## Utilisation Rapide

### Compiler un Problème Flex/Bison
```bash
cd problemXX_nom/
bison -d parser.y
flex lexer.l
gcc y.tab.c lex.yy.c -o parser -lfl
./parser
```

### Compiler un Problème JavaCC
```bash
cd problemXX_nom/
javacc grammar.jj
javac *.java
java NomDuParser
```

### Consulter la Documentation
```bash
cd problemXX_nom/
cat README.md
```

## Pièges Classiques d'Examen

### 1. Ordre des Règles Lexicales
❌ **ERREUR** : Identifiants avant mots-clés
```flex
{IDENTIFIER}  { return ID; }
"if"          { return IF; }  // Jamais atteint !
```

✅ **CORRECT** : Mots-clés avant identifiants
```flex
"if"          { return IF; }
{IDENTIFIER}  { return ID; }
```

### 2. Récursivité Gauche en JavaCC
❌ **ERREUR** : Récursivité gauche (boucle infinie en LL)
```java
void Expr() : {}
{ Expr() <PLUS> Term() }  // INTERDIT en JavaCC !
```

✅ **CORRECT** : Récursivité droite
```java
void Expr() : {}
{ Term() ExprPrime() }

void ExprPrime() : {}
{ [<PLUS> Term() ExprPrime()] }
```

### 3. Associativité et Soustraction
❌ **ERREUR** : Récursivité droite pour soustraction
```
5 - 2 - 1 = 5 - (2 - 1) = 4  // FAUX
```

✅ **CORRECT** : Récursivité gauche pour soustraction
```
5 - 2 - 1 = (5 - 2) - 1 = 2  // CORRECT
```

### 4. Priorité des Opérateurs
❌ **ERREUR** : Tous les opérateurs au même niveau
```yacc
expr: expr '+' expr
    | expr '*' expr
    | NUM
```

✅ **CORRECT** : Hiérarchie de non-terminaux
```yacc
expr: expr '+' term | term ;
term: term '*' factor | factor ;
factor: NUM ;
```

### 5. Dangling Else
**Question** : À quel `if` appartient le `else` ?
```
if C1 then if C2 then S1 else S2
```

**Réponse** : Au `if` le plus proche (C2)

### 6. Ambiguïté
Pour prouver l'ambiguïté : montrer **deux arbres de dérivation différents** pour la même chaîne.

## Questions Types d'Examen

### Théoriques
1. "Cette grammaire est-elle ambiguë ? Justifiez."
2. "Éliminez la récursivité gauche de cette grammaire."
3. "Quelle est la différence entre LL et LR ?"
4. "Pourquoi la récursivité gauche est-elle problématique pour LL ?"
5. "Qu'est-ce que le dangling else ? Comment le résoudre ?"

### Pratiques
1. "Écrivez un lexer pour reconnaître les tokens de ce langage."
2. "Ajoutez la priorité correcte des opérateurs."
3. "Implémentez une table des symboles."
4. "Construisez un AST pour cette expression."
5. "Ajoutez la gestion d'erreurs à ce parser."

## Conseils de Révision

### Avant l'Examen
1. **Lire tous les README** : concepts clés résumés
2. **Comprendre les commentaires** : explications détaillées dans le code
3. **Compiler et tester** : vérifier que tout fonctionne
4. **Identifier les patterns** : reconnaître les types de problèmes

### Pendant l'Examen
1. **Identifier le type d'analyse** : lexicale, syntaxique, sémantique
2. **Reconnaître la notion** : ambiguïté, récursivité, priorité, etc.
3. **Appliquer le pattern correspondant** : utiliser la solution du problème similaire
4. **Vérifier les pièges classiques** : ordre des règles, récursivité, etc.

## Correspondances Notion → Problème

| Notion | Problème(s) |
|--------|-------------|
| Analyse lexicale | 01, 10 |
| Ambiguïté | 02, 08 |
| Récursivité gauche | 03, 04, 05 |
| Priorité opérateurs | 06 |
| Associativité | 07 |
| Dangling else | 08 |
| Gestion erreurs | 09, 10, 19 |
| AST | 11, 12 |
| Table des symboles | 13 |
| Types | 14 |
| Sémantique | 15 |
| Langage complet | 16, 20 |
| Booléens | 17 |
| Boucles | 18 |
| LL vs LR | 05, 20 |

## Outils Nécessaires

### Pour Flex/Bison
```bash
sudo apt-get install flex bison gcc
```

### Pour JavaCC
```bash
# Télécharger JavaCC depuis https://javacc.github.io/javacc/
# Installer Java JDK
sudo apt-get install default-jdk
```

## Vérification Rapide

### Test de Tous les Problèmes Flex/Bison
```bash
for dir in problem{01..19}_*/; do
    echo "=== Testing $dir ==="
    cd "$dir"
    if [ -f parser.y ]; then
        bison -d parser.y 2>/dev/null && flex lexer.l 2>/dev/null && \
        gcc y.tab.c lex.yy.c -o parser -lfl 2>/dev/null && \
        echo "✓ Compilation OK" || echo "✗ Compilation FAILED"
        rm -f parser y.tab.* lex.yy.c
    elif [ -f lexer.l ]; then
        flex lexer.l 2>/dev/null && gcc lex.yy.c -o lexer -lfl 2>/dev/null && \
        echo "✓ Compilation OK" || echo "✗ Compilation FAILED"
        rm -f lexer lex.yy.c
    fi
    cd ..
done
```

### Test JavaCC
```bash
for dir in problem{05,20}_*/; do
    echo "=== Testing $dir ==="
    cd "$dir"
    if [ -f grammar.jj ]; then
        javacc grammar.jj 2>/dev/null && javac *.java 2>/dev/null && \
        echo "✓ Compilation OK" || echo "✗ Compilation FAILED"
        rm -f *.java *.class
    fi
    cd ..
done
```

## Notes Importantes

### Différences Bison vs JavaCC
- **Bison** : Parser LR (bottom-up), accepte récursivité gauche, plus puissant
- **JavaCC** : Parser LL (top-down), refuse récursivité gauche, plus simple

### Choisir le Bon Outil
- **Parser simple** : JavaCC (plus facile)
- **Grammaire complexe** : Bison (plus flexible)
- **Projet Java** : JavaCC (intégration native)
- **Projet C/C++** : Bison (intégration native)

## Auteur et Licence
Base de code créée pour la préparation d'examens de compilation.
Tous les problèmes sont indépendants et peuvent être utilisés séparément.

## Support
Chaque problème contient :
- Code source complet et commenté
- README détaillé avec explications
- Exemples de compilation et d'exécution
- Points clés pour l'examen

**Bonne préparation pour votre examen ! 🎓**
