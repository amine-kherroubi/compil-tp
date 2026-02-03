# Problème 13 : Table des Symboles

## Notion Théorique
**Table des symboles** : Structure de données stockant les informations sur les identificateurs.

## Type d'Analyse
- **Sémantique**

## Informations Stockées
- Nom de la variable
- Type
- Portée (scope)
- Adresse mémoire

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Points Clés
1. **Lookup** : recherche O(n) ou hash
2. **Déclaration** : ajouter symbole
3. **Utilisation** : vérifier existence
4. **Redéfinition** : erreur sémantique
