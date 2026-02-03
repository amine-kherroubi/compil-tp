# INDEX RAPIDE - 20 PROBLÈMES

## Accès Rapide par Numéro

| # | Nom | Notion | Type | Outils |
|---|-----|--------|------|--------|
| 01 | token_recognition | Analyse lexicale | LEX | Flex |
| 02 | grammar_ambiguity | Ambiguïté | SYN | Flex+Bison |
| 03 | left_recursion | Récursivité gauche | SYN | Flex+Bison |
| 04 | eliminate_left_recursion | Élimination récursivité | SYN | Flex+Bison |
| 05 | javacc_left_recursion | LL vs LR | SYN | JavaCC |
| 06 | operator_precedence | Priorité opérateurs | SYN | Flex+Bison |
| 07 | operator_associativity | Associativité | SYN | Flex+Bison |
| 08 | dangling_else | Dangling else | SYN | Flex+Bison |
| 09 | syntax_error_handling | Erreurs syntaxiques | SYN | Flex+Bison |
| 10 | lexical_error_handling | Erreurs lexicales | LEX | Flex |
| 11 | ast_construction | Construction AST | SEM | Flex+Bison |
| 12 | ast_evaluation | Évaluation AST | SEM | Flex+Bison |
| 13 | symbol_table | Table symboles | SEM | Flex+Bison |
| 14 | type_checking | Vérification types | SEM | Flex+Bison |
| 15 | semantic_analysis | Analyse sémantique | SEM | Flex+Bison |
| 16 | mini_imperative_language | Langage impératif | SYN+SEM | Flex+Bison |
| 17 | boolean_expressions | Expressions booléennes | SYN+SEM | Flex+Bison |
| 18 | loop_structures | Structures boucles | SYN | Flex+Bison |
| 19 | error_recovery | Récupération erreurs | SYN | Flex+Bison |
| 20 | javacc_complete_language | Langage complet LL | SYN | JavaCC |

**Légende** :
- LEX = Analyse Lexicale
- SYN = Analyse Syntaxique
- SEM = Analyse Sémantique

## Accès Rapide par Notion

### Analyse Lexicale
- Problem 01 : Reconnaissance tokens
- Problem 10 : Gestion erreurs lexicales

### Grammaires et Ambiguïté
- Problem 02 : Ambiguïté grammaticale (2 arbres)
- Problem 08 : Dangling else (ambiguïté spécifique)

### Récursivité
- Problem 03 : Récursivité gauche (démonstration)
- Problem 04 : Élimination récursivité gauche
- Problem 05 : JavaCC et récursivité (LL vs LR)

### Opérateurs
- Problem 06 : Priorité (*, / avant +, -)
- Problem 07 : Associativité (gauche vs droite)

### Gestion d'Erreurs
- Problem 09 : Erreurs syntaxiques (token error)
- Problem 10 : Erreurs lexicales (caractères illégaux)
- Problem 19 : Récupération d'erreurs (yyerrok)

### AST et Sémantique
- Problem 11 : Construction AST
- Problem 12 : Évaluation AST
- Problem 13 : Table des symboles
- Problem 14 : Vérification de types
- Problem 15 : Analyse sémantique complète

### Langages Complets
- Problem 16 : Mini-langage impératif (Bison)
- Problem 17 : Expressions booléennes
- Problem 18 : Structures de boucles
- Problem 20 : Langage complet (JavaCC)

## Accès Rapide par Outil

### Flex Seul (2)
- Problem 01 : token_recognition
- Problem 10 : lexical_error_handling

### Flex + Bison (17)
- Problems 02, 03, 04, 06, 07, 08, 09, 11, 12, 13, 14, 15, 16, 17, 18, 19

### JavaCC (2)
- Problem 05 : javacc_left_recursion
- Problem 20 : javacc_complete_language

## Commandes de Compilation Rapide

### Flex Seul
```bash
flex lexer.l && gcc lex.yy.c -o lexer -lfl && ./lexer
```

### Flex + Bison
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl && ./parser
```

### JavaCC
```bash
javacc grammar.jj && javac *.java && java ParserName
```

## Questions Types par Problème

### Problem 01 (Tokens)
Q: "Pourquoi les mots-clés doivent-ils être avant les identifiants ?"
A: Sinon "if" serait reconnu comme identifiant

### Problem 02 (Ambiguïté)
Q: "Montrez que cette grammaire est ambiguë"
A: Donner deux arbres de dérivation différents

### Problem 03 (Récursivité gauche)
Q: "Pourquoi la récursivité gauche pose-t-elle problème en LL ?"
A: Boucle infinie lors de la dérivation top-down

### Problem 04 (Élimination)
Q: "Éliminez la récursivité gauche"
A: A → Aα | β devient A → βA', A' → αA' | ε

### Problem 06 (Priorité)
Q: "Comment implémenter * avant + ?"
A: Hiérarchie : expr (+,-) > term (*,/) > factor (NUM)

### Problem 07 (Associativité)
Q: "Pourquoi 5-2-1 = 2 et non 4 ?"
A: Soustraction est associative à gauche

### Problem 08 (Dangling else)
Q: "À quel if appartient le else ?"
A: Au if le plus proche

### Problem 11-12 (AST)
Q: "Comment construire et évaluer un AST ?"
A: Actions sémantiques pendant parsing, puis parcours post-ordre

### Problem 13 (Symboles)
Q: "Comment gérer les variables ?"
A: Table de hachage : nom → type/adresse

### Problem 14 (Types)
Q: "Comment vérifier int x = 3.14 ?"
A: Erreur de type lors de l'affectation

## Temps de Révision Suggéré

### Révision Express (2h)
- Lire README principal (20 min)
- Lire README des 5 problèmes prioritaires (1h)
- Compiler et tester 3 problèmes (40 min)

**Problèmes prioritaires** : 02, 03, 06, 11, 13

### Révision Complète (8h)
- Jour 1 (4h) : Problèmes 01-10
- Jour 2 (4h) : Problèmes 11-20

### Révision Intensive (1 semaine)
- 2-3 problèmes par jour
- Compiler, modifier, tester chaque problème
- Créer ses propres variantes

## Checklist Avant Examen

- [ ] Compilé au moins 10 problèmes
- [ ] Compris différence LL vs LR
- [ ] Su éliminer récursivité gauche
- [ ] Compris priorité et associativité
- [ ] Su construire un AST
- [ ] Compris table des symboles
- [ ] Su gérer les erreurs
- [ ] Pratiqué avec JavaCC
- [ ] Révisé tous les README
- [ ] Identifié pièges classiques

## Ressources Complémentaires

### Livres Recommandés
- "Compilers: Principles, Techniques, and Tools" (Dragon Book)
- "Modern Compiler Implementation" (Tiger Book)
- "Engineering a Compiler"

### Documentation Officielle
- Flex: https://github.com/westes/flex
- Bison: https://www.gnu.org/software/bison/
- JavaCC: https://javacc.github.io/javacc/

### Tutoriels En Ligne
- Tutoriel Flex/Bison : https://aquamentus.com/flex_bison.html
- JavaCC Tutorial : https://javacc.github.io/javacc/tutorials/

## Contact et Contribution

Cette base est conçue pour être autonome et complète.
Chaque problème peut être étudié indépendamment.

**Structure garantie** :
✅ Aucune dépendance entre problèmes
✅ Chaque problème compile et s'exécute seul
✅ Commentaires exhaustifs dans le code
✅ README détaillé par problème

**Bonne révision ! 📚**
