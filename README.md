# idl2lang — OMG IDL 4.2 front-end and multi-language code generator in Ada

A front-end for **OMG IDL 4.2** (Interface Definition Language, OMG document
[formal/18-01-05](https://www.omg.org/spec/IDL/4.2/)), written in Ada, with a
framework for generating code in target programming languages from IDL
specifications.

The goal is a spec-traceable implementation: every token form, grammar rule,
and semantic rule is taken from the normative text of the specification and
cross-referenced to its clause number in the source comments.

## Status

Work in progress. Implemented and AUnit-tested: the **Lexical Conventions**
of clause 7.2 — the five token kinds of 7.2.1 (identifiers, keywords,
literals, operators, separators), comments (7.2.2), identifiers incl.
escaped identifiers and the case-collision rule (7.2.3, 7.2.3.1, 7.2.3.2),
the 83 keywords of Table 7-6 with exact-spelling matching (7.2.4), the
punctuation of Tables 7-7/7-8 with longest-match `::` `<<` `>>` `&&` `||`,
and the literals of 7.2.6: integer (7.2.6.1, with the octal 8/9 digit
check), character (7.2.6.2, Table 7-9 escape sequences), string (7.2.6.3,
adjacent-literal concatenation), floating-point (7.2.6.4), and fixed-point
(7.2.6.5); plus the recognition of preprocessor directive lines with
backslash-newline continuation (7.3). The `idl2lang_tool` CLI prints the
token stream of an IDL file.

## Layout

| Path | Contents |
|---|---|
| `src/` | The library (static library project `idl2lang.gpr`) |
| `tool/` | CLI driver project (`idl2lang_tool.gpr`) — prints the token stream of an IDL file |
| `test/` | AUnit test driver (`test_idl2lang.gpr`) |
| `doc/` | The IDL 4.2 specification PDF and extracted text (untracked; fetch from https://www.omg.org/spec/IDL/4.2/PDF) |

### Library sources (`src/`)

| Package | Spec clause | Description |
|---|---|---|
| `IDL2Lang.Tokens` | 7.2.1, 7.2.4 | Token kinds (five token classes of 7.2.1), keyword table (Table 7-6), case-collision lookup (7.2.4) |
| `IDL2Lang.Lexers` | 7.2, 7.3 | Lexical analysis: white space/comments, identifiers and escaped identifiers, keywords (exact spelling, case-collision rejection), punctuation (longest match), integer/character/string/floating/fixed literals, directive lines |

## Usage

```
$ gprbuild -P idl2lang.gpr && gprbuild -P tool/idl2lang_tool.gpr
$ tool/idl2lang_tool.exe hello.idl
```

```
//  hello.idl
module Hello {
  const string GREETING = "Hello";
  struct Time {
    unsigned long long seconds;
    unsigned long fraction;
  };
};
```

```
1:1 keyword module
1:8 identifier Hello
1:14 {
2:3 keyword const
2:9 keyword string
...
```

## Roadmap

- [x] Milestone 0 — lexer (clause 7.2 / 7.3)
- [ ] Milestone 1 — parser/AST for the Core Data Types building block (7.4.1, rules 1–68)
- [ ] Milestone 2 — names and scoping (7.5), constant-expression evaluation (7.4.1.4.3)
- [ ] Milestone 3 — codegen framework + first target back-end

## License

GPL-3.0-or-later (same as the author's other Ada projects).