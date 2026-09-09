------------------------------------------------------------------------------
--  IDL2Lang.Syntax -- abstract syntax tree for OMG IDL 4.2 definitions
--
--  The node shapes follow the grammar rules of clause 7.4.1 (Core Data
--  Types, rules 1-68) and clause 7.4.15 (Annotations, rules 218-227).
--  Every field carries a comment citing the rule it implements.  Trees
--  are linked through access types (Expression_Ref, Type_Spec_Ref,
--  Definition_Ref) so that recursive shapes (module bodies, sequence
--  element types, constant-expression operands) can be represented
--  without container recursion.
--
--  Literal leaves keep the raw lexeme text (7.2.6 forms); evaluation is
--  a separate concern (constant-expression semantics of 7.4.1.4.3).
------------------------------------------------------------------------------

with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

package IDL2Lang.Syntax is

   use Ada.Strings.Unbounded;

   ---------------------------------------------------------------------------
   --  Scoped names -- rule (4)
   ---------------------------------------------------------------------------

   package Name_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Unbounded_String);

   type Scoped_Name_T is record
      Absolute : Boolean := False;
      --  True iff the name starts with "::" (rule 4, second alternative).

      Parts : Name_Vectors.Vector;
      --  The <identifier>s joined by "::" (rule 4); never empty.
   end record;

   function To_Scoped_Name (Text : String) return Scoped_Name_T;
   --  Split "A::B::C" / "::A::B" into its rule-4 representation (used by
   --  tests and tooling; the parser builds names incrementally).

   function Image (Name : Scoped_Name_T) return String;
   --  Reconstitute the scoped name with "::" separators.

   ---------------------------------------------------------------------------
   --  Constant expressions -- rules (7)-(18)
   ---------------------------------------------------------------------------

   type Expr_Kind_T is
     (E_Scoped_Name,               --  rule (16)
      E_Integer,                   --  rule (17), 7.2.6.1
      E_Floating_Point,            --  rule (17), 7.2.6.4
      E_Fixed_Point,               --  rule (17), 7.2.6.5
      E_Character,                 --  rule (17), 7.2.6.2
      E_Wide_Character,            --  rule (17), L'x' (7.2.6.2)
      E_String,                    --  rule (17), 7.2.6.3
      E_Wide_String,               --  rule (17), L"..." (7.2.6.3)
      E_Boolean,                   --  rule (18): TRUE | FALSE
      --  Infix operators, in the precedence order of rules (8)-(13).
      E_Or,                        --  rule (8)  "|"
      E_Xor,                       --  rule (9)  "^"
      E_And,                       --  rule (10) "&"
      E_Shift_Left,                --  rule (11) "<<"
      E_Shift_Right,               --  rule (11) ">>"
      E_Add,                       --  rule (12) "+"
      E_Subtract,                  --  rule (12) "-"
      E_Multiply,                  --  rule (13) "*"
      E_Divide,                    --  rule (13) "/"
      E_Remainder,                 --  rule (13) "%"
      --  Unary operators, rule (15).
      E_Unary_Plus,
      E_Unary_Minus,
      E_Complement);               --  "~"

   type Expression_T;
   type Expression_Ref is access Expression_T;

   package Expression_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Expression_Ref);

   type Expression_T is record
      Kind : Expr_Kind_T := E_Integer;
      Line : Positive := 1;
      Col  : Positive := 1;

      --  E_Scoped_Name:
      Name : Scoped_Name_T;
      --  Literal kinds (E_Integer .. E_Boolean): the raw lexeme as
      --  scanned (7.2.6), e.g. "014", "1.5e10", "'X'", """Hello""",
      --  "TRUE".  Empty for operator nodes.
      Literal_Text : Unbounded_String;
      --  Operator nodes: Left is always present; Right is null for the
      --  unary operators (rule 15).
      Left  : Expression_Ref := null;
      Right : Expression_Ref := null;
   end record;

   function Image (Expr : Expression_T) return String;
   --  Parenthesized infix form of the expression tree, e.g. "(2 + (3 * 4))".

   ---------------------------------------------------------------------------
   --  Types -- rules (21)-(43)
   ---------------------------------------------------------------------------

   type Type_Kind_T is
     (T_Short,                     --  rule (27)
      T_Unsigned_Short,            --  rule (31)
      T_Long,                      --  rule (28)
      T_Unsigned_Long,             --  rule (32)
      T_Long_Long,                 --  rule (29)
      T_Unsigned_Long_Long,        --  rule (33)
      T_Float,                     --  rule (24)
      T_Double,                    --  rule (24)
      T_Long_Double,               --  rule (24)
      T_Char,                      --  rule (34)
      T_Wide_Char,                 --  rule (35)
      T_Boolean,                   --  rule (36)
      T_Octet,                     --  rule (37)
      T_Scoped_Name,               --  rule (22): a named type
      T_Sequence,                  --  rule (39)
      T_String,                    --  rule (40)
      T_Wide_String,               --  rule (41)
      T_Fixed,                     --  rule (42)
      T_Any);                      --  rule (224): the "any" const type of
                                   --  annotation members (7.4.15)

   type Type_Spec_T;
   type Type_Spec_Ref is access Type_Spec_T;

   type Type_Spec_T is record
      Kind : Type_Kind_T := T_Short;
      Line : Positive := 1;
      Col  : Positive := 1;

      --  T_Scoped_Name:
      Type_Name : Scoped_Name_T;
      --  T_Sequence (rule 39): the element type; Bound is null for the
      --  unbounded form.
      Element_Type : Type_Spec_Ref := null;
      Bound        : Expression_Ref := null;
      --  T_String / T_Wide_String (rules 40-41): null = unbounded.
      String_Bound : Expression_Ref := null;
      --  T_Fixed (rule 42): digits and scale.
      Fixed_Digits : Expression_Ref := null;
      Fixed_Scale  : Expression_Ref := null;
   end record;

   function Image (Typ : Type_Spec_T) return String;
   --  IDL source-like spelling of the type, e.g. "sequence<long, 4>".

   ---------------------------------------------------------------------------
   --  Declarators -- rules (59), (62), (66)-(68)
   ---------------------------------------------------------------------------

   type Declarator_T is record
      Name : Unbounded_String;             --  simple_declarator, rule (62)
      Array_Dims : Expression_Vectors.Vector;
      --  Empty unless an array_declarator (rules 59-60); each element is
      --  one fixed_array_size's <positive_int_const> in source order.
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Declarator_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Declarator_T);

   ---------------------------------------------------------------------------
   --  Struct members -- rule (47); union cases -- rules (53)-(55)
   ---------------------------------------------------------------------------

   type Annotation_Appl_T;
   type Annotation_Param_T is record
      Named : Boolean := False;
      --  True for <annotation_appl_param> (rule 227: "id = expr"), False
      --  for the single positional <const_expr> of rule 226.

      Member_Name : Unbounded_String;
      --  The member identifier when Named (rule 227); "" otherwise.

      Value : Expression_Ref := null;
      --  The parameter's <const_expr>.
   end record;

   package Annotation_Param_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Annotation_Param_T);

   type Annotation_Appl_T is record
      Name : Scoped_Name_T;                 --  rule (225): "@" scoped_name
      Params : Annotation_Param_Vectors.Vector;
      --  Empty for the "@Name" short form; one positional entry for
      --  "@Name(expr)" (rule 226, first alternative); named entries
      --  otherwise (rule 226, second alternative).
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Annotation_Appl_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Annotation_Appl_T);

   type Member_T is record
      Annotations : Annotation_Appl_Vectors.Vector;
      --  Annotations applied to this member (rule 225, applied before
      --  the member; e.g. "@key long id;").

      Member_Type : Type_Spec_Ref := null;  --  rule (47): <type_spec>
      Declarators : Declarator_Vectors.Vector;   --  rule (47): <declarators>
      Is_Pointer : Boolean := False;
      --  True when the member's declarator is a pointer declarator
      --  ("<type> "*" <declarator>", e.g. "long * member;" or the
      --  forward-value-type reference "fwd_struct* fwd_value;").  The
      --  pointer belongs to the declarator, but every corpus use
      --  declares one pointer per member, so keeping one flag here is
      --  enough for the back-ends.
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Member_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Member_T);

   type Label_Kind_T is (L_Case, L_Default);   --  rule (54)

   type Case_Label_T is record
      Kind : Label_Kind_T := L_Case;
      Value : Expression_Ref := null;
      --  The <const_expr> of "case <const_expr> :" when Kind = L_Case.
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Case_Label_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Case_Label_T);

   type Union_Case_T is record
      Annotations : Annotation_Appl_Vectors.Vector;
      Labels : Case_Label_Vectors.Vector;   --  rule (53): <case_label>+
      Element_Type : Type_Spec_Ref := null; --  rule (55): <type_spec>
      Element_Name : Declarator_T;          --  rule (55): <declarator>
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Union_Case_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Union_Case_T);

   ---------------------------------------------------------------------------
   --  Definitions -- rules (1)-(3), (5), (20), (44)-(48), (49)-(56),
   --  (57)-(58), (61), (63), (218)-(220)
   ---------------------------------------------------------------------------

   type Definition_Kind_T is
     (D_Module,                    --  rule (3)
      D_Const,                     --  rule (5)
      D_Typedef,                   --  rule (63)
      D_Struct,                    --  rule (46)
      D_Struct_Forward,            --  rule (48)
      D_Union,                     --  rule (50)
      D_Union_Forward,             --  rule (56)
      D_Enum,                      --  rule (57)
      D_Native,                    --  rule (61)
      D_Annotation,                --  rule (219)
      D_Value_Type,                --  rule (79): valuetype
      D_Interface);                --  rule (86): interface (ops skipped)

   type Definition_T;
   type Definition_Ref is access Definition_T;

   package Definition_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Definition_Ref);

   type Enumerator_T is record
      Name : Unbounded_String;             --  rule (58): just an identifier
      Line : Positive := 1;
      Col  : Positive := 1;
   end record;

   package Enumerator_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Enumerator_T);

   type Annotation_Member_Kind_T is (AM_Member, AM_Enum, AM_Const, AM_Typedef);
   --  The four alternatives of rule (221).

   type Annotation_Member_T is record
      Kind : Annotation_Member_Kind_T := AM_Member;
      Annotations : Annotation_Appl_Vectors.Vector;
      Line : Positive := 1;
      Col  : Positive := 1;

      --  AM_Member (rule 222):
      Member_Type    : Type_Spec_Ref := null;   --  rule (223)
      Member_Name    : Unbounded_String;
      Has_Default    : Boolean := False;        --  rule (222): [default]
      Default_Value  : Expression_Ref := null;
      --  AM_Enum / AM_Const / AM_Typedef (rule 221): the sub-definition.
      Enum : Definition_Ref := null;
      Const : Definition_Ref := null;
      Typedef : Definition_Ref := null;
   end record;

   package Annotation_Member_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Annotation_Member_T);

   type Definition_T is record
      Kind : Definition_Kind_T := D_Const;
      Annotations : Annotation_Appl_Vectors.Vector;
      --  Annotations applied to this definition (rule 225).  Kept in
      --  source order; the concrete back-ends interpret them.

      Name : Unbounded_String;
      --  The definition's own identifier: module name (rule 3), constant
      --  name (rule 5), typedef's first declarator when the grammar's
      --  inline-construct form is used, struct/union/enum/annotation name
      --  (rules 46/50/57/220), native name (rule 62).  Forward
      --  declarations always carry a name.

      Line : Positive := 1;
      Col  : Positive := 1;

      --  D_Module (rule 3): the <definition>+ of the module body.
      Module_Body : Definition_Vectors.Vector;
      --  D_Const (rules 5-6): the constant's type and value expression.
      Const_Type : Type_Spec_Ref := null;
      Const_Value : Expression_Ref := null;
      --  D_Typedef (rules 63-66).
      Typedef_Type : Type_Spec_Ref := null;
      Typedef_Declarators : Declarator_Vectors.Vector;
      Inlined : Definition_Ref := null;
      --  Non-null when the typedef declared a constructed type
      --  inline (rule 64: <type_declarator> may be a
      --  <constr_type_dcl>, e.g. "typedef struct Foo {...} Bar;"):
      --  the D_Struct/D_Union/D_Enum node, with Typedef_Type set to
      --  a scoped-name reference to its name.
      --  D_Struct (rule 46): <member>+.
      Members : Member_Vectors.Vector;
      --  D_Union (rules 50-52).
      Switch_Type : Type_Spec_Ref := null;
      Cases : Union_Case_Vectors.Vector;
      --  D_Enum (rule 57): the <enumerator>s.
      Enumerators : Enumerator_Vectors.Vector;
      --  D_Annotation (rule 219): the annotation body (rule 221).
      Annotation_Body : Annotation_Member_Vectors.Vector;
      --  D_Value_Type (rule 79): the <value_member>+ of the state
      --  block, plus the optional base valuetype of rule (80).
      Value_Members : Member_Vectors.Vector;
      Base_Type : Scoped_Name_T;
      Has_Base_Type : Boolean := False;
      --  D_Interface (rule 86): operations are parsed and discarded;
      --  only the name is kept (the back-ends do not generate for
      --  interfaces).
   end record;

   ---------------------------------------------------------------------------
   --  Convenience for tests and tooling
   ---------------------------------------------------------------------------

   function Image (D : Definition_T; Indent : Natural := 0) return String;
   --  Multi-line, indented dump of one definition (s-expression style),
   --  used by the tool's "-ast" mode and by parser tests.

end IDL2Lang.Syntax;