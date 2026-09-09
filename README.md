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

Implemented and AUnit-tested: the **Parser / AST** of the Core Data
Types building block (7.4.1, rules 1–68) — `<specification>` /
`<definition>` (rules 1–2), modules (rule 3, incl. reopening), scoped
names (rule 4), constant declarations with the full constant-expression
precedence ladder (rules 5–19: `|` `^` `&` `<<` `>>` `+ -` `* / %`,
unary `+ - ~`, parentheses, boolean literals), type specs incl.
`sequence<T>` / `sequence<T, N>`, `string<N>`, `wstring<N>`,
`fixed<d,s>` (rules 21–43), struct members with array declarators
(rules 46–48, 59–60, 67–68), unions with multi-label cases and
`default` (rules 49–56), enumerations (rules 57–58), `native`
(rule 61), typedefs incl. the inline `typedef struct {...} Name` form
(rules 63–66), and forward declarations — plus the **Annotations
building block** (7.4.15, rules 218–227): `@annotation` declarations
with members and defaults, and applications in all three forms
(`@key`, `@name(value)`, `@name(member = value)`). The `idl2lang_tool
-ast <file.idl>` CLI prints the AST dump.

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
| `IDL2Lang.Syntax` | 7.4.1, 7.4.15 | AST node shapes for rules 1–68 (Core Data Types) and 218–227 (annotations); scoped names, constant-expression trees, type specs, declarators, struct members, union cases, enumerators, annotation applications |
| `IDL2Lang.Parsers` | 7.4.1, 7.4.15 | Recursive-descent parser: rule-2 dispatch, module nesting, the constant-expression precedence ladder, all type forms, struct/union/enum/typedef/native, annotation declarations and applications |

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

AST dump mode:

```
$ tool/idl2lang_tool.exe -ast hello.idl
```

```
(module Hello
  (const string GREETING
    (value "Hello")
  )
  (struct Time
    (member unsigned long long
      seconds
    )
    (member unsigned long
      fraction
    )
  )
)
```

## Roadmap

- [x] Milestone 0 — lexer (clause 7.2 / 7.3)
- [x] Milestone 1 — parser/AST for the Core Data Types building block (7.4.1, rules 1–68) plus annotations (7.4.15, rules 218–227)
- [ ] Milestone 2 — names and scoping (7.5), constant-expression evaluation (7.4.1.4.3)
- [ ] Milestone 3 — codegen framework: tagged-type back-end base class, `language`/`vendor` factory, first target (byte-parity with rtiddsgen's `-language Ada -create typefiles` output)

## Status of Milestone 3 (in progress)

Implemented: `IDL2Lang.Backends` — the abstract tagged-type base class
(one primitive per output language, Goal req. 7), the in-memory output
plumbing (byte-exact `Put`/`Put_Line`/`New_Line`, post-Generate access
via `File_Count`/`File_Name`/`File_Contents`, `Write_All` to disk), and
`IDL2Lang.Backends.Factory` — the `Lookup (Language, Vendor, ...)`
factory in the base class's package (Goal req. 7).

`IDL2Lang.Backends.Ada_RTI` is the first concrete back-end (Goal
req. 4): it emits the four pure-Ada type-support files of
`rtiddsgen -language Ada -create typefiles` — `hello.ads`, `hello.adb`,
`hello-time_datareader.ads`, `hello-time_datawriter.ads` — **byte-identical**
to rtiddsgen 4.7.0's output for structs of primitive members,
including the reference quirk bytes (double space in `package  Hello`,
trailing-space member lines, the `" "` line before the record, the
`To_DDS_String  ("...")` double space, 17-space continuation
indent). The AUnit suite diffs each generated file against the
captured oracle in `test/data/oracle_ada/` byte by byte.

Remaining for full rtiddsgen parity: the C plugin layer (`Hello.c/.h`,
`HelloPlugin.c/.h`, `HelloSupport.c/.h`), non-primitive members
(strings, sequences, arrays, scoped-name members), enums/unions as
members, nested modules, and multiple structs per module.

## License

GPL-3.0-or-later (same as the author's other Ada projects).