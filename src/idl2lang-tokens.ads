------------------------------------------------------------------------------
--  IDL2Lang.Tokens -- token kinds and the keyword table (7.2.1, 7.2.4)
--
--  Token kinds cover the five token classes of 7.2.1 (identifiers,
--  keywords, literals, operators, other separators): identifiers,
--  keywords, the literal forms of 7.2.6, preprocessor directive lines
--  (7.3), and the punctuation characters of Tables 7-7 and 7-8.  A
--  token keeps the raw source text of its lexeme plus the 1-based
--  line/column of its first character.
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;

package IDL2Lang.Tokens is

   type Token_Kind_T is
     (K_Identifier,
      K_Keyword,
      K_Integer_Literal,            --  7.2.6.1
      K_Floating_Point_Literal,     --  7.2.6.4
      K_Fixed_Point_Literal,        --  7.2.6.5
      K_Character_Literal,          --  7.2.6.2
      K_String_Literal,             --  7.2.6.3
      K_Directive,                  --  line beginning with '#', 7.3

      --  Punctuation (Table 7-7) and preprocessor tokens (Table 7-8).
      K_Semicolon,
      K_Left_Brace,
      K_Right_Brace,
      K_Colon,
      K_Scope,                      --  '::' (rule 4, scoped names)
      K_Comma,
      K_Equal,
      K_Plus,
      K_Minus,
      K_Left_Paren,
      K_Right_Paren,
      K_Less,
      K_Greater,
      K_Shift_Left,                 --  '<<' (rule 11, shift expressions)
      K_Shift_Right,                --  '>>' (rule 11, shift expressions)
      K_Left_Bracket,
      K_Right_Bracket,
      K_Bar,
      K_Caret,
      K_Ampersand,
      K_Asterisk,
      K_Solidus,
      K_Percent,
      K_Tilde,
      K_At,
      K_Bang,                       --  '!' (Table 7-8)
      K_And_And,                    --  '&&' (Table 7-8)
      K_Or_Or,                      --  '||' (Table 7-8)
      K_Double_Hash,                --  '##' (Table 7-8)
      K_Backslash,
      K_Eof);

   type Token_T is record
      Kind : Token_Kind_T;
      Text : Ada.Strings.Unbounded.Unbounded_String;
      Line : Positive;
      Col  : Positive;
   end record;

   function Image (Kind : Token_Kind_T) return String;
   --  Stable spelling of a token kind for diagnostics and tests.

   function Is_Keyword (Name : String) return Boolean;
   --  True iff Name is one of the IDL keywords of Table 7-6, matched
   --  with exact spelling (7.2.4: "Keywords must be written exactly as
   --  shown").  Escaped identifiers (7.2.3.2) are classified by the
   --  lexer before this table is consulted.

   function Colliding_Keyword (Name : String) return String;
   --  If Name differs from exactly one keyword of Table 7-6 only in
   --  letter case, returns that keyword's spelling; otherwise "".
   --  Such identifiers are illegal (7.2.4: "boolean is a valid keyword;
   --  Boolean and BOOLEAN are illegal identifiers").

end IDL2Lang.Tokens;