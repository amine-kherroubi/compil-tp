# Problème 18 : Structures de Boucles

## Notion Théorique
**Boucles** : for, while, do-while, break, continue.

## Type d'Analyse
- **Syntaxique + Sémantique**

## Vérifications
- break/continue doivent être dans une boucle
- Compteur de profondeur de boucle

## Compilation
```bash
bison -d parser.y && flex lexer.l && gcc y.tab.c lex.yy.c -o parser -lfl
```

## Test
```
for (i=0; i<10; i++) {
    if (i == 5) break;
    if (i == 3) continue;
}
```
