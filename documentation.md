# Complete Study Guide: Flex, Bison & JavaCC

## FLEX (Fast Lexical Analyzer Generator)

### Purpose
Generates lexical analyzers (scanners/tokenizers) that break input text into tokens based on regular expression patterns.

### File Structure
```
%{
/* C/C++ declarations, includes, global variables */
%}

/* Definitions section - name patterns for reuse */

%%
/* Rules section - pattern-action pairs */
%%

/* User code section - additional C/C++ functions */
```

---

## FLEX CONSTRUCTS

### 1. **Definitions Section**
**Intent:** Define named patterns to simplify and reuse in rules section

```flex
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*
```

- Use curly braces `{NAME}` to reference defined patterns
- Improves readability and maintainability

### 2. **Rules Section Pattern Syntax**

#### Basic Patterns
- **`x`** - Match character 'x'
- **`.`** - Match any single character except newline
- **`[xyz]`** - Character class: match x, y, or z
- **`[a-z]`** - Range: match any lowercase letter
- **`[^a-z]`** - Negated class: match anything except lowercase letters

#### Repetition Operators
- **`*`** - Zero or more occurrences
- **`+`** - One or more occurrences
- **`?`** - Zero or one occurrence (optional)
- **`{n}`** - Exactly n occurrences
- **`{n,}`** - n or more occurrences
- **`{n,m}`** - Between n and m occurrences

#### Anchors
- **`^`** - Beginning of line
- **`$`** - End of line

#### Grouping & Alternation
- **`|`** - Alternation (OR): `cat|dog` matches "cat" or "dog"
- **`()`** - Grouping: `(ab)+` matches "ab", "abab", etc.

#### Escaping
- **`\`** - Escape special characters: `\*` matches literal asterisk

#### Context Sensitivity
- **`pattern/lookahead`** - Match pattern only if followed by lookahead (trailing context)

### 3. **Actions**

**Intent:** Execute C code when a pattern matches

```flex
{ID}          { return IDENTIFIER; }
{DIGIT}+      { yylval = atoi(yytext); return NUMBER; }
"+"           { return PLUS; }
[ \t\n]       { /* skip whitespace */ }
.             { printf("Unknown: %s\n", yytext); }
```

- Actions are C code enclosed in `{ }`
- Multiple statements allowed
- Can return tokens to parser
- Can manipulate `yylval` (semantic value)

### 4. **Special Variables**

- **`yytext`** - Pointer to matched text (char*)
- **`yyleng`** - Length of matched text
- **`yylval`** - Semantic value passed to parser (you set this)
- **`yylineno`** - Current line number (needs `%option yylineno`)

### 5. **Special Functions**

- **`yylex()`** - Main scanning function (generated)
- **`yywrap()`** - Called at EOF; return 1 to stop, 0 to continue with new input
- **`ECHO`** - Macro to print matched text to output
- **`REJECT`** - Reject current match, try next rule
- **`yymore()`** - Append next match to current yytext
- **`yyless(n)`** - Push back all but first n characters
- **`unput(c)`** - Put character back into input stream
- **`input()`** - Read next character from input

### 6. **Start Conditions (States)**

**Intent:** Create different scanning contexts for different situations

**Exclusive states:**
```flex
%x COMMENT STRING
```

**Inclusive states:**
```flex
%s INITIAL
```

**Usage:**
```flex
<INITIAL>"/*"        { BEGIN(COMMENT); }
<COMMENT>"*/"        { BEGIN(INITIAL); }
<COMMENT>.           { /* ignore comment text */ }
<STRING>\"           { BEGIN(INITIAL); return STRING_LIT; }
```

- **`BEGIN(STATE)`** - Switch to a state
- **`<STATE>pattern`** - Rule only active in STATE
- **`<*>pattern`** - Rule active in all states
- Exclusive (%x): Only rules for that state match
- Inclusive (%s): Rules for that state + stateless rules match

### 7. **Options**

```flex
%option noyywrap     /* Don't call yywrap() at EOF */
%option yylineno     /* Track line numbers automatically */
%option case-insensitive  /* Ignore case in patterns */
%option debug        /* Enable debug output */
```

### 8. **Pattern Matching Priority**

1. **Longest match wins** - "for" vs "f" when input is "for"
2. **First rule wins** - If two rules match same length, first defined wins
3. Use this for keyword vs identifier conflicts:
```flex
"if"        { return IF; }      /* Must come before ID */
{ID}        { return ID; }
```

---

## BISON (GNU Parser Generator)

### Purpose
Generates LALR(1) parsers from grammar specifications. Performs syntax analysis and builds parse trees/ASTs.

### File Structure
```
%{
/* C declarations, includes */
%}

/* Bison declarations: tokens, types, precedence */

%%
/* Grammar rules */
%%

/* Additional C code */
```

---

## BISON CONSTRUCTS

### 1. **Token Declarations**

**Intent:** Declare terminal symbols (from lexer)

```bison
%token IDENTIFIER NUMBER
%token PLUS MINUS TIMES DIVIDE
%token IF ELSE WHILE
```

- Tokens are returned by `yylex()`
- Bison generates `#define` constants for each token

### 2. **Type Declarations**

**Intent:** Associate C types with symbols for semantic values

```bison
%union {
    int intval;
    float floatval;
    char *strval;
    struct ast_node *node;
}

%token <intval> NUMBER
%token <strval> IDENTIFIER
%type <node> expression statement
```

- **`%union`** - Defines `YYSTYPE` (type of `yylval` and `$$`)
- **`%token <field>`** - Associates token with union field
- **`%type <field>`** - Associates non-terminal with union field
- **`$$`** - Semantic value of LHS (left-hand side)
- **`$1, $2, ...`** - Semantic values of RHS symbols

### 3. **Grammar Rules**

**Intent:** Define syntax structure and build semantic values

```bison
expression: 
    term                    { $$ = $1; }
    | expression PLUS term  { $$ = make_add_node($1, $3); }
    | expression MINUS term { $$ = make_sub_node($1, $3); }
    ;

term:
    factor                  { $$ = $1; }
    | term TIMES factor     { $$ = make_mul_node($1, $3); }
    ;
```

**Format:** `nonterminal: production1 { action } | production2 { action } ;`

### 4. **Operator Precedence & Associativity**

**Intent:** Resolve shift/reduce conflicts without explicit grammar restructuring

```bison
%left PLUS MINUS          /* Left associative, lowest precedence */
%left TIMES DIVIDE        /* Left associative, higher precedence */
%right ASSIGN             /* Right associative */
%nonassoc EQUAL NOTEQUAL  /* Non-associative */
```

- **Order matters:** Later declarations have higher precedence
- **`%left`** - Left associative: `a + b + c` = `(a + b) + c`
- **`%right`** - Right associative: `a = b = c` = `a = (b = c)`
- **`%nonassoc`** - Cannot chain: `a < b < c` is illegal

### 5. **Precedence for Rules**

**Intent:** Assign precedence to entire rules (e.g., for dangling else)

```bison
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

stmt:
    IF expr stmt %prec LOWER_THAN_ELSE  { $$ = make_if($2, $3); }
    | IF expr stmt ELSE stmt            { $$ = make_if_else($2, $3, $5); }
    ;
```

- **`%prec TOKEN`** - Gives rule same precedence as TOKEN

### 6. **Start Symbol**

**Intent:** Define the root of the grammar

```bison
%start program

program: statement_list ;
```

- Default start symbol is first non-terminal in grammar
- Use `%start` to override

### 7. **Epsilon Productions (Empty Rules)**

**Intent:** Allow optional elements or base cases

```bison
statement_list:
    /* empty */              { $$ = NULL; }
    | statement_list statement { $$ = append($1, $2); }
    ;
```

- Comment `/* empty */` documents the epsilon production

### 8. **Error Recovery**

**Intent:** Continue parsing after syntax errors

```bison
statement:
    expr SEMICOLON          { $$ = $1; }
    | error SEMICOLON       { yyerrok; $$ = NULL; }
    ;
```

- **`error`** - Special token representing error state
- **`yyerrok`** - Resume normal parsing
- **`yyclearin`** - Discard current lookahead token

### 9. **Special Functions**

- **`yyparse()`** - Main parsing function (generated)
- **`yyerror(char *msg)`** - Error reporting (you must define)
- **`yylex()`** - Lexer function (provided by Flex or you)

### 10. **Special Variables in Actions**

- **`$$`** - Semantic value of current rule's LHS
- **`$1, $2, ... $n`** - Semantic values of RHS symbols (1-indexed)
- **`@$`** - Location of current rule's LHS
- **`@1, @2, ... @n`** - Locations of RHS symbols

### 11. **Conflict Resolution**

**Shift/Reduce Conflict:**
- Parser doesn't know whether to shift next token or reduce current rule
- **Default:** Shift
- **Fix:** Use precedence declarations or restructure grammar

**Reduce/Reduce Conflict:**
- Parser can reduce using multiple different rules
- **Default:** Use first rule in grammar
- **Fix:** Usually indicates grammar ambiguity - must restructure

### 12. **Mid-Rule Actions**

**Intent:** Execute code in middle of a production

```bison
stmt: 
    IF expr { context_push(); } stmt { context_pop(); $$ = make_if($2, $4); }
    ;
```

- Bison creates hidden non-terminal for mid-rule action
- Can access earlier semantic values: `$1, $2, ...`

### 13. **Named References**

**Intent:** More readable semantic actions

```bison
expression[result]:
    term[t]                             { $result = $t; }
    | expression[e] PLUS term[t]        { $result = $e + $t; }
    ;
```

- Clearer than numbered references
- Reduces errors when grammar changes

---

## JAVACC (Java Compiler Compiler)

### Purpose
Generates LL(k) parsers in Java. Combines lexical analysis and parsing in one specification.

### File Structure
```java
options { }           // Parser options
PARSER_BEGIN(ParserName)
    /* Java class definition */
PARSER_END(ParserName)

/* Token specifications */
/* Grammar rules */
```

---

## JAVACC CONSTRUCTS

### 1. **Options Block**

**Intent:** Configure parser generation

```java
options {
    STATIC = false;              // Non-static parser (for multiple instances)
    LOOKAHEAD = 2;              // Default lookahead
    IGNORE_CASE = true;         // Case-insensitive keywords
    DEBUG_PARSER = false;
    DEBUG_TOKEN_MANAGER = false;
}
```

### 2. **Parser Class Definition**

**Intent:** Embed Java class with custom methods and fields

```java
PARSER_BEGIN(MyParser)
import java.io.*;

public class MyParser {
    static int errorCount = 0;
    
    public static void main(String[] args) throws ParseException {
        MyParser parser = new MyParser(System.in);
        parser.Program();
    }
}
PARSER_END(MyParser)
```

### 3. **Token Specifications**

#### Skip Tokens
**Intent:** Ignore whitespace, comments

```java
SKIP : {
    " " | "\t" | "\n" | "\r"
    | <"//" (~["\n", "\r"])* ("\n" | "\r" | "\r\n")>    // Single-line comment
    | <"/*" (~["*"])* "*" (~["/"] (~["*"])* "*")* "/">  // Multi-line comment
}
```

#### Token Definitions
**Intent:** Define terminal symbols with regular expressions

```java
TOKEN : {
    <INTEGER: (["0"-"9"])+>
    | <FLOAT: (["0"-"9"])+ "." (["0"-"9"])+>
    | <IDENTIFIER: ["a"-"z", "A"-"Z"] (["a"-"z", "A"-"Z", "0"-"9", "_"])*>
    | <STRING: "\"" (~["\"", "\\", "\n", "\r"])* "\"">
}
```

#### Reserved Words
**Intent:** Define keywords with higher priority

```java
TOKEN : {
    <IF: "if">
    | <ELSE: "else">
    | <WHILE: "while">
    | <RETURN: "return">
}
```

- Keywords must be defined before general identifiers to match first

### 4. **Regular Expression Syntax**

- **`"literal"`** - String literal
- **`["a"-"z"]`** - Character class
- **`~["a"]`** - Negated character class (anything except "a")
- **`(expr)*`** - Zero or more
- **`(expr)+`** - One or more
- **`(expr)?`** - Optional
- **`expr1 | expr2`** - Alternation
- **`expr1 expr2`** - Concatenation
- **`(expr){n}`** - Exactly n times
- **`(expr){n,m}`** - Between n and m times

### 5. **Lexical States**

**Intent:** Context-sensitive tokenization

```java
TOKEN_MGR_DECLS : {
    static int commentNesting = 0;
}

<DEFAULT> TOKEN : {
    <"/*"> : IN_COMMENT
}

<IN_COMMENT> TOKEN : {
    <"/*"> { commentNesting++; }
    | <"*/"> { if (commentNesting > 0) commentNesting--; else SwitchTo(DEFAULT); }
    | <~[]>
}
```

- **`<STATE>`** - Define tokens only valid in STATE
- **`: STATE`** - Transition to STATE after match
- **`SwitchTo(STATE)`** - Programmatic state switch

### 6. **Production Rules**

**Intent:** Define grammar and build AST/execute actions

```java
void Expression() : {}
{
    Term() ( ("+"|"-") Term() )*
}

int Term() : 
{ int val, op; }
{
    val = Factor() 
    ( 
        ("*" | "/") op = Factor() 
        { val = calculate(val, op); }
    )*
    { return val; }
}
```

**Format:**
```java
ReturnType RuleName() :
{ /* Local variable declarations */ }
{
    /* BNF grammar with embedded Java code */
}
```

### 7. **Token Matching**

**Intent:** Match tokens in productions

```java
void IfStatement() : {}
{
    <IF> "(" Expression() ")" Statement()
    [ <ELSE> Statement() ]
}
```

- **`<TOKENNAME>`** - Match specific token
- **`"literal"`** - Match literal string (implicit token)

### 8. **Lookahead**

**Intent:** Resolve choice points and control parsing

#### Syntactic Lookahead
```java
void Statement() : {}
{
    LOOKAHEAD(2) Assignment()
    | FunctionCall()
}
```

- **`LOOKAHEAD(n)`** - Look ahead n tokens to decide

#### Semantic Lookahead
```java
void Declaration() : {}
{
    LOOKAHEAD( {isTypeName(getToken(1).image)} )
    TypeDeclaration()
    | VariableDeclaration()
}
```

- **`LOOKAHEAD( {boolean expression} )`** - Use Java code for decision

#### Infinite Lookahead
```java
LOOKAHEAD( Expression() "=" )
```

- **`LOOKAHEAD( production )`** - Try parsing production, backtrack if doesn't match

### 9. **Try-Catch Error Handling**

**Intent:** Handle parse errors gracefully

```java
void Statement() : {}
{
    try {
        Expression() ";"
    } catch (ParseException e) {
        System.err.println("Error: " + e.getMessage());
        Token t;
        do {
            t = getNextToken();
        } while (t.kind != SEMICOLON && t.kind != EOF);
    }
}
```

### 10. **Token Actions**

**Intent:** Execute code when token is matched

```java
TOKEN : {
    <INTEGER: (["0"-"9"])+> 
    { 
        int val = Integer.parseInt(image);
        if (val > MAX_INT) throw new TokenMgrError("Integer overflow", 0);
    }
}
```

### 11. **Special Token (for Preserved Comments)**

**Intent:** Keep comments attached to tokens for documentation

```java
SPECIAL_TOKEN : {
    <SINGLE_LINE_COMMENT: "//" (~["\n","\r"])* ("\n"|"\r"|"\r\n")>
}
```

- Special tokens are attached to next regular token
- Accessible via `token.specialToken`

### 12. **Token Manager Interface**

**Intent:** Access token properties in Java code

```java
void parse() : 
{ Token t; }
{
    t = <IDENTIFIER>
    {
        System.out.println("Token: " + t.image);
        System.out.println("Line: " + t.beginLine);
        System.out.println("Column: " + t.beginColumn);
    }
}
```

- **`t.image`** - Matched text
- **`t.kind`** - Token type constant
- **`t.beginLine, t.endLine`** - Line numbers
- **`t.beginColumn, t.endColumn`** - Column positions

### 13. **Returning Values from Productions**

**Intent:** Build AST or compute values during parsing

```java
ASTNode Expression() :
{ ASTNode left, right; }
{
    left = Term()
    (
        "+" right = Term() { left = new AddNode(left, right); }
        | "-" right = Term() { left = new SubNode(left, right); }
    )*
    { return left; }
}
```

### 14. **JJTREE Integration**

**Intent:** Automatic AST construction

```java
options {
    MULTI = true;
    NODE_DEFAULT_VOID = true;
}

ASTNode Expression() #Expression : {}
{
    Term() ( ("+"|"-") Term() )*
}
```

- **`#NodeName`** - Create node for this production
- **`#void`** - Don't create node
- JJTree preprocessor generates tree-building code

---

## KEY DIFFERENCES SUMMARY

### Flex vs JavaCC Tokenization
| Feature | Flex | JavaCC |
|---------|------|---------|
| Pattern syntax | POSIX regex | Similar but different escaping |
| Actions | C code in `{ }` | Java code in `{ }` |
| States | `%x`, `%s`, `BEGIN()` | `<STATE>`, `: STATE` |
| Token values | Set `yylval` manually | Return from production |

### Bison vs JavaCC Parsing
| Feature | Bison | JavaCC |
|---------|-------|---------|
| Parser type | LALR(1) bottom-up | LL(k) top-down |
| Lookahead | 1 token (with GLR mode for more) | Configurable k tokens |
| Ambiguity handling | Precedence declarations | Lookahead specifications |
| Language | Generates C/C++ | Generates Java |
| Lexer integration | Separate (Flex) | Integrated |
| Actions | Between `{ }` in rules | Embedded Java code |
| Semantic values | `$$`, `$1`, etc. | Return values |

---

## COMMON EXAM PATTERNS

### 1. Writing Flex Patterns
- **Identifiers:** `[a-zA-Z_][a-zA-Z0-9_]*`
- **Integers:** `[0-9]+` or `0|[1-9][0-9]*`
- **Floats:** `[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?`
- **Strings:** `\"([^\"\\]|\\.)*\"`
- **Comments:** `"/*"([^*]|\*+[^*/])*\*+"/"` or use states

### 2. Bison Precedence Questions
```bison
%left '+' '-'
%left '*' '/'
%right '^'
```
Expression `2 + 3 * 4 ^ 2 ^ 3`:
1. `4 ^ 2 ^ 3` → `4 ^ (2 ^ 3)` (right assoc)
2. `3 * 262144` → `786432`
3. `2 + 786432` → `786434`

### 3. Shift/Reduce Conflict Resolution
- **Dangling else:** Use `%nonassoc` and `%prec`
- **Expression precedence:** Use `%left`, `%right`, `%nonassoc`

### 4. JavaCC Lookahead Calculation
```java
LOOKAHEAD(2)
```
Means: Look ahead 2 tokens to decide which production to use

### 5. Building ASTs
**Bison approach:**
```bison
%union { struct node *ast; }
expr: expr '+' term { $$ = make_node('+', $1, $3); }
```

**JavaCC approach:**
```java
ASTNode Expression() : { ASTNode left, right; }
{ 
    left = Term() 
    "+" right = Term() 
    { return new BinaryOp("+", left, right); } 
}
```

---

## CRITICAL DEBUGGING TIPS

### Flex
- Use `ECHO;` in actions to see what's matching
- Enable `%option debug` for detailed output
- Check pattern order (first match wins for same length)

### Bison
- Run with `-v` flag to generate `.output` file showing states and conflicts
- Use `-t` flag and `yydebug = 1` for parse trace
- Check for conflicts in `.output` file

### JavaCC
- Use `DEBUG_PARSER = true;` and `DEBUG_TOKEN_MANAGER = true;`
- Add `System.out.println()` in actions to trace execution
- Check lookahead carefully for choice points

---

## QUICK SYNTAX REFERENCE

### Flex Pattern Metacharacters
`. ^ $ [ ] * + ? { } | ( ) \ /`

### Bison Special Symbols
`$$ $1 $2 @$ @1 @2 error`

### JavaCC Reserved Words
`PARSER_BEGIN PARSER_END TOKEN SKIP MORE SPECIAL_TOKEN TOKEN_MGR_DECLS LOOKAHEAD IGNORE_CASE`

---

## PRACTICE CHECKLIST

- [ ] Write Flex patterns for common token types
- [ ] Handle keywords vs identifiers priority in Flex
- [ ] Use Flex start conditions for comments/strings
- [ ] Write Bison grammar with proper precedence
- [ ] Resolve shift/reduce conflicts
- [ ] Build AST nodes in Bison actions
- [ ] Write JavaCC combined lexer/parser
- [ ] Use JavaCC lookahead for ambiguous grammar
- [ ] Handle errors in all three tools
- [ ] Convert between Flex/Bison and JavaCC

Good luck on your exam!