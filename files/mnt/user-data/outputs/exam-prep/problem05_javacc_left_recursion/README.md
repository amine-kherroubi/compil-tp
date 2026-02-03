# Problème 05 : JavaCC et Récursivité Gauche

## Notion Théorique Ciblée
**Comparaison parsers LL (JavaCC) vs LR (Bison)** : Impact de la récursivité gauche selon le type de parser.

## Type d'Analyse
- **Syntaxique** (parser LL)

## Description du Problème
Implémentation en JavaCC d'un parser pour expressions arithmétiques, démontrant pourquoi la récursivité gauche est interdite.

## Pourquoi ce Piège Classique d'Examen ?

### Questions Typiques :
1. "Pourquoi cette grammaire ne fonctionne-t-elle pas en JavaCC ?"
2. "Quelle est la différence entre parser LL et LR ?"
3. "Comment adapter une grammaire Bison pour JavaCC ?"
4. "Expliquez pourquoi JavaCC refuse la récursivité gauche"

### Différences Fondamentales

| Aspect | Bison (LR) | JavaCC (LL) |
|--------|-----------|-------------|
| Direction | Bottom-up | Top-down |
| Construction | Shift/reduce | Récursif descendant |
| Récursivité gauche | ✅ Autorisée | ❌ Interdite |
| Puissance | Plus puissant | Moins puissant |
| Lookahead | LR(1) | LL(k) |

## Pourquoi LL Refuse la Récursivité Gauche ?

### Parser LL (Top-Down)
```
Pour reconnaître : expr -> expr + term

1. Appeler fonction expr()
2. Pour reconnaître expr, appeler expr()
3. Retour à 2 → BOUCLE INFINIE
```

### Parser LR (Bottom-Up)
```
Pour reconnaître : expr -> expr + term

1. Lire tokens : 5 + 3
2. Shift 5, réduire term -> expr
3. Shift +
4. Shift 3, réduire term
5. Réduire expr + term -> expr
✓ PAS de boucle infinie
```

## Compilation et Exécution

### Génération du Parser
```bash
javacc grammar.jj
```

Cela génère :
- `ExprParser.java`
- `ExprParserTokenManager.java`
- Plusieurs fichiers support

### Compilation Java
```bash
javac *.java
```

### Exécution
```bash
echo "5 + 3 - 2" | java ExprParser
```

### Test Interactif
```bash
java ExprParser
# Entrez une expression et tapez Ctrl+D
```

## Transformation Bison → JavaCC

### Grammaire Bison (avec récursivité gauche)
```yacc
expr: expr PLUS term    { /* action */ }
    | expr MINUS term   { /* action */ }
    | term              { /* action */ }
    ;
```

### Grammaire JavaCC (sans récursivité gauche)
```java
void Expr() : {}
{
    Term() ExprPrime()
}

void ExprPrime() : {}
{
    [
        (PLUS | MINUS) Term() ExprPrime()
    ]
}
```

## Points Clés pour l'Examen

1. **JavaCC = LL** : Parser top-down récursif descendant
2. **Bison = LR** : Parser bottom-up avec pile
3. **Récursivité gauche** :
   - LL : ❌ Boucle infinie
   - LR : ✅ Fonctionne
4. **Transformation obligatoire** : Éliminer récursivité gauche pour JavaCC
5. **Syntaxe JavaCC** :
   - `void` pour les non-terminaux
   - `< >` pour les tokens
   - `[ ]` pour optionnel (epsilon)
   - `( )` pour groupement

## Erreurs Fréquentes

### Erreur 1 : Récursivité gauche en JavaCC
```java
❌ FAUX (ne compile pas) :
void Expr() : {}
{
    Expr() <PLUS> Term()  // Récursivité gauche !
}
```

### Erreur 2 : Oublier le cas epsilon
```java
❌ FAUX :
void ExprPrime() : {}
{
    <PLUS> Term() ExprPrime()
}
// Manque le cas où expr' -> ε

✓ CORRECT :
void ExprPrime() : {}
{
    [ <PLUS> Term() ExprPrime() ]
    // Les [ ] rendent optionnel = epsilon autorisé
}
```

## Référence Croisée
- **Récursivité gauche** : Voir problem03
- **Élimination** : Voir problem04
- **Comparaison outils** : Ce problème
