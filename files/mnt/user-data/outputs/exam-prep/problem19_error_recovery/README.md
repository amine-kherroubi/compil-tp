# Problème 19 : Récupération d'Erreurs

## Notion Théorique
**Error recovery** : Continuer l'analyse après une erreur syntaxique.

## Type d'Analyse
- **Syntaxique**

## Mécanismes
- Token `error` : point de synchronisation
- `yyerrok` : effacer état d'erreur
- `yyclearin` : vider le token courant

## Stratégies
1. **Panic mode** : ignorer jusqu'à `;`
2. **Phrase level** : insérer/supprimer tokens
3. **Error productions** : règles explicites

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Points Clés
- Permet de détecter plusieurs erreurs
- Évite l'arrêt au premier problème
