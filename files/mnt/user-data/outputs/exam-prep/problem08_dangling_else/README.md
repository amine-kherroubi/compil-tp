# Problème 08 : Dangling Else

## Notion Théorique
**Dangling else** : Ambiguïté grammaticale sur l'appariement du else dans les if imbriqués.

## Type d'Analyse
- **Syntaxique**

## Le Problème Classique
```
if cond1 then
  if cond2 then
    stmt1
else        ← À quel if ?
  stmt2
```

## Deux Interprétations
1. `else` avec if **intérieur** (plus proche) ✓
2. `else` avec if **extérieur** ✗

## Solution Standard
**Règle** : Le `else` se lie au `if` le plus proche.

Bison génère un conflit shift/reduce :
- **SHIFT** `else` → lie au if proche (correct)
- **REDUCE** stmt → lie au if extérieur

Bison choisit SHIFT par défaut → Solution correcte !

## Compilation
```bash
bison -d parser.y
flex lexer.l
gcc y.tab.c lex.yy.c -o parser -lfl
./parser
```

**Note** : Vous verrez l'avertissement "shift/reduce conflict" - c'est normal et attendu pour ce problème.

## Points Clés
1. **Ambiguïté classique** : if-then-else imbriqués
2. **Règle** : else → if le plus proche
3. **Conflit** : shift/reduce automatiquement résolu
4. **Alternative** : utiliser begin/end explicites
