------------------------------------------------------------------------------
--  IDL2Lang.Tests.Lexer -- body
--
--  Each test lexes a small IDL fragment and asserts on the token
--  sequence; error cases assert that Lexical_Error is raised with a
--  "line L, column C:" prefix.
--
--  The ' and " characters are written via Character'Val (39 / 34) to
--  keep the source readable.
------------------------------------------------------------------------------

with Ada.Exceptions;
with Ada.Strings.Unbounded;
with AUnit.Assertions;
use AUnit.Assertions;
with IDL2Lang.Lexers;
with IDL2Lang.Tokens;

package body IDL2Lang.Tests.Lexer is

   package T renames IDL2Lang.Tokens;
   use Ada.Strings.Unbounded;
   use all type T.Token_Kind_T;

   --  Scan a source fragment and return its non-Eof tokens.
   function Scan (Text : String) return IDL2Lang.Lexers.Token_Vectors.Vector
   is
      Result : IDL2Lang.Lexers.Token_Vectors.Vector :=
        IDL2Lang.Lexers.Lex (Text);
   begin
      IDL2Lang.Lexers.Token_Vectors.Delete_Last (Result);
      return Result;
   end Scan;

   function Kind_List (V : IDL2Lang.Lexers.Token_Vectors.Vector)
     return String is
   begin
      if V.Is_Empty then
         return "";
      end if;
      declare
         Result : Unbounded_String :=
           To_Unbounded_String (T.Image (V.First_Element.Kind));
      begin
         for I in V.First_Index + 1 .. V.Last_Index loop
            Result := Result & " " & T.Image (V.Element (I).Kind);
         end loop;
         return To_String (Result);
      end;
   end Kind_List;

   ---------------------------------------------------------------------

   --  7.2.3 / 7.2.4: keywords are keywords; other identifier-shaped
   --  lexemes are identifiers.  TRUE/FALSE are keywords of Table 7-6;
   --  TRUE_/false_ are not (they are identifiers).
   procedure Test_Keywords_And_Identifiers
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("module Color module1 TRUE FALSE true_ false_");
   begin
      Assert (Kind_List (V)
                = "keyword identifier identifier keyword keyword identifier"
                    & " identifier",
              "kind sequence: " & Kind_List (V));
      Assert (To_String (V.Element (1).Text) = "module", "module lexeme");
      Assert (To_String (V.Element (2).Text) = "Color", "Color lexeme");
      Assert (To_String (V.Element (6).Text) = "true_", "true_ lexeme");
   end Test_Keywords_And_Identifiers;

   --  7.2.3.2: prepending '_' to an identifier "only turns off keyword
   --  checking" -- _abstract is the identifier abstract.
   procedure Test_Escaped_Identifier
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("_abstract abstract");
   begin
      Assert (Kind_List (V) = "identifier keyword", "kinds");
      Assert (To_String (V.Element (1).Text) = "_abstract", "escaped");
      Assert (To_String (V.Element (2).Text) = "abstract", "keyword");
   end Test_Escaped_Identifier;

   --  7.2.4: "Boolean and BOOLEAN are illegal identifiers".
   procedure Test_Case_Collision
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Actual : Unbounded_String;
      Raised : Boolean := False;
   begin
      begin
         declare
            V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
              Scan ("Boolean");
         begin
            pragma Unreferenced (V);
            null;
         end;
      exception
         when IDL2Lang.Lexical_Error =>
            Raised := True;
      end;
      Assert (Raised, "Boolean must be rejected");
      --  Message text: keep the check loose (line/column prefix only).
      begin
         declare
            V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
              Scan ("BOOLEAN");
         begin
            pragma Unreferenced (V);
            null;
         end;
      exception
         when Err : IDL2Lang.Lexical_Error =>
            Actual := To_Unbounded_String
              (Ada.Exceptions.Exception_Message (Err));
            Raised := True;
      end;
      Assert (Raised, "BOOLEAN must be rejected");
      Assert (Length (Actual) >= 5
                and then Slice (Actual, 1, 5) = "line ",
              "error carries line/column prefix");
   end Test_Case_Collision;

   --  7.2.6.1: "the number twelve can be written 12, 014, or 0XC".
   procedure Test_Integer_Literals
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("12 014 0XC");
   begin
      Assert (Kind_List (V)
                = "integer-literal integer-literal integer-literal",
              "kinds");
      Assert (To_String (V.Element (1).Text) = "12", "decimal");
      Assert (To_String (V.Element (2).Text) = "014", "octal");
      Assert (To_String (V.Element (3).Text) = "0XC", "hex");
   end Test_Integer_Literals;

   --  7.2.6.1: "The digits 8 and 9 are not octal digits and thus are
   --  not allowed in an octal integer literal."
   procedure Test_Octal_Error (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Raised : Boolean := False;
   begin
      begin
         declare
            V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
              Scan ("018");
         begin
            pragma Unreferenced (V);
            null;
         end;
      exception
         when IDL2Lang.Lexical_Error =>
            Raised := True;
      end;
      Assert (Raised, "018 must be rejected (8 is not an octal digit)");
   end Test_Octal_Error;

   --  7.2.6.4 / 7.2.6.5: floating point (either the integer or the
   --  fraction part may be missing; exponent via e/E) and fixed point
   --  (the d/D suffix; the '.' may be missing).
   procedure Test_Float_And_Fixed_Literals
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("3.14 3E6 3.14e-9 .5 3. .5d 3000.00D");
   begin
      Assert (Kind_List (V)
                = "floating-point-literal floating-point-literal"
                    & " floating-point-literal floating-point-literal"
                    & " floating-point-literal fixed-point-literal"
                    & " fixed-point-literal",
              "kind sequence: " & Kind_List (V));
      Assert (To_String (V.Element (1).Text) = "3.14", "3.14");
      Assert (To_String (V.Element (2).Text) = "3E6", "3E6");
      Assert (To_String (V.Element (3).Text) = "3.14e-9", "3.14e-9");
      Assert (To_String (V.Element (4).Text) = ".5", ".5");
      Assert (To_String (V.Element (5).Text) = "3.", "3.");
      Assert (To_String (V.Element (6).Text) = ".5d", ".5d");
      Assert (To_String (V.Element (7).Text) = "3000.00D", "3000.00D");
   end Test_Float_And_Fixed_Literals;

   --  7.2.6.2 / Table 7-9: escapes in character literals, including the
   --  required \' and \\; octal \ooo and hex \xhh forms.
   procedure Test_Character_Literals
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("'X' '\n' '\x41' '\101' L'W' '\?'");
   begin
      Assert (Kind_List (V)
                = "character-literal character-literal character-literal"
                    & " character-literal character-literal"
                    & " character-literal",
              "kind sequence: " & Kind_List (V));
      Assert (To_String (V.Element (1).Text) = "'X'", "'X'");
      Assert (To_String (V.Element (2).Text) = "'\n'", "'\n'");
      Assert (To_String (V.Element (3).Text) = "'\x41'", "'\x41'");
      Assert (To_String (V.Element (4).Text) = "'\101'", "'\101'");
      Assert (To_String (V.Element (5).Text) = "L'W'", "L'W'");
      Assert (To_String (V.Element (6).Text) = "'\?'", "'\?'");
   end Test_Character_Literals;

   --  7.2.6.3: adjacent string literals are concatenated; "Characters
   --  in concatenated strings are kept distinct" (the example "\xA" "B"
   --  keeps two characters).  The lexer keeps the raw source text of
   --  all pieces; value handling belongs to the parser.  The quote and
   --  backslash are spliced in via Character'Val so no escaping is
   --  needed in the Ada source.
   procedure Test_String_Concatenation
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      D : constant Character := Character'Val (34);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("const string S = " & D & "Hello" & D & " "
                & D & "\xA" & D & " " & D & "B" & D & ";");
   begin
      Assert (Kind_List (V)
                = "keyword keyword identifier = string-literal ;",
              "kind sequence: " & Kind_List (V));
      Assert (To_String (V.Element (5).Text)
                = D & "Hello" & D & D & "\xA" & D & D & "B" & D,
              "raw text of all pieces");
   end Test_String_Concatenation;

   --  7.2.2: // to end of line and /* ... */ (which do not nest, but
   --  /* comments terminate on the first */).
   procedure Test_Comments (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("a /* still a */ b // trailing" & ASCII.LF & " c");
   begin
      Assert (Kind_List (V) = "identifier identifier identifier",
              "kinds");
      Assert (To_String (V.Element (1).Text) = "a", "a");
      Assert (To_String (V.Element (2).Text) = "b", "b");
      Assert (To_String (V.Element (3).Text) = "c", "c after comment");
   end Test_Comments;

   --  7.2.5 / Tables 7-7 and 7-8 punctuation with the longest-match
   --  rule of 7.2.1 for '::', '<<', '>>', '&&', '||'.
   procedure Test_Punctuation (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan (": ; , = + - ( ) < > [ ] | ^ & * / % ~ @ ! :: << >> && ||");
   begin
      Assert
        (Kind_List (V)
           = ": ; , = + - ( ) < > [ ] | ^ & * / % ~ @ ! :: << >> && ||",
         "kind sequence: " & Kind_List (V));
   end Test_Punctuation;

   --  7.3: a directive line starts with '#' (optionally after white
   --  space); backslash-newline continues the directive.
   procedure Test_Directive (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("#include <a.idl>" & ASCII.LF & "module M {" & ASCII.LF
                & "#define X " & '"' & "a" & '"' & "b" & '"'
                & ASCII.LF & "};");
   begin
      Assert (Kind_List (V) = "directive keyword identifier { directive } ;",
              "kind sequence: " & Kind_List (V));
      Assert (To_String (V.Element (1).Text) = "#include <a.idl>",
              "directive raw text");
   end Test_Directive;

   --  Position bookkeeping: each token carries the 1-based line/column
   --  of its first character.
   procedure Test_Positions (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      V : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
        Scan ("module" & ASCII.LF & "  M {" & ASCII.LF & "}  // done");
   begin
      Assert (V.Element (1).Line = 1 and then V.Element (1).Col = 1,
              "module at 1:1");
      Assert (V.Element (2).Line = 2 and then V.Element (2).Col = 3,
              "M at 2:3");
      Assert (V.Element (2).Kind = T.K_Identifier, "M identifier");
      Assert (V.Element (4).Line = 3 and then V.Element (4).Col = 1,
              "} at 3:1");
   end Test_Positions;

   overriding procedure Register_Tests (T : in out Lexer_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Keywords_And_Identifiers'Access,
                        "keywords and identifiers");
      Register_Routine (T, Test_Escaped_Identifier'Access,
                        "escaped identifiers");
      Register_Routine (T, Test_Case_Collision'Access,
                        "keyword case collisions");
      Register_Routine (T, Test_Integer_Literals'Access,
                        "integer literals");
      Register_Routine (T, Test_Octal_Error'Access,
                        "octal digit check");
      Register_Routine (T, Test_Float_And_Fixed_Literals'Access,
                        "float and fixed literals");
      Register_Routine (T, Test_Character_Literals'Access,
                        "character literals");
      Register_Routine (T, Test_String_Concatenation'Access,
                        "string concatenation");
      Register_Routine (T, Test_Comments'Access,
                        "comments");
      Register_Routine (T, Test_Punctuation'Access,
                        "punctuation");
      Register_Routine (T, Test_Directive'Access,
                        "directives");
      Register_Routine (T, Test_Positions'Access,
                        "token positions");
   end Register_Tests;

   overriding function Name (T : Lexer_Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return new String'("IDL2Lang.Lexer");
   end Name;

end IDL2Lang.Tests.Lexer;