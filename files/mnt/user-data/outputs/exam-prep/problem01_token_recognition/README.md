# Problème 01 : Analyse Lexicale Pure - Reconnaissance de Tokens

## Notion Théorique Ciblée
**Analyse lexicale** : Première phase de compilation consistant à transformer un flux de caractères en une séquence de tokens.

## Type d'Analyse
- **Lexicale** (exclusivement)
- Aucune analyse syntaxique ou sémantique

## Description du Problème
Ce problème teste la capacité à écrire un scanner (analyseur lexical) complet qui :
1. Reconnaît les différentes catégories de tokens (mots-clés, identifiants, nombres, opérateurs)
2. Respecte la priorité des règles lexicales
3. Gère correctement les espaces et sauts de ligne
4. Détecte les erreurs lexicales

## Pourquoi ce Piège Classique d'Examen ?

### Pièges Fréquents :
1. **Ordre des règles** : Si `{IDENTIFIER}` est placé avant les mots-clés, "if" sera reconnu comme identifiant
2. **Opérateurs composés** : Si "=" est avant "==", le token "==" sera reconnu comme deux "="
3. **Nombres** : Si INTEGER est avant FLOAT, "3.14" sera reconnu comme "3" suivi de ".14"
4. **Gestion des espaces** : Oublier de consommer les espaces cause des erreurs

### Questions Types d'Examen :
- "Que se passe-t-il si on inverse l'ordre de ces deux règles ?"
- "Pourquoi 'if' n'est-il pas reconnu comme identifiant ?"
- "Comment gérer les commentaires ?"

## Compilation et Exécution

### Génération du Code
```bash
flex lexer.l
```

### Compilation
```bash
gcc lex.yy.c -o lexer -lfl
```

### Exécution
```bash
./lexer
```

### Test avec un Fichier
```bash
./lexer < test_input.txt
```

## Exemple d'Entrée
```
int main() {
    int x = 42;
    float y = 3.14;
    if (x == 42) {
        return x + 1;
    }
}
```

## Sortie Attendue
```
Token 1: KEYWORD_INT
Token 2: IDENTIFIER [main]
Token 3: LPAREN
Token 4: RPAREN
Token 5: LBRACE
Token 6: KEYWORD_INT
Token 7: IDENTIFIER [x]
Token 8: OP_ASSIGN [=]
Token 9: INTEGER_LITERAL [42]
...
```

## Points Clés à Retenir pour l'Examen
1. **L'ordre des règles compte** : règles spécifiques avant génériques
2. **Mots-clés vs identifiants** : toujours définir les mots-clés en premier
3. **Opérateurs composés** : définir "==" avant "="
4. **Types de nombres** : FLOAT avant INTEGER
5. **Gestion des espaces** : ne pas les oublier
