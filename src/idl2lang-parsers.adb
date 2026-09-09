------------------------------------------------------------------------------
--  IDL2Lang.Parsers -- body
--
--  One procedure per grammar rule (or rule group); the rule numbers in
--  the comments are the normative rules of 7.4.1.3 (Core Data Types)
--  and 7.4.15.3 (Annotations).  Tokens are consumed from the vector
--  built by IDL2Lang.Lexers; the cursor always designates the next
--  unread token.
--
--  Error style: a failed expectation raises Syntax_Error with the line
--  and column of the offending token, what was expected, and what was
--  found.
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;
with IDL2Lang.Lexers;
with IDL2Lang.Tokens;

package body IDL2Lang.Parsers is

   use Ada.Strings.Unbounded;
   use type IDL2Lang.Tokens.Token_Kind_T;

   package T renames IDL2Lang.Tokens;
   package S renames IDL2Lang.Syntax;

   function Img (N : Natural) return String renames Natural'Image;
   --  Local diagnostic helper (Positive'Image leaves a leading blank;
   --  callers trim it or accept the space).

   ---------------------------------------------------------------------------
   --  Diagnostics
   ---------------------------------------------------------------------------

   procedure Syntax_Fail (Line, Col : Positive; Msg : String) is
   begin
      raise Syntax_Error
        with "line" & Img (Line) & ", column" & Img (Col) & ": " & Msg;
   end Syntax_Fail;

   ---------------------------------------------------------------------------
   --  Token cursor
   ---------------------------------------------------------------------------

   type Parser_State is record
      Toks   : Lexers.Token_Vectors.Vector;
      Cursor : Natural := 0;   --  0-based index into Toks
   end record;

   function Peek (St : Parser_State) return T.Token_T is
     (St.Toks (St.Cursor));
   --  The next unread token; the token vector always ends with K_Eof,
   --  so the cursor is never past the end when this is called.

   function Peek_Kind (St : Parser_State) return T.Token_Kind_T is
     (Peek (St).Kind);

   function At_Eof (St : Parser_State) return Boolean is
     (Peek_Kind (St) = T.K_Eof);

   procedure Advance (St : in out Parser_State) is
   begin
      if not At_Eof (St) then
         St.Cursor := St.Cursor + 1;
      end if;
   end Advance;

   procedure Expect
     (St : in out Parser_State; Kind : T.Token_Kind_T; What : String)
   is
   begin
      if Peek_Kind (St) /= Kind then
         Syntax_Fail
          (Peek (St).Line, Peek (St).Col,
           "expected " & What & ", found """ & To_String (Peek (St).Text)
             & """ (" & T.Image (Peek_Kind (St)) & ")");
      end if;
      Advance (St);
   end Expect;

   function Expect_Identifier (St : in out Parser_State) return String is
      Result : constant String := To_String (Peek (St).Text);
   begin
      if Peek_Kind (St) /= T.K_Identifier then
         Syntax_Fail
          (Peek (St).Line, Peek (St).Col,
           "expected an identifier, found """ & To_String (Peek (St).Text)
             & """ (" & T.Image (Peek_Kind (St)) & ")");
      end if;
      Advance (St);
      return Result;
   end Expect_Identifier;

   ---------------------------------------------------------------------------
   --  Forward declarations of the mutually recursive grammar procedures
   --  (rule numbers refer to 7.4.1.3 / 7.4.15.3)
   ---------------------------------------------------------------------------

   procedure Parse_Scoped_Name
     (St : in out Parser_State; Result : out S.Scoped_Name_T);
   --  Rule (4).

   procedure Parse_Expression
     (St : in out Parser_State; Result : out S.Expression_T);
   --  Rule (7): <const_expr> ::= <or_expr>.

   procedure Parse_Or_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_Xor_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_And_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_Shift_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_Add_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_Mult_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   procedure Parse_Unary_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   --  Rules (8)-(14): the constant-expression precedence ladder.

   procedure Parse_Primary_Expr
     (St : in out Parser_State; Result : out S.Expression_T);
   --  Rule (16).

   function Parse_Expr_Ref (St : in out Parser_State) return S.Expression_Ref;
   --  Allocates a node and fills it with Parse_Expression.

   procedure Parse_Type_Spec
     (St : in out Parser_State; Result : out S.Type_Spec_T);
   --  Rule (21)/(22)/(23)/(38): simple and template type specs.

   procedure Parse_Declarators
     (St : in out Parser_State; Result : out S.Declarator_Vectors.Vector);
   --  Rule (67): <declarator> { "," <declarator> }*.

   procedure Parse_Annotation_Appl
     (St : in out Parser_State; Result : out S.Annotation_Appl_T);
   --  Rule (225); the leading '@' is assumed consumed.

   procedure Parse_Annotation_Appls
     (St : in out Parser_State; Result : out S.Annotation_Appl_Vectors.Vector);
   --  Zero or more rule-(225) applications.

   procedure Parse_Definition
     (St : in out Parser_State; Result : out S.Definition_Ref);
   --  Rule (2): one <definition>.

   procedure Parse_Typedef_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref);
   --  Rule (63)/(64); defined after Parse_Annotation_Dcl, which uses it.

   procedure Parse_Annotation_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref);
   --  Rule (219); used by Parse_Definition.

   ---------------------------------------------------------------------------
   --  Scoped names -- rule (4)
   ---------------------------------------------------------------------------

   procedure Parse_Scoped_Name
     (St : in out Parser_State; Result : out S.Scoped_Name_T)
   is
   begin
      Result := (Absolute => False, Parts => <>);
      if Peek_Kind (St) = T.K_Scope then
         --  "::" <identifier>: the name is absolute (rule 4).
         Result.Absolute := True;
         Advance (St);
      end if;

      if Peek_Kind (St) /= T.K_Identifier then
         Syntax_Fail
          (Peek (St).Line, Peek (St).Col,
           "expected an identifier in scoped name, found """
             & To_String (Peek (St).Text) & """");
      end if;

      Result.Parts.Append (To_Unbounded_String (Expect_Identifier (St)));
      while Peek_Kind (St) = T.K_Scope loop
         Advance (St);   --  the "::"
         Result.Parts.Append (To_Unbounded_String (Expect_Identifier (St)));
      end loop;
   end Parse_Scoped_Name;

   ---------------------------------------------------------------------------
   --  Constant expressions -- rules (7)-(18)
   --
   --  The spec's rules map onto the precedence ladder: or(8) -> xor(9)
   --  -> and(10) -> shift(11) -> add(12) -> mult(13) -> unary(14-15) ->
   --  primary(16).  Each level parses one level down and folds while
   --  the next token is one of its operators (left associative).  The
   --  operand is copied into Left_Expr before the right operand is
   --  parsed into the same Result variable.
   ---------------------------------------------------------------------------

   procedure Parse_Or_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_Xor_Expr (St, Result);
      while Peek_Kind (St) = T.K_Bar loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_Xor_Expr (St, Result);
            Result := (Kind => S.E_Or, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_Or_Expr;

   procedure Parse_Xor_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_And_Expr (St, Result);
      while Peek_Kind (St) = T.K_Caret loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_And_Expr (St, Result);
            Result := (Kind => S.E_Xor, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_Xor_Expr;

   procedure Parse_And_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_Shift_Expr (St, Result);
      while Peek_Kind (St) = T.K_Ampersand loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_Shift_Expr (St, Result);
            Result := (Kind => S.E_And, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_And_Expr;

   procedure Parse_Shift_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_Add_Expr (St, Result);
      while Peek_Kind (St) = T.K_Shift_Left
        or else Peek_Kind (St) = T.K_Shift_Right
      loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Level : constant S.Expr_Kind_T :=
              (if Peek_Kind (St) = T.K_Shift_Left
                 then S.E_Shift_Left else S.E_Shift_Right);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_Add_Expr (St, Result);
            Result := (Kind => Level, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_Shift_Expr;

   procedure Parse_Add_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_Mult_Expr (St, Result);
      while Peek_Kind (St) = T.K_Plus or else Peek_Kind (St) = T.K_Minus loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Level : constant S.Expr_Kind_T :=
              (if Peek_Kind (St) = T.K_Plus
                 then S.E_Add else S.E_Subtract);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_Mult_Expr (St, Result);
            Result := (Kind => Level, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_Add_Expr;

   procedure Parse_Mult_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      Parse_Unary_Expr (St, Result);
      while Peek_Kind (St) in T.K_Asterisk | T.K_Solidus | T.K_Percent loop
         declare
            Op_Tok : constant T.Token_T := Peek (St);
            Level : constant S.Expr_Kind_T :=
              (case Peek_Kind (St) is
                 when T.K_Asterisk => S.E_Multiply,
                 when T.K_Solidus  => S.E_Divide,
                 when others       => S.E_Remainder);
            Left_Expr : constant S.Expression_T := Result;
         begin
            Advance (St);
            Parse_Unary_Expr (St, Result);
            Result := (Kind => Level, Line => Op_Tok.Line,
                       Col => Op_Tok.Col,
                       Left => new S.Expression_T'(Left_Expr),
                       Right => new S.Expression_T'(Result), others => <>);
         end;
      end loop;
   end Parse_Mult_Expr;

   procedure Parse_Unary_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
      use all type S.Expr_Kind_T;
   begin
      case Peek_Kind (St) is
         when T.K_Plus | T.K_Minus | T.K_Tilde =>
            declare
               Op_Tok : constant T.Token_T := Peek (St);
               Level : constant S.Expr_Kind_T :=
                 (case Peek_Kind (St) is
                    when T.K_Plus   => S.E_Unary_Plus,
                    when T.K_Minus  => S.E_Unary_Minus,
                    when others     => S.E_Complement);
            begin
               Advance (St);
               Parse_Unary_Expr (St, Result);
               Result := (Kind => Level, Line => Op_Tok.Line,
                          Col => Op_Tok.Col,
                          Left => new S.Expression_T'(Result),
                          Right => null, others => <>);
            end;
         when others =>
            Parse_Primary_Expr (St, Result);
      end case;
   end Parse_Unary_Expr;

   procedure Parse_Primary_Expr
     (St : in out Parser_State; Result : out S.Expression_T)
   is
   begin
      case Peek_Kind (St) is
         when T.K_Scope | T.K_Identifier =>
            declare
               Pos_Line : constant Positive := Peek (St).Line;
               Pos_Col : constant Positive := Peek (St).Col;
               Name : S.Scoped_Name_T;
            begin
               Parse_Scoped_Name (St, Name);
               Result := (Kind => S.E_Scoped_Name, Line => Pos_Line,
                          Col => Pos_Col, Name => Name, others => <>);
            end;
         when T.K_Integer_Literal =>
            Result := (Kind => S.E_Integer,
                       Line => Peek (St).Line, Col => Peek (St).Col,
                       Literal_Text => Peek (St).Text, others => <>);
            Advance (St);
         when T.K_Floating_Point_Literal =>
            Result := (Kind => S.E_Floating_Point,
                       Line => Peek (St).Line, Col => Peek (St).Col,
                       Literal_Text => Peek (St).Text, others => <>);
            Advance (St);
         when T.K_Fixed_Point_Literal =>
            Result := (Kind => S.E_Fixed_Point,
                       Line => Peek (St).Line, Col => Peek (St).Col,
                       Literal_Text => Peek (St).Text, others => <>);
            Advance (St);
         when T.K_Character_Literal =>
            declare
               Raw : constant String := To_String (Peek (St).Text);
               Is_Wide : constant Boolean :=
                 Raw'Length >= 2 and then Raw (Raw'First) = 'L';
            begin
               Result := (Kind => (if Is_Wide then S.E_Wide_Character
                                  else S.E_Character),
                          Line => Peek (St).Line, Col => Peek (St).Col,
                          Literal_Text => Peek (St).Text, others => <>);
            end;
            Advance (St);
         when T.K_String_Literal =>
            declare
               Raw : constant String := To_String (Peek (St).Text);
               Is_Wide : constant Boolean :=
                 Raw'Length >= 2 and then Raw (Raw'First) = 'L';
            begin
               Result := (Kind => (if Is_Wide then S.E_Wide_String
                                  else S.E_String),
                          Line => Peek (St).Line, Col => Peek (St).Col,
                          Literal_Text => Peek (St).Text, others => <>);
            end;
            Advance (St);
         when T.K_Keyword =>
            --  Rule (18): the boolean literals TRUE and FALSE.  Any
            --  other keyword here is a syntax error.
            declare
               W : constant String := To_String (Peek (St).Text);
            begin
               if W = "TRUE" or else W = "FALSE" then
                  Result := (Kind => S.E_Boolean,
                             Line => Peek (St).Line, Col => Peek (St).Col,
                             Literal_Text => Peek (St).Text, others => <>);
                  Advance (St);
               else
                  Syntax_Fail
                   (Peek (St).Line, Peek (St).Col,
                    "expected a literal, scoped name, or '(' in constant "
                      & "expression, found keyword """ & W & """");
               end if;
            end;
         when T.K_Left_Paren =>
            Advance (St);   --  the '('
            Parse_Expression (St, Result);
            Expect (St, T.K_Right_Paren, "')'");
         when others =>
            Syntax_Fail
             (Peek (St).Line, Peek (St).Col,
              "expected a literal, scoped name, or '(' in constant "
                & "expression, found """ & To_String (Peek (St).Text)
                & """ (" & T.Image (Peek_Kind (St)) & ")");
      end case;
   end Parse_Primary_Expr;

   procedure Parse_Expression
     (St : in out Parser_State; Result : out S.Expression_T)
   is
   begin
      Parse_Or_Expr (St, Result);
   end Parse_Expression;

   function Parse_Expr_Ref (St : in out Parser_State) return S.Expression_Ref
   is
      Result : constant S.Expression_Ref := new S.Expression_T;
   begin
      Parse_Expression (St, Result.all);
      return Result;
   end Parse_Expr_Ref;

   ---------------------------------------------------------------------------
   --  Types -- rules (21)-(43)
   ---------------------------------------------------------------------------

   procedure Parse_Type_Spec
     (St : in out Parser_State; Result : out S.Type_Spec_T)
   is
   begin
      case Peek_Kind (St) is
         when T.K_Keyword =>
            declare
               W : constant String := To_String (Peek (St).Text);
               Pos_Line : constant Positive := Peek (St).Line;
               Pos_Col : constant Positive := Peek (St).Col;
            begin
               --  The base types of rules (23)-(37) and the template
               --  types of rules (38)-(42), matched by keyword text.
               if W = "short" then
                  Result := (Kind => S.T_Short, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "unsigned" then
                  Advance (St);
                  Expect (St, T.K_Keyword, "'short' or 'long' after "
                            & "'unsigned'");
                  declare
                     W2 : constant String :=
                       To_String (St.Toks (St.Cursor - 1).Text);
                  begin
                     if W2 = "short" then
                        Result := (Kind => S.T_Unsigned_Short,
                                   Line => Pos_Line, Col => Pos_Col, others => <>);
                     elsif W2 = "long" then
                        if Peek_Kind (St) = T.K_Keyword
                          and then To_String (Peek (St).Text) = "long"
                        then
                           Advance (St);
                           Result := (Kind => S.T_Unsigned_Long_Long,
                                      Line => Pos_Line, Col => Pos_Col, others => <>);
                        else
                           Result := (Kind => S.T_Unsigned_Long,
                                      Line => Pos_Line, Col => Pos_Col, others => <>);
                        end if;
                     else
                        Syntax_Fail
                         (Peek (St).Line, Peek (St).Col,
                          "expected 'short' or 'long' after 'unsigned', "
                            & "found """ & W2 & """");
                     end if;
                  end;
               elsif W = "long" then
                  Advance (St);
                  if Peek_Kind (St) = T.K_Keyword
                    and then To_String (Peek (St).Text) = "long"
                  then
                     Advance (St);
                     Result := (Kind => S.T_Long_Long, Line => Pos_Line,
                                Col => Pos_Col, others => <>);
                  elsif Peek_Kind (St) = T.K_Keyword
                    and then To_String (Peek (St).Text) = "double"
                  then
                     Advance (St);
                     Result := (Kind => S.T_Long_Double, Line => Pos_Line,
                                Col => Pos_Col, others => <>);
                  else
                     Result := (Kind => S.T_Long, Line => Pos_Line,
                                Col => Pos_Col, others => <>);
                  end if;
               elsif W = "float" then
                  Result := (Kind => S.T_Float, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "double" then
                  Result := (Kind => S.T_Double, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "char" then
                  Result := (Kind => S.T_Char, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "wchar" then
                  Result := (Kind => S.T_Wide_Char, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "boolean" then
                  Result := (Kind => S.T_Boolean, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "octet" then
                  Result := (Kind => S.T_Octet, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "any" then
                  --  Rule (224): the "any" const type of annotation
                  --  members (7.4.15).
                  Result := (Kind => S.T_Any, Line => Pos_Line,
                             Col => Pos_Col, others => <>);
                  Advance (St);
               elsif W = "sequence" then
                  --  Rule (39): "sequence" "<" <type_spec>
                  --  [ "," <positive_int_const> ] ">".
                  Advance (St);
                  Expect (St, T.K_Less, "'<' after 'sequence'");
                  declare
                     Elem : constant S.Type_Spec_Ref := new S.Type_Spec_T;
                  begin
                     Parse_Type_Spec (St, Elem.all);
                     if Peek_Kind (St) = T.K_Comma then
                        Advance (St);
                        Result := (Kind => S.T_Sequence, Line => Pos_Line,
                                   Col => Pos_Col,
                                   Element_Type => Elem,
                                   Bound => Parse_Expr_Ref (St), others => <>);
                     else
                        Result := (Kind => S.T_Sequence, Line => Pos_Line,
                                   Col => Pos_Col,
                                   Element_Type => Elem,
                                   Bound => null, others => <>);
                     end if;
                  end;
                  Expect (St, T.K_Greater, "'>' closing 'sequence<'");
               elsif W = "string" then
                  Advance (St);
                  if Peek_Kind (St) = T.K_Less then
                     Advance (St);
                     Result := (Kind => S.T_String, Line => Pos_Line,
                                Col => Pos_Col,
                                String_Bound => Parse_Expr_Ref (St), others => <>);
                     Expect (St, T.K_Greater, "'>' closing 'string<'");
                  else
                     Result := (Kind => S.T_String, Line => Pos_Line,
                                Col => Pos_Col, String_Bound => null, others => <>);
                  end if;
               elsif W = "wstring" then
                  Advance (St);
                  if Peek_Kind (St) = T.K_Less then
                     Advance (St);
                     Result := (Kind => S.T_Wide_String, Line => Pos_Line,
                                Col => Pos_Col,
                                String_Bound => Parse_Expr_Ref (St), others => <>);
                     Expect (St, T.K_Greater, "'>' closing 'wstring<'");
                  else
                     Result := (Kind => S.T_Wide_String, Line => Pos_Line,
                                Col => Pos_Col, String_Bound => null, others => <>);
                  end if;
               elsif W = "fixed" then
                  --  Rule (42): "fixed" "<" digits "," scale ">".
                  Advance (St);
                  Expect (St, T.K_Less, "'<' after 'fixed'");
                  Result := (Kind => S.T_Fixed, Line => Pos_Line,
                             Col => Pos_Col,
                             Fixed_Digits => Parse_Expr_Ref (St), others => <>);
                  Expect (St, T.K_Comma, "',' after the fixed digits");
                  Result.Fixed_Scale := Parse_Expr_Ref (St);
                  Expect (St, T.K_Greater, "'>' closing 'fixed<'");
               else
                  Syntax_Fail
                   (Peek (St).Line, Peek (St).Col,
                    """" & W & """ is not a type keyword (rules 23-42)");
               end if;
            end;
         when T.K_Scope | T.K_Identifier =>
            declare
               Pos_Line : constant Positive := Peek (St).Line;
               Pos_Col : constant Positive := Peek (St).Col;
               Name : S.Scoped_Name_T;
            begin
               Parse_Scoped_Name (St, Name);
               Result := (Kind => S.T_Scoped_Name, Line => Pos_Line,
                          Col => Pos_Col, Type_Name => Name, others => <>);
            end;
         when others =>
            Syntax_Fail
             (Peek (St).Line, Peek (St).Col,
              "expected a type, found """ & To_String (Peek (St).Text)
                & """ (" & T.Image (Peek_Kind (St)) & ")");
      end case;
   end Parse_Type_Spec;

   function Parse_Type_Spec_Ref
     (St : in out Parser_State) return S.Type_Spec_Ref
   is
      Result : constant S.Type_Spec_Ref := new S.Type_Spec_T;
   begin
      Parse_Type_Spec (St, Result.all);
      return Result;
   end Parse_Type_Spec_Ref;

   ---------------------------------------------------------------------------
   --  Declarators -- rules (59), (62), (66), (67)
   ---------------------------------------------------------------------------

   procedure Parse_Declarator
     (St : in out Parser_State; Result : out S.Declarator_T)
   is
   begin
      Result := (Name => <>, Array_Dims => <>, others => <>);
      declare
         Name : constant String := Expect_Identifier (St);
      begin
         Result.Name := To_Unbounded_String (Name);
         Result.Line := St.Toks (St.Cursor - 1).Line;
         Result.Col := St.Toks (St.Cursor - 1).Col;
      end;
      while Peek_Kind (St) = T.K_Left_Bracket loop
         --  Rule (59)/(60): "[" <positive_int_const> "]".
         Advance (St);
         Result.Array_Dims.Append (Parse_Expr_Ref (St));
         Expect (St, T.K_Right_Bracket, "']'");
      end loop;
   end Parse_Declarator;

   procedure Parse_Declarators
     (St : in out Parser_State; Result : out S.Declarator_Vectors.Vector)
   is
      Dcl : S.Declarator_T;
   begin
      Result.Clear;
      Parse_Declarator (St, Dcl);
      Result.Append (Dcl);
      while Peek_Kind (St) = T.K_Comma loop
         Advance (St);
         Parse_Declarator (St, Dcl);
         Result.Append (Dcl);
      end loop;
   end Parse_Declarators;

   ---------------------------------------------------------------------------
   --  Annotations -- rules (225)-(227)
   ---------------------------------------------------------------------------

   procedure Parse_Annotation_Appl
     (St : in out Parser_State; Result : out S.Annotation_Appl_T)
   is
   begin
      Result := (Name => <>, Params => <>, others => <>);
      Parse_Scoped_Name (St, Result.Name);
      Result.Line := St.Toks (St.Cursor - 1).Line;
      Result.Col := St.Toks (St.Cursor - 1).Col;
      if Peek_Kind (St) = T.K_Left_Paren then
         Advance (St);
         --  Rule (226): a single positional <const_expr>, or one or
         --  more named <annotation_appl_param>s (rule 227).
         if Peek_Kind (St) = T.K_Identifier
           and then St.Cursor + 1 <= St.Toks.Last_Index
           and then St.Toks (St.Cursor + 1).Kind = T.K_Equal
         then
            loop
               declare
                  Param : S.Annotation_Param_T;
               begin
                  Param := (Named => True,
                            Member_Name => To_Unbounded_String
                                             (Expect_Identifier (St)),
                            Value => null);
                  Expect (St, T.K_Equal, "'=' after annotation member name");
                  Param.Value := Parse_Expr_Ref (St);
                  Result.Params.Append (Param);
               end;
               exit when Peek_Kind (St) /= T.K_Comma;
               Advance (St);
            end loop;
         else
            declare
               Param : S.Annotation_Param_T;
            begin
               Param := (Named => False, Member_Name => <>,
                         Value => Parse_Expr_Ref (St));
               Result.Params.Append (Param);
            end;
         end if;
         Expect (St, T.K_Right_Paren, "')' closing annotation parameters");
      end if;
   end Parse_Annotation_Appl;

   procedure Parse_Annotation_Appls
     (St : in out Parser_State; Result : out S.Annotation_Appl_Vectors.Vector)
   is
   begin
      Result.Clear;
      while Peek_Kind (St) = T.K_At loop
         --  "@annotation <identifier>" starts a rule-(218) annotation
         --  type definition, not a rule-(225) application; leave it to
         --  the definition parser.
         exit when St.Cursor + 1 <= St.Toks.Last_Index
           and then St.Toks (St.Cursor + 1).Kind = T.K_Identifier
           and then To_String (St.Toks (St.Cursor + 1).Text)
                      = "annotation";
         Advance (St);   --  the '@'
         declare
            Appl : S.Annotation_Appl_T;
         begin
            Parse_Annotation_Appl (St, Appl);
            Result.Append (Appl);
         end;
      end loop;
   end Parse_Annotation_Appls;

   ---------------------------------------------------------------------------
   --  Definitions -- rules (2), (3), (5), (20), (44)-(48), (49)-(56),
   --  (57)-(58), (61), (63), (218)-(220)
   ---------------------------------------------------------------------------

   procedure Parse_Members
     (St : in out Parser_State; Result : out S.Member_Vectors.Vector);
   --  Rule (46): <member>+ between the braces of a struct.

   procedure Parse_Switch_Body
     (St : in out Parser_State; Result : out S.Union_Case_Vectors.Vector);
   --  Rule (52): <case>+ between the braces of a union.

   procedure Parse_Constr_Type_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref);
   --  Rule (44): <struct_dcl> | <union_dcl> | <enum_dcl>.

   ---------------------------------------------------------------------------

   procedure Parse_Members
     (St : in out Parser_State; Result : out S.Member_Vectors.Vector)
   is
   begin
      Result.Clear;
      loop
         declare
            Member : S.Member_T;
            Annots : S.Annotation_Appl_Vectors.Vector;
            Typ : S.Type_Spec_Ref;
            M_Line : Positive;
            M_Col : Positive;
         begin
            Parse_Annotation_Appls (St, Annots);
            Typ := Parse_Type_Spec_Ref (St);
            M_Line := Peek (St).Line;
            M_Col := Peek (St).Col;
            Member := (Annotations => Annots,
                       Member_Type => Typ,
                       Declarators => <>,
                       Is_Pointer => False,
                       Line => M_Line, Col => M_Col);
            --  Pointer declarator (corpus: "long * member;",
            --  "fwd_struct* fwd_value;"): the '*' sits between the
            --  type and the declarator.  Not in the IDL 4.2 grammar
            --  proper; recorded as Member.Is_Pointer.
            if Peek_Kind (St) = T.K_Asterisk then
               Advance (St);
               Member.Is_Pointer := True;
            end if;
            Parse_Declarators (St, Member.Declarators);
            Expect (St, T.K_Semicolon, "';' after struct member");
            Result.Append (Member);
         end;
         exit when Peek_Kind (St) = T.K_Right_Brace;
      end loop;
   end Parse_Members;

   procedure Parse_Switch_Body
     (St : in out Parser_State; Result : out S.Union_Case_Vectors.Vector)
   is
   begin
      Result.Clear;
      loop
         declare
            Case_Node : S.Union_Case_T;
            Annots : S.Annotation_Appl_Vectors.Vector;
            Labels : S.Case_Label_Vectors.Vector;
            Elem_Typ : S.Type_Spec_Ref;
            E_Line : Positive;
            E_Col : Positive;
         begin
            --  Rule (53): <case_label>+ <element_spec> ";".
            Parse_Annotation_Appls (St, Annots);
            loop
               if Peek_Kind (St) = T.K_Keyword
                 and then To_String (Peek (St).Text) = "case"
               then
                  declare
                     L : S.Case_Label_T;
                  begin
                     Advance (St);
                     L := (Kind => S.L_Case,
                           Value => Parse_Expr_Ref (St),
                           others => <>);
                     L.Line := St.Toks (St.Cursor - 1).Line;
                     L.Col := St.Toks (St.Cursor - 1).Col;
                     Expect (St, T.K_Colon, "':' after case label");
                     Labels.Append (L);
                  end;
               elsif Peek_Kind (St) = T.K_Keyword
                 and then To_String (Peek (St).Text) = "default"
               then
                  declare
                     L : S.Case_Label_T;
                  begin
                     Advance (St);
                     L := (Kind => S.L_Default, Value => null,
                           others => <>);
                     L.Line := St.Toks (St.Cursor - 1).Line;
                     L.Col := St.Toks (St.Cursor - 1).Col;
                     Expect (St, T.K_Colon, "':' after 'default'");
                     Labels.Append (L);
                  end;
               else
                  exit;
               end if;
            end loop;
            if Labels.Is_Empty then
               Syntax_Fail
                (Peek (St).Line, Peek (St).Col,
                 "expected 'case' or 'default' in union switch body");
            end if;
            Elem_Typ := Parse_Type_Spec_Ref (St);
            E_Line := Peek (St).Line;
            E_Col := Peek (St).Col;
            Case_Node := (Annotations => Annots,
                          Labels => Labels,
                          Element_Type => Elem_Typ,
                          Element_Name => <>,
                          Line => E_Line, Col => E_Col);
            Parse_Declarator (St, Case_Node.Element_Name);
            Expect (St, T.K_Semicolon, "';' after union case element");
            Result.Append (Case_Node);
         end;
         exit when Peek_Kind (St) = T.K_Right_Brace;
      end loop;
   end Parse_Switch_Body;

   procedure Parse_Enum_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rule (57): "enum" <identifier> "{" <enumerator> {"," ...}* "}".
      Def : constant S.Definition_Ref := new S.Definition_T;
   begin
      Def.Kind := S.D_Enum;
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'enum' keyword
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      Expect (St, T.K_Left_Brace, "'{' after 'enum <name>'");
      loop
         declare
            E : S.Enumerator_T;
         begin
            E := (Name => To_Unbounded_String (Expect_Identifier (St)),
                  others => <>);
            E.Line := St.Toks (St.Cursor - 1).Line;
            E.Col := St.Toks (St.Cursor - 1).Col;
            Def.Enumerators.Append (E);
         end;
         exit when Peek_Kind (St) /= T.K_Comma;
         Advance (St);
      end loop;
      Expect (St, T.K_Right_Brace, "'}' closing 'enum'");
      Result := Def;
   end Parse_Enum_Dcl;

   procedure Parse_Value_Type_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rules (79)-(84) as used by the corpus: "valuetype" <identifier>
      --  [ ":" <scoped_name> ] "{" <value_member>+ "}".  Value members
      --  are struct-member shaped with a leading public/private
      --  visibility keyword (rule 82); the corpus also uses factory
      --  less state-only valuetypes.  Boxed values, truncatable
      --  inheritance, and the <value_element> forms are not needed by
      --  the corpus and are rejected by the normal error paths.
      Def : constant S.Definition_Ref := new S.Definition_T;
      Member : S.Member_T;
      Annots : S.Annotation_Appl_Vectors.Vector;
   begin
      Def.Kind := S.D_Value_Type;
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'valuetype' keyword
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      if Peek_Kind (St) = T.K_Colon then
         Advance (St);   --  the ':'
         Parse_Scoped_Name (St, Def.Base_Type);
         Def.Has_Base_Type := True;
      end if;
      Expect (St, T.K_Left_Brace, "'{' after 'valuetype <name>'");
      loop
         --  Rule (82): <visibility> <type_spec> <declarators> ";".
         Parse_Annotation_Appls (St, Annots);
         if Peek_Kind (St) = T.K_Keyword
           and then (To_String (Peek (St).Text) = "public"
                       or else To_String (Peek (St).Text) = "private")
         then
            Advance (St);   --  the visibility keyword
         end if;
         declare
            VT_Typ : S.Type_Spec_Ref;
            VT_Line : constant Positive := Peek (St).Line;
            VT_Col : constant Positive := Peek (St).Col;
         begin
            VT_Typ := Parse_Type_Spec_Ref (St);
            Member := (Annotations => Annots,
                       Member_Type => VT_Typ,
                       Declarators => <>,
                       Is_Pointer => False,
                       Line => VT_Line, Col => VT_Col);
         end;
         Parse_Declarators (St, Member.Declarators);
         Expect (St, T.K_Semicolon, "';' after valuetype state member");
         Def.Value_Members.Append (Member);
         exit when Peek_Kind (St) = T.K_Right_Brace;
      end loop;
      Expect (St, T.K_Right_Brace, "'}' closing 'valuetype'");
      Result := Def;
   end Parse_Value_Type_Dcl;

   procedure Parse_Interface_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rule (86): "interface" <identifier> [ ":" ... ] "{"
      --  <interface_body> "}".  The corpus (Global.idl,
      --  ALMAS_DataModel.idl) carries operations that no back-end
      --  consumes; we parse the braces and discard the body so the
      --  file parses, keeping only the interface's name.
      Def : constant S.Definition_Ref := new S.Definition_T;
      Depth : Natural := 0;
   begin
      Def.Kind := S.D_Interface;
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'interface' keyword
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      if Peek_Kind (St) = T.K_Colon then
         --  <interface_inheritance_spec>: skip the base list up to '{'.
         loop
            exit when Peek_Kind (St) = T.K_Left_Brace
              or else Peek_Kind (St) = T.K_Semicolon;
            Advance (St);
         end loop;
      end if;
      if Peek_Kind (St) = T.K_Left_Brace then
         Advance (St);
         Depth := 1;
         while Depth > 0 and then Peek_Kind (St) /= T.K_Eof loop
            if Peek_Kind (St) = T.K_Left_Brace then
               Depth := Depth + 1;
            elsif Peek_Kind (St) = T.K_Right_Brace then
               Depth := Depth - 1;
            end if;
            Advance (St);
         end loop;
         if Depth > 0 then
            Syntax_Fail
             (Peek (St).Line, Peek (St).Col,
              "unterminated interface body (missing '}')");
         end if;
      end if;
      Result := Def;
   end Parse_Interface_Dcl;

   procedure Parse_Struct_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rules (45)-(48): "struct" <identifier> [ "{" <member>+ "}" ];
      --  without the braces it is a forward declaration.
      Def : constant S.Definition_Ref := new S.Definition_T;
      Name_Tok_Line : Positive;
      Name_Tok_Col : Positive;
   begin
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'struct' keyword
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      Name_Tok_Line := St.Toks (St.Cursor - 1).Line;
      Name_Tok_Col := St.Toks (St.Cursor - 1).Col;
      if Peek_Kind (St) = T.K_Left_Brace then
         Advance (St);
         Def.Kind := S.D_Struct;
         Def.Line := Name_Tok_Line;
         Def.Col := Name_Tok_Col;
         Parse_Members (St, Def.Members);
         Expect (St, T.K_Right_Brace, "'}' closing 'struct'");
      elsif Peek_Kind (St) = T.K_Colon then
         --  Struct inheritance (rule 45's <inheritance_spec> in the
         --  corpus, e.g. "struct DerivedType : BaseType {"): the base
         --  struct's scoped name, then the member block.
         Advance (St);   --  the ':'
         Def.Kind := S.D_Struct;
         Def.Line := Name_Tok_Line;
         Def.Col := Name_Tok_Col;
         Parse_Scoped_Name (St, Def.Base_Type);
         Def.Has_Base_Type := True;
         Expect (St, T.K_Left_Brace, "'{' after 'struct <name> : <base>'");
         Parse_Members (St, Def.Members);
         Expect (St, T.K_Right_Brace, "'}' closing 'struct'");
      else
         Def.Kind := S.D_Struct_Forward;
         Def.Line := Name_Tok_Line;
         Def.Col := Name_Tok_Col;
      end if;
      Result := Def;
   end Parse_Struct_Dcl;

   procedure Parse_Union_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rules (49)-(56): "union" <identifier> "switch" "(" type ")"
      --  "{" <case>+ "}"; without the "switch (...)" it is a forward
      --  declaration.
      Def : constant S.Definition_Ref := new S.Definition_T;
      Name_Tok_Line : Positive;
      Name_Tok_Col : Positive;
   begin
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'union' keyword
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      Name_Tok_Line := St.Toks (St.Cursor - 1).Line;
      Name_Tok_Col := St.Toks (St.Cursor - 1).Col;
      if Peek_Kind (St) = T.K_Keyword
        and then To_String (Peek (St).Text) = "switch"
      then
         Advance (St);
         Def.Kind := S.D_Union;
         Def.Line := Name_Tok_Line;
         Def.Col := Name_Tok_Col;
         Expect (St, T.K_Left_Paren, "'(' after 'switch'");
         Def.Switch_Type := Parse_Type_Spec_Ref (St);
         Expect (St, T.K_Right_Paren, "')' closing 'switch ('");
         Expect (St, T.K_Left_Brace, "'{' after 'switch (...)'");
         Parse_Switch_Body (St, Def.Cases);
         Expect (St, T.K_Right_Brace, "'}' closing 'union'");
      else
         Def.Kind := S.D_Union_Forward;
         Def.Line := Name_Tok_Line;
         Def.Col := Name_Tok_Col;
      end if;
      Result := Def;
   end Parse_Union_Dcl;

   procedure Parse_Constr_Type_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      W : constant String := To_String (Peek (St).Text);
   begin
      if W = "struct" then
         Parse_Struct_Dcl (St, Result);
      elsif W = "union" then
         Parse_Union_Dcl (St, Result);
      elsif W = "enum" then
         Parse_Enum_Dcl (St, Result);
      else
         Syntax_Fail
          (Peek (St).Line, Peek (St).Col,
           "expected 'struct', 'union', or 'enum', found """ & W & """");
      end if;
   end Parse_Constr_Type_Dcl;

   procedure Parse_Annotation_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rules (219)-(222): "@annotation" <identifier> "{" body "}".
      Def : constant S.Definition_Ref := new S.Definition_T;
      Member : S.Annotation_Member_T;
   begin
      Def.Kind := S.D_Annotation;
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'annotation' keyword (after the '@')
      Def.Name := To_Unbounded_String (Expect_Identifier (St));
      Expect (St, T.K_Left_Brace, "'{' after '@annotation <name>'");
      loop
         Member := (Kind => S.AM_Member, Annotations => <>,
                    Line => Peek (St).Line, Col => Peek (St).Col,
                    Member_Type => null, Member_Name => <>,
                    Has_Default => False, Default_Value => null,
                    Enum => null, Const => null, Typedef => null);
         if Peek_Kind (St) = T.K_Keyword
           and then To_String (Peek (St).Text) = "enum"
         then
            declare
               Sub : S.Definition_Ref;
            begin
               Parse_Enum_Dcl (St, Sub);
               Expect (St, T.K_Semicolon, "';' after enum in annotation body");
               Member := (Kind => S.AM_Enum, Annotations => <>,
                          Line => Sub.Line, Col => Sub.Col,
                          Enum => Sub, others => <>);
            end;
         elsif Peek_Kind (St) = T.K_Keyword
           and then To_String (Peek (St).Text) = "const"
         then
            declare
               Sub : S.Definition_Ref;
            begin
               Advance (St);   --  the 'const'
               Sub := new S.Definition_T;
               Sub.Kind := S.D_Const;
               Sub.Line := St.Toks (St.Cursor - 1).Line;
               Sub.Col := St.Toks (St.Cursor - 1).Col;
               Sub.Const_Type := Parse_Type_Spec_Ref (St);
               Sub.Name := To_Unbounded_String (Expect_Identifier (St));
               Expect (St, T.K_Equal, "'=' in const definition");
               Sub.Const_Value := Parse_Expr_Ref (St);
               Expect (St, T.K_Semicolon, "';' after const in annotation body");
               Member := (Kind => S.AM_Const, Annotations => <>,
                          Line => Sub.Line, Col => Sub.Col,
                          Const => Sub, others => <>);
            end;
         elsif Peek_Kind (St) = T.K_Keyword
           and then To_String (Peek (St).Text) = "typedef"
         then
            declare
               Sub : S.Definition_Ref;
            begin
               Parse_Typedef_Dcl (St, Sub);
               Expect (St, T.K_Semicolon,
                       "';' after typedef in annotation body");
               Member := (Kind => S.AM_Typedef, Annotations => <>,
                          Line => Sub.Line, Col => Sub.Col,
                          Typedef => Sub, others => <>);
            end;
         else
            --  Rule (222): <annotation_member_type> <simple_declarator>
            --  [ "default" <const_expr> ] ";".
            declare
               Annots : S.Annotation_Appl_Vectors.Vector;
               A_Type : S.Type_Spec_Ref;
               A_Name : Unbounded_String;
               A_Line : Positive;
               A_Col : Positive;
            begin
               Parse_Annotation_Appls (St, Annots);
               A_Type := Parse_Type_Spec_Ref (St);
               A_Name := To_Unbounded_String (Expect_Identifier (St));
               A_Line := Peek (St).Line;
               A_Col := Peek (St).Col;
               Member := (Kind => S.AM_Member, Annotations => Annots,
                          Line => A_Line, Col => A_Col,
                          Member_Type => A_Type,
                          Member_Name => A_Name,
                          Has_Default => False, Default_Value => null,
                          Enum => null, Const => null, Typedef => null);
               if Peek_Kind (St) = T.K_Keyword
                 and then To_String (Peek (St).Text) = "default"
               then
                  Advance (St);
                  Member.Has_Default := True;
                  Member.Default_Value := Parse_Expr_Ref (St);
               end if;
               Expect (St, T.K_Semicolon, "';' after annotation member");
            end;
         end if;
         Def.Annotation_Body.Append (Member);
         exit when Peek_Kind (St) = T.K_Right_Brace;
      end loop;
      Expect (St, T.K_Right_Brace, "'}' closing '@annotation'");
      Result := Def;
   end Parse_Annotation_Dcl;

   procedure Parse_Typedef_Dcl
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rule (63)/(64): "typedef" { <simple_type_spec> |
      --  <template_type_spec> | <constr_type_dcl> } <any_declarators>.
      --  The inline <constr_type_dcl> form is recorded in Inlined; the
      --  typedef's type then refers to the inlined name.
      Def : constant S.Definition_Ref := new S.Definition_T;
      function Name_Vector_Of (N : Unbounded_String)
        return S.Name_Vectors.Vector;
      function Name_Vector_Of (N : Unbounded_String)
        return S.Name_Vectors.Vector
      is
         V : S.Name_Vectors.Vector;
      begin
         V.Append (N);
         return V;
      end Name_Vector_Of;
   begin
      Def.Kind := S.D_Typedef;
      Def.Line := Peek (St).Line;
      Def.Col := Peek (St).Col;
      Advance (St);   --  the 'typedef' keyword

      if Peek_Kind (St) = T.K_Keyword
        and then To_String (Peek (St).Text) in "struct" | "union" | "enum"
      then
         declare
            Inline : S.Definition_Ref;
         begin
            Parse_Constr_Type_Dcl (St, Inline);
            Def.Inlined := Inline;
            Def.Typedef_Type :=
              new S.Type_Spec_T'(Kind => S.T_Scoped_Name,
                                 Line => Inline.Line, Col => Inline.Col,
                                 others => <>);
            Def.Typedef_Type.Type_Name :=
              (Absolute => False, Parts => Name_Vector_Of (Inline.Name));
            Parse_Declarators (St, Def.Typedef_Declarators);
            if not Def.Typedef_Declarators.Is_Empty then
               Def.Name := Def.Typedef_Declarators.First_Element.Name;
            end if;
         end;
      else
         Def.Typedef_Type := Parse_Type_Spec_Ref (St);
         Parse_Declarators (St, Def.Typedef_Declarators);
         if not Def.Typedef_Declarators.Is_Empty then
            Def.Name := Def.Typedef_Declarators.First_Element.Name;
         end if;
      end if;
      Result := Def;
   end Parse_Typedef_Dcl;

   ---------------------------------------------------------------------------

   procedure Parse_Definition
     (St : in out Parser_State; Result : out S.Definition_Ref)
   is
      --  Rule (2): <module_dcl> ";" | <const_dcl> ";" | <type_dcl> ";".
      Annots : S.Annotation_Appl_Vectors.Vector;
      Def : S.Definition_Ref;
   begin
      Parse_Annotation_Appls (St, Annots);

      --  Rule (218): <annotation_dcl> is a definition too.  "annotation"
      --  itself is not a keyword of Table 7-6 (it only appears after
      --  the '@'), so the lookahead matches an identifier.
      if Peek_Kind (St) = T.K_At
        and then St.Cursor + 1 <= St.Toks.Last_Index
        and then St.Toks (St.Cursor + 1).Kind = T.K_Identifier
        and then To_String (St.Toks (St.Cursor + 1).Text) = "annotation"
      then
         Advance (St);   --  the '@'
         Parse_Annotation_Dcl (St, Def);
         Def.Annotations := Annots;
         Expect (St, T.K_Semicolon, "';' after annotation declaration");
         Result := Def;
         return;
      end if;

      if Peek_Kind (St) = T.K_Keyword then
         declare
            W : constant String := To_String (Peek (St).Text);
         begin
            if W = "module" then
               --  Rule (3): "module" <identifier> "{" <definition>+ "}".
               Def := new S.Definition_T;
               Def.Kind := S.D_Module;
               Def.Annotations := Annots;
               Def.Line := Peek (St).Line;
               Def.Col := Peek (St).Col;
               Advance (St);
               Def.Name := To_Unbounded_String (Expect_Identifier (St));
               Expect (St, T.K_Left_Brace, "'{' after 'module <name>'");
               loop
                  exit when Peek_Kind (St) = T.K_Right_Brace;
                  declare
                     Sub : S.Definition_Ref;
                  begin
                     Parse_Definition (St, Sub);
                     Def.Module_Body.Append (Sub);
                  end;
               end loop;
               Expect (St, T.K_Right_Brace, "'}' closing 'module'");
               --  Rule (2) requires the ';' after the module body.
               Expect (St, T.K_Semicolon, "';' after module");
               Result := Def;
               return;
            elsif W = "const" then
               Advance (St);
               Def := new S.Definition_T;
               Def.Kind := S.D_Const;
               Def.Annotations := Annots;
               Def.Line := St.Toks (St.Cursor - 1).Line;
               Def.Col := St.Toks (St.Cursor - 1).Col;
               Def.Const_Type := Parse_Type_Spec_Ref (St);
               Def.Name := To_Unbounded_String (Expect_Identifier (St));
               Expect (St, T.K_Equal, "'=' in const definition");
               Def.Const_Value := Parse_Expr_Ref (St);
               Expect (St, T.K_Semicolon, "';' after const definition");
               Result := Def;
               return;
            elsif W = "native" then
               --  Rule (61): "native" <simple_declarator>.
               Advance (St);
               Def := new S.Definition_T;
               Def.Kind := S.D_Native;
               Def.Annotations := Annots;
               Def.Line := St.Toks (St.Cursor - 1).Line;
               Def.Col := St.Toks (St.Cursor - 1).Col;
               Def.Name := To_Unbounded_String (Expect_Identifier (St));
               Expect (St, T.K_Semicolon, "';' after native declaration");
               Result := Def;
               return;
            elsif W = "typedef" then
               Parse_Typedef_Dcl (St, Def);
               Def.Annotations := Annots;
               Expect (St, T.K_Semicolon, "';' after typedef");
               Result := Def;
               return;
            elsif W = "struct" or else W = "union" or else W = "enum" then
               Parse_Constr_Type_Dcl (St, Def);
               Def.Annotations := Annots;
               Expect (St, T.K_Semicolon, "';' after type declaration");
               Result := Def;
               return;
            elsif W = "valuetype" then
               --  Rules (79)-(84): valuetype with state members.
               Parse_Value_Type_Dcl (St, Def);
               Def.Annotations := Annots;
               Expect (St, T.K_Semicolon, "';' after valuetype");
               Result := Def;
               return;
            elsif W = "interface" then
               --  Rule (86): interface; operations are discarded.
               Parse_Interface_Dcl (St, Def);
               Def.Annotations := Annots;
               Expect (St, T.K_Semicolon, "';' after interface");
               Result := Def;
               return;
            else
               null;
            end if;
         end;
      end if;

      Syntax_Fail
       (Peek (St).Line, Peek (St).Col,
        "expected 'module', 'const', 'typedef', 'struct', 'union', "
          & "'enum', 'native', or '@annotation', found """
          & To_String (Peek (St).Text) & """");
   end Parse_Definition;

   ---------------------------------------------------------------------------

   function Parse (Text : String) return Definition_Vectors.Vector
   is
      St : Parser_State;
      Result : Definition_Vectors.Vector;
   begin
      St.Toks := Lexers.Lex (Text);
      St.Cursor := St.Toks.First_Index;
      --  Cursor is 0-based in Parser_State but the vector is 1-based;
      --  Peek uses Toks (Cursor) so start at First_Index - 1 + 1 = 1.
      St.Cursor := 1;
      while not At_Eof (St) loop
         --  Tolerate stray preprocessor directives (7.3) between
         --  definitions; they are preprocessor concerns, not tree
         --  nodes.
         if Peek_Kind (St) = T.K_Directive then
            Advance (St);
         else
            declare
               Def : S.Definition_Ref;
            begin
               Parse_Definition (St, Def);
               Result.Append (Def);
            end;
         end if;
      end loop;
      return Result;
   end Parse;

end IDL2Lang.Parsers;

