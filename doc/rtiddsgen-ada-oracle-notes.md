# rtiddsgen 4.7.0 Ada output — oracle behaviors from the source-idls corpus

Probed with: HelloWorld.idl, module.idl, Constants.idl, ArrayRanges.idl,
base.idl (valuetype), Demo.idl (union), Global.idl (everything), keyed
types.  Header comment and per-file framing identical to the Hello/Shapes
oracles already byte-verified.

## File layout
- Nested modules: EVERY module level gets its own `.ads`
  (`a.ads`, `a-b.ads`); only the module that directly declares types
  gets a `.adb` (`a-b-c.adb`).  Intermediate module specs are empty:
  `package  a.b is\n\n\nend a.b;` (same framing as a type-bearing spec
  but with no body content and NO `with DDS;` lines).
  Module spec with-clause: `with DDS;` + `with DDS.Sequences_Generic;`
  are emitted in EVERY type-bearing module spec (already true).
- Const-only file (no module): `<idlfile>_idl_file.ads` /
  `_idl_file.adb`, package `<File>_IDL_File` (camel from file name).
- `#include`d files are concatenated into one translation unit; the
  `/* $Id ... */` banners are comments, ignored.  rtiddsgen emits ONE
  set of files per top-level file with all included definitions
  inlined (file-name prefix = the file passed on the command line).

## Type blocks (in module spec, in source order)
1. struct (existing templates, byte-verified).
2. enum (existing template, byte-verified).
3. typedef of primitive/scoped:  NO TypeName line; block is:
   `    type N is new <mapped>;` (4-space indent for the first line
   only!) then the standard Access/Array/Convention/TypeCode/
   Initialize/Finalize/Copy/Seq block (3-space indents as structs).
   - `typedef short ShortType;` -> `type ShortType is new Standard.DDS.Short;`
   - `typedef string UnboundedStringType;` -> `is new Standard.DDS.String;`
   - `typedef string<100> String100Type;` -> `is new Standard.DDS.String;`
     (bound is NOT encoded in the Ada type!)
   - `typedef MyEnum E2;` -> `is new <Module>.MyEnum;`
   - `typedef MyStruct S2;` -> `is new <Module>.MyStruct;`
   - `typedef MyStructType S3;` (a typedef of a typedef) ->
     `is new Global_IDL_File.MemberStructType;` (resolved to the
     ORIGINAL defining name, not the previous typedef).
   - `typedef sequence<short,4> SeqShort4Type;` ->
     `is new Standard.DDS.Short_Seq.Sequence;`
   - `typedef sequence<ScopedType,4> T2;` ->
     `is new <Module>.<Elem>_Seq.Sequence;`
4. typedef with array declarator (`typedef short ArrShort4Type[4];`):
   `type ArrShort4Type is array (1..4) of Standard.DDS.Short;  `
   (two trailing spaces) then the standard block.  Multi-dim:
   `is array (1..2, 1..4)` (Ada multi-dim syntax).
   `typedef sequence<short,4> SeqShortArr_2_4Type[2];` ->
   `is array (1..2) of aliased Standard.DDS.Short_Seq.Sequence; `
   (one trailing space; note `aliased` present for seq elements,
   absent for primitive elements; `of Global_IDL_File.String100Type;`
   when elem is a scoped typedef'd type).
5. const:
   `SIZE : constant Standard.DDS.Long := 10;` (no indent) inside the
   module spec at the position of the declaration, followed by
   ` ` (single-space line) after the LAST const before the next type
   block.  In a const-only file, consts appear with a blank line
   between each.  Expression rendering: `3 * 4` -> `3*4` (spaces
   around binary ops removed? NO -- `2*2`, `100+23`, `2.0*(PI)`,
   `(PI)+(PI2)` -- parens added around each operand that is a scoped
   name or parenthesized subexpression; `3*4` plain literals juxtaposed
   with no spaces).  `-2147483649` renders as-is.  Const of typedef'd
   type: `LONG_CONST_123 : constant Constants_IDL_File.MYLONG := 100+23;`
   (module-qualified type name).  String const:
   `MY_STRING : constant Standard.DDS.String := Standard.DDS.To_DDS_String (" Hello World!");`
   (single space after To_DDS_String here, not double).
   `use type Standard.DDS.Long;` lines are emitted at the top of the
   spec (after with-clauses, one per numeric base type used by any
   const, deduped, in first-use order).
6. union `union Demo switch (long)`:
   - `type U_Demo is record` -- members in case order, ALL members
     (it is a flattened struct), same member rendering as structs
     (each member `aliased`, trailing spaces as structs).
   - `     pragma Convention (C, U_Demo);` (5-space indent, quirk)
   - ` ` (single space line)
   - `    type Demo is record` (4-space indent)
   - `     d : Standard.DDS.Long;` (5-space indent, the switch field
     named `d`)
   - `     u : U_Demo;`
   - `    end record;`
   - then the normal `   pragma Convention (C, Demo);` block at 3-space
     indent, Access/Array/TypeCode/Initialize/Finalize/Copy/Seq.
   - TypeName line uses the union name: `Demo_TypeName ... ("...::Demo")`
     BEFORE the `type U_Demo` line.
   - Union gets typesupport/datareader/datawriter files identical to a
     struct's (byte-verified: union vs struct TS bodies are the same
     template).
   - Member arrays inside unions get the `BasicTypesUnion_*_Array`
     pre-decls like structs do (named after the union, not U_*).
7. valuetype `valuetype basetrack_t { public string<10> trackno; ... }`:
   EXACTLY like a struct with the same members; `public/private` is
   ignored.  Gets typesupport files like a struct (only the valuetype
   got per-type files in base.idl; plain structs in the same module
   also got them, so no distinction).
8. interface `interface Interface1 { ... };`: produces NO output at
   all.  A struct member of interface type (`Interface1 member1;`) is
   DROPPED from the struct record (only `member2` remains).
9. Pointer members (`short *pSData;`, `string<100> * pStrData;`):
   rendered `    pSData : access Standard.DDS.Short;` — note:
   `access ` replaces `aliased `, NO trailing spaces when pointer!
   `pSSeqData : access  Standard.DDS.Short_Seq.Sequence;` (double
   space after `access` for sequences, like the `aliased  ` quirk).
10. Member arrays of 2 dims inline in struct:
    `sArrData_2 : aliased BasicTypesStruct_sArrData_2_Array;` with a
    PRE-DECLARED array type before the record:
    `   type BasicTypesStruct_sArrData_2_Array is array (1..2, 1..4) of aliased Standard.DDS.Short;  `
    (3-space indent, two trailing spaces; elem = mapped primitive or
    `Global_IDL_File.MemberStruct` for scoped, or `*_Seq.Sequence` for
    seq-of-array typedef).  1-dim arrays stay inline
    `aliased  <Elem>_Array(1..4)`.  Array bound expressions:
    `(1..(Global_IDL_File.Size_4))` — parenthesized when the bound is
    a scoped name, `(1..4)` literal.
11. Keyed structs (`//@key` comments): NO difference in the Ada output
    (keys only affect XML/QoS).  `//@top-level false` comments: no
    effect.  `//@resolve-name false`: no effect on Ada.

## Name resolution quirk
`PrimitiveType` is declared BOTH at top level (from PrimitiveType.idl
include, as `struct PrimitiveType` outside any module — emitted as part
of the FILE package `Global_IDL_File`, not a `*_idl_file` split) and in
ModuleB.  Wait — actually the top-level struct from an include goes
into the file's implicit package.  The file package name = `<File>_IDL_File`
only when there is NO module at all; when the file has modules AND
top-level defs, the top-level defs go into `<File>_IDL_File` package
(too: `global_idl_file.ads` = package Global_IDL_File which ALSO holds
top-level typedefs/consts), and module files are `global_idl_file-modulea.ads`
= `Global_IDL_File.ModuleA`.  Unqualified references resolve to the
nearest enclosing scope (ModuleB's PrimitiveType referenced from
top-level struct renders as plain `PrimitiveType` — actually it
rendered as `ptData : aliased PrimitiveType;` referring to the
FILE-level one; C-level preprocessor semantics).

## Const placement
- Consts interleave with type blocks in source order inside the
  module spec (ArrayRanges: `SIZE` const appears BEFORE World_T block,
  after the two blank lines, no indent, then ` ` line).
- In HelloWorld (const BEFORE module): goes to `<file>_idl_file.ads`.
- Const expression: `3 * 4` -> `3*4`; `2.0*PI` -> `2.0*(PI)`;
  `PI + PI2` -> `(PI)+(PI2)`; `100 + 23` -> `100+23`.  So: each
  operand that is an identifier gets wrapped in parens; literals are
  bare; no spaces around operators.  Unary minus: `-2147483649` bare.

## Which types get .adb body impls
Every typedef'd type AND every struct/enum/union in the module gets
Initialize/Finalize/Copy in the module's `.adb` (59 impls in
global_idl_file.adb), in the order of the type blocks.  Valuetypes and
unions included; interfaces obviously not.

## Priority order for implementation (parity per file)
1. Nested modules (file layout) — blocks 38 of 53 files.
2. Const emission (27 files) incl. `use type` header lines.
3. Typedef emission (17 files) — primitive/scoped/seq/array forms.
4. Union emission (4 files).
5. Valuetype (5 files) — trivial (already parse as members).
6. Interface drop (2 files) — trivial.
7. Pointer members (2 files) — easy.
8. Multi-dim member arrays + pre-declared array types (1 file: Global).
9. Const-expression rendering rules (parens around identifiers,
   juxtaposed operators).