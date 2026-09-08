------------------------------------------------------------------------------
--  IDL2Lang.Tests.Parser -- body
------------------------------------------------------------------------------

with AUnit.Assertions;
use AUnit.Assertions;

with Ada.Strings.Unbounded;
with IDL2Lang.Parsers;
with IDL2Lang.Syntax;

package body IDL2Lang.Tests.Parser is

   use Ada.Strings.Unbounded;
   package P renames IDL2Lang.Parsers;
   package S renames IDL2Lang.Syntax;

   use all type S.Definition_Kind_T;
   use all type S.Definition_Ref;

   procedure Assert_Image
     (Tree : P.Definition_Vectors.Vector; Expected : String; Msg : String);
   --  Parse Expected-IDLE... convenience: compare the tree's Image with
   --  Expected, trimming surrounding white space on both sides.

   procedure Assert_Image
     (Tree : P.Definition_Vectors.Vector; Expected : String; Msg : String)
   is
      Actual : Unbounded_String;
   begin
      for I in Tree.First_Index .. Tree.Last_Index loop
         Actual := Actual & S.Image (Tree (I).all);
      end loop;
      declare
         A : constant String := To_String (Actual);
         function Trim (S : String) return String;
         function Trim (S : String) return String is
            First : Positive := S'First;
            Last  : Natural := S'Last;
         begin
            if S = "" then
               return "";
            end if;
            while First <= Last
              and then (S (First) = ' ' or else S (First) = ASCII.LF)
            loop
               First := First + 1;
            end loop;
            while Last >= First
              and then (S (Last) = ' ' or else S (Last) = ASCII.LF
                          or else S (Last) = ASCII.CR)
            loop
               Last := Last - 1;
            end loop;
            return S (First .. Last);
         end Trim;
      begin
         Assert (Trim (A) = Trim (Expected), Msg & ": got [[" & A & "]]");
      end;
   end Assert_Image;

   ---------------------------------------------------------------------------

   procedure Test_Module_Struct (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse
        ("module Hello {" & ASCII.LF
         & "  struct Time {" & ASCII.LF
         & "    unsigned long long seconds;" & ASCII.LF
         & "    unsigned long fraction;" & ASCII.LF
         & "  };" & ASCII.LF
         & "};" & ASCII.LF);
      Assert_Image (Tree,
        "(module Hello" & ASCII.LF
        & "  (struct Time" & ASCII.LF
        & "    (member unsigned long long" & ASCII.LF
        & "      seconds" & ASCII.LF
        & "    )" & ASCII.LF
        & "    (member unsigned long" & ASCII.LF
        & "      fraction" & ASCII.LF
        & "    )" & ASCII.LF
        & "  )" & ASCII.LF
        & ")",
        "module/struct");
   end Test_Module_Struct;

   ---------------------------------------------------------------------------

   procedure Test_Const_Expressions
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse ("const long X = 1 + 2 * 3;");
      Assert_Image (Tree,
        "(const long X" & ASCII.LF
        & "  (value (1 + (2 * 3)))" & ASCII.LF
        & ")",
        "precedence: * binds tighter than +");

      Tree := P.Parse ("const long Y = (1 + 2) * 3;");
      Assert_Image (Tree,
        "(const long Y" & ASCII.LF
        & "  (value ((1 + 2) * 3))" & ASCII.LF
        & ")",
        "parentheses override precedence");
   end Test_Const_Expressions;

   ---------------------------------------------------------------------------

   procedure Test_Enum_Typedef_Sequence
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse
        ("enum Color { red, green, blue };" & ASCII.LF
         & "typedef sequence<Color, 4> Palette;" & ASCII.LF
         & "typedef sequence<long> Longs;" & ASCII.LF
         & "typedef string<8> ShortString;" & ASCII.LF);
      Assert_Image (Tree,
        "(enum Color" & ASCII.LF
        & "  red" & ASCII.LF
        & "  green" & ASCII.LF
        & "  blue" & ASCII.LF
        & ")" & ASCII.LF
        & "(typedef sequence<Color, 4>" & ASCII.LF
        & "    (Palette)" & ASCII.LF
        & ")" & ASCII.LF
        & "(typedef sequence<long>" & ASCII.LF
        & "    (Longs)" & ASCII.LF
        & ")" & ASCII.LF
        & "(typedef string<8>" & ASCII.LF
        & "    (ShortString)" & ASCII.LF
        & ")",
        "enum/typedef/sequence/string");
   end Test_Enum_Typedef_Sequence;

   ---------------------------------------------------------------------------

   procedure Test_Union (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse
        ("union Value switch (long) {" & ASCII.LF
         & "  case 1: long l;" & ASCII.LF
         & "  case 2:" & ASCII.LF
         & "  case 3: double d;" & ASCII.LF
         & "  default: string s;" & ASCII.LF
         & "};" & ASCII.LF);
      Assert_Image (Tree,
        "(union Value (switch long)" & ASCII.LF
        & "  (case" & ASCII.LF
        & "    (label 1)" & ASCII.LF
        & "    long l" & ASCII.LF
        & "  )" & ASCII.LF
        & "  (case" & ASCII.LF
        & "    (label 2)" & ASCII.LF
        & "    (label 3)" & ASCII.LF
        & "    double d" & ASCII.LF
        & "  )" & ASCII.LF
        & "  (case" & ASCII.LF
        & "    default" & ASCII.LF
        & "    string s" & ASCII.LF
        & "  )" & ASCII.LF
        & ")",
        "union with multi-label cases and default");
   end Test_Union;

   ---------------------------------------------------------------------------

   procedure Test_Scoped_Names (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse ("typedef M::Inner::Type Type_Alias;");
      Assert_Image (Tree,
        "(typedef M::Inner::Type" & ASCII.LF
        & "    (Type_Alias)" & ASCII.LF
        & ")",
        "relative scoped name");

      Tree := P.Parse ("typedef ::M::Inner::Type Type_Alias;");
      Assert_Image (Tree,
        "(typedef ::M::Inner::Type" & ASCII.LF
        & "    (Type_Alias)" & ASCII.LF
        & ")",
        "absolute scoped name");
   end Test_Scoped_Names;

   ---------------------------------------------------------------------------

   procedure Test_Arrays (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse ("struct Grid { long cells[4][8]; };");
      Assert_Image (Tree,
        "(struct Grid" & ASCII.LF
        & "  (member long" & ASCII.LF
        & "    cells [dim] [dim]" & ASCII.LF
        & "  )" & ASCII.LF
        & ")",
        "multi-dimensional array declarator");
   end Test_Arrays;

   ---------------------------------------------------------------------------

   procedure Test_Annotations (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      --  Annotations on members and definitions (rule 225); the Image
      --  of an annotated struct is the same as unannotated (the tool
      --  prints them), so just check Parse accepts and the shape holds.
      Tree := P.Parse
        ("struct Keyed {" & ASCII.LF
         & "  @key long id;" & ASCII.LF
         & "  @position(2) long other;" & ASCII.LF
         & "  @topic(discovery = TRUE) long third;" & ASCII.LF
         & "};" & ASCII.LF);
      Assert (Tree.Last_Index = 1, "one definition");
      Assert (Tree.First_Element.Kind = S.D_Struct, "struct node");
      Assert (Tree.First_Element.Members.Last_Index = 3, "three members");
      Assert
        (Tree.First_Element.Members (1).Annotations.Last_Index = 1,
         "first member annotated");
      declare
         Key_Params : constant Natural :=
           Tree.First_Element.Members (1).Annotations (1).Params.Last_Index;
         Pos_Params : constant Natural :=
           Tree.First_Element.Members (2).Annotations (1).Params.Last_Index;
         Topic_Params : constant Natural :=
           Tree.First_Element.Members (3).Annotations (1).Params.Last_Index;
      begin
         Assert (Key_Params = 0,
                 "@key is a bare application (rule 225 short form)");
         Assert (Pos_Params = 1,
                 "@position(2) carries one value (rule 226)");
         Assert
           (not Tree.First_Element.Members (2).Annotations (1).Params (1)
              .Named,
            "@position(2) is positional (rule 226 first alternative)");
         Assert (Topic_Params = 1, "@topic carries one value");
         Assert
           (Tree.First_Element.Members (3).Annotations (1).Params (1).Named,
            "@topic(discovery = TRUE) is named (rule 227)");
      end;
   end Test_Annotations;

   ---------------------------------------------------------------------------

   procedure Test_Annotation_Dcl
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      Tree := P.Parse
        ("@annotation Position { long value default 0; };" & ASCII.LF);
      Assert_Image (Tree, "(annotation Position)", "annotation declared");
      Assert (Tree.First_Element.Annotation_Body.Last_Index = 1,
              "one annotation member");
      Assert (Tree.First_Element.Annotation_Body (1).Has_Default,
              "member carries a default (rule 222)");
   end Test_Annotation_Dcl;

   ---------------------------------------------------------------------------

   procedure Test_Typedef_Inline
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Tree : P.Definition_Vectors.Vector;
   begin
      --  Rule (64): the inline <constr_type_dcl> form of typedef.
      Tree := P.Parse ("typedef struct Foo { long x; } Bar;");
      Assert (Tree.Last_Index = 1, "one definition");
      Assert (Tree.First_Element.Kind = S.D_Typedef, "typedef node");
      Assert (Tree.First_Element.Inlined /= null, "inlined struct present");
      Assert (To_String (Tree.First_Element.Name) = "Bar",
              "typedef name is the declarator");
   end Test_Typedef_Inline;

   ---------------------------------------------------------------------------

   procedure Test_Syntax_Errors
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);

      procedure Expect_Error (Text : String; Msg : String);
      procedure Expect_Error (Text : String; Msg : String) is
      begin
         begin
            declare
               Tree : P.Definition_Vectors.Vector := P.Parse (Text);
               pragma Unreferenced (Tree);
            begin
               Assert (False, Msg & ": no error raised");
            end;
         exception
            when P.Syntax_Error =>
               Assert (True, "expected error raised");
         end;
      end Expect_Error;

   begin
      Expect_Error ("struct { long x; };", "missing struct name");
      Expect_Error ("module M { const long X = 1 }", "missing ';'");
      Expect_Error ("union U switch (long) { long l; };",
                    "case label required in union");
      Expect_Error ("const long X = 1 +;", "dangling operator");
      Expect_Error ("typedef sequence<; Q;", "sequence element expected");
   end Test_Syntax_Errors;

   ---------------------------------------------------------------------------

   overriding procedure Register_Tests (T : in out Parser_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Module_Struct'Access, "module/struct");
      Register_Routine (T, Test_Const_Expressions'Access, "const expressions");
      Register_Routine (T, Test_Enum_Typedef_Sequence'Access,
                        "enum/typedef/sequence");
      Register_Routine (T, Test_Union'Access, "union");
      Register_Routine (T, Test_Scoped_Names'Access, "scoped names");
      Register_Routine (T, Test_Arrays'Access, "arrays");
      Register_Routine (T, Test_Annotations'Access, "annotations applied");
      Register_Routine (T, Test_Annotation_Dcl'Access, "annotation declared");
      Register_Routine (T, Test_Typedef_Inline'Access, "typedef inline");
      Register_Routine (T, Test_Syntax_Errors'Access, "syntax errors");
   end Register_Tests;

   overriding function Name (T : Parser_Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return new String'("IDL2Lang.Parser");
   end Name;

end IDL2Lang.Tests.Parser;