# Problème 15 : Analyse Sémantique Complète

## Notion Théorique
**Analyse sémantique** : Vérifications au-delà de la syntaxe (portée, types, initialisation).

## Type d'Analyse
- **Sémantique**

## Vérifications
1. **Portée** : variables locales vs globales
2. **Déclaration** : utilisation avant déclaration
3. **Initialisation** : lecture avant écriture
4. **Types** : compatibilité

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Points Clés
1. Portée gérée par stack
2. Détection variables non initialisées
3. Analyse de flot de données
