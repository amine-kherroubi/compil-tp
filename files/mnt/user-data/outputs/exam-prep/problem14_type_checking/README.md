# Problème 14 : Vérification de Types

## Notion Théorique
**Type checking** : Vérification de la compatibilité des types lors des opérations.

## Type d'Analyse
- **Sémantique**

## Erreurs Détectées
- Affectation incompatible : `int x = 3.14`
- Opération incompatible : `int + float`
- Variable non déclarée

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Points Clés
1. **Types propagent** dans l'AST
2. **Règles de compatibilité**
3. **Coercition** : conversions automatiques
