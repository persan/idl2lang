------------------------------------------------------------------------------
--  IDL2Lang.Lexers -- body
--
--  One scan over the source string.  All clause references point into
--  OMG IDL 4.2 (formal/18-01-05).
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;

package body IDL2Lang.Lexers is

   package T renames IDL2Lang.Tokens;

   use Ada.Strings.Unbounded;

   function Lex (Text : String) return Token_Vectors.Vector is

      --  The apostrophe is written via Character'Val: a lone ''' char
      --  literal is hard to read and easy to get wrong.
      Apos : constant Character := Character'Val (39);

      Pos  : Natural := Text'First;
      Line : Positive := 1;
      Col  : Positive := 1;
      Line_Start : Boolean := True;
      --  True while only white space and comments have been seen on the
      --  current line (7.3: "White space may appear before the #").

      function Img (N : Positive) return String is
         S : constant String := Positive'Image (N);
      begin
         return S (2 .. S'Last);
      end Img;

      procedure Error (L, C : Positive; Msg : String) is
      begin
         raise IDL2Lang.Lexical_Error
           with "line " & Img (L) & ", column " & Img (C) & ": " & Msg;
      end Error;

      function At_End return Boolean is (Pos > Text'Last);

      --  Consume N characters, keeping Line/Col current.  A carriage
      --  return or line feed is one newline (CRLF counts once); a
      --  newline sets Line_Start, so a '#' after it can be recognized
      --  as a directive (7.3).
      procedure Advance (N : Positive) is
      begin
         for K in 1 .. N loop
            exit when Pos > Text'Last;
            if Text (Pos) = ASCII.LF then
               Line := Line + 1;
               Col := 1;
               Line_Start := True;
            elsif Text (Pos) = ASCII.CR then
               Line := Line + 1;
               Col := 1;
               Line_Start := True;
               if Pos < Text'Last and then Text (Pos + 1) = ASCII.LF then
                  Pos := Pos + 1;   --  CR LF is one newline
               end if;
            else
               Col := Col + 1;
            end if;
            Pos := Pos + 1;
         end loop;
      end Advance;

      function Is_Hex (C : Character) return Boolean is
        (C in '0' .. '9' | 'a' .. 'f' | 'A' .. 'F');

      --  7.2.1: "Blanks, horizontal and vertical tabs, newlines, form
      --  feeds, and comments (collectively, "white space") ... are
      --  ignored except as they serve to separate tokens."
      procedure Skip_White_Space is
      begin
         while not At_End
           and then Text (Pos) in ' ' | ASCII.HT | ASCII.VT | ASCII.FF
                            | ASCII.CR | ASCII.LF
         loop
            Advance (1);
         end loop;
      end Skip_White_Space;

      --  7.2.2: "//" starts a comment that terminates at the end of the
      --  line.  The terminating newline is not consumed here; the next
      --  Skip_White_Space sees it (and resets Line_Start for 7.3).
      procedure Skip_Line_Comment is
      begin
         Advance (2);
         while not At_End
           and then Text (Pos) /= ASCII.LF
           and then Text (Pos) /= ASCII.CR
         loop
            Advance (1);
         end loop;
      end Skip_Line_Comment;

      --  7.2.2: "/*" starts a comment that terminates with "*/"; these
      --  comments do not nest, and newlines inside advance the line.
      procedure Skip_Block_Comment is
         C_Line : constant Positive := Line;
         C_Col  : constant Positive := Col;
      begin
         Advance (2);
         loop
            if At_End then
               Error (C_Line, C_Col, "unterminated comment (7.2.2)");
            elsif Text (Pos) = '*'
              and then Pos < Text'Last
              and then Text (Pos + 1) = '/'
            then
               Advance (2);
               exit;
            else
               Advance (1);
            end if;
         end loop;
      end Skip_Block_Comment;

      procedure Skip_Blank_And_Comments is
      begin
         loop
            Skip_White_Space;
            exit when At_End or else Text (Pos) /= '/';
            if Pos < Text'Last and then Text (Pos + 1) = '/' then
               Skip_Line_Comment;
            elsif Pos < Text'Last and then Text (Pos + 1) = '*' then
               Skip_Block_Comment;
            else
               exit;   --  a lone '/' is the solidus token (Table 7-7)
            end if;
         end loop;
      end Skip_Blank_And_Comments;

      --  Table 7-9 escape sequences (7.2.6.2.2).  At entry Text (Pos)
      --  is the character after the backslash.
      procedure Scan_Escape is
         E_Line : constant Positive := Line;
         E_Col  : constant Positive := Col;
      begin
         if At_End then
            Error (E_Line, E_Col, "unterminated escape sequence (Table 7-9)");
         end if;
         case Text (Pos) is
            when 'n' | 't' | 'v' | 'b' | 'r' | 'f' | 'a'
               | '\' | '?' | Apos | '"' =>
               Advance (1);
            when '0' .. '7' =>
               --  \ooo: one, two, or three octal digits.
               declare
                  Count : Natural := 1;
               begin
                  Advance (1);
                  while Count < 3
                    and then not At_End
                    and then Text (Pos) in '0' .. '7'
                  loop
                     Advance (1);
                     Count := Count + 1;
                  end loop;
               end;
            when 'x' =>
               --  \xhh: one or two hexadecimal digits.
               Advance (1);
               if At_End or else not Is_Hex (Text (Pos)) then
                  Error
                    (E_Line, E_Col,
                     "hexadecimal escape requires at least one hex digit "
                       & "(Table 7-9)");
               end if;
               Advance (1);
               if not At_End and then Is_Hex (Text (Pos)) then
                  Advance (1);
               end if;
            when 'u' =>
               --  \uhhhh: one to four hexadecimal digits.
               Advance (1);
               if At_End or else not Is_Hex (Text (Pos)) then
                  Error
                    (E_Line, E_Col,
                     "Unicode escape requires at least one hex digit "
                       & "(Table 7-9)");
               end if;
               declare
                  Count : Natural := 1;
               begin
                  Advance (1);
                  while Count < 4
                    and then not At_End
                    and then Is_Hex (Text (Pos))
                  loop
                     Advance (1);
                     Count := Count + 1;
                  end loop;
               end;
            when others =>
               Error (E_Line, E_Col, "undefined escape sequence (7.2.6.2.2)");
         end case;
      end Scan_Escape;

      --  7.2.6.2: a character literal is one or more characters in
      --  single quotes, with Table 7-9 escapes; wide literals carry the
      --  L prefix (7.2.6.2.1).  Start is the first character of the
      --  raw token (the L of L'...', or the apostrophe itself).
      procedure Lex_Char (Tok : out T.Token_T; Start : Positive) is
         Start_Line : constant Positive := Line;
         Start_Col : constant Positive := Col;
         Had_Content : Boolean := False;
      begin
         Advance (1);   --  past the opening apostrophe
         loop
            if At_End then
               Error (Start_Line, Start_Col,
                      "unterminated character literal (7.2.6.2)");
            elsif Text (Pos) = ASCII.CR or else Text (Pos) = ASCII.LF then
               Error (Start_Line, Start_Col, "newline in character literal");
            elsif Text (Pos) = Apos then
               if not Had_Content then
                  Error
                    (Start_Line, Start_Col,
                     "character literal must contain one or more "
                       & "characters (7.2.6.2)");
               end if;
               Advance (1);
               exit;
            elsif Text (Pos) = '\' then
               Advance (1);
               Scan_Escape;
               Had_Content := True;
            else
               Advance (1);
               Had_Content := True;
            end if;
         end loop;
         Tok.Kind := T.K_Character_Literal;
         Tok.Text := To_Unbounded_String (Text (Start .. Pos - 1));
      end Lex_Char;

      --  7.2.6.3: a string literal is a sequence of character literals
      --  in double quotes; adjacent string literals are concatenated,
      --  and the double quote must be escaped inside a string.  Start
      --  is the first character of the raw token (the L of L"...").
      procedure Lex_String (Tok : out T.Token_T; Start : Positive) is
         Raw : Unbounded_String;
         Piece_Start : Positive := Start;
         --  First character of the raw text of the current piece; the
         --  first piece carries any leading L, later pieces start at
         --  their opening quote.
         S_Line : constant Positive := Line;
         S_Col  : constant Positive := Col;
         --  Position of the raw token's first character (the L or the
         --  opening quote), for diagnostics.
      begin
         loop
            Advance (1);   --  past the opening quote
            loop
               if At_End then
                  Error (S_Line, S_Col,
                         "unterminated string literal (7.2.6.3)");
               elsif Text (Pos) = ASCII.CR
                 or else Text (Pos) = ASCII.LF
               then
                  Error (S_Line, S_Col, "newline in string literal");
               elsif Text (Pos) = '"' then
                  Advance (1);
                  exit;
               elsif Text (Pos) = '\' then
                  Advance (1);
                  Scan_Escape;
               else
                  Advance (1);
               end if;
            end loop;
            declare
               --  Position just after this piece's closing quote: if no
               --  adjacent literal follows, the scan resumes there.
               After_Pos : constant Natural := Pos;
               After_Line : constant Positive := Line;
               After_Col : constant Positive := Col;
               After_Line_Start : constant Boolean := Line_Start;
            begin
               Raw := Raw & Text (Piece_Start .. Pos - 1);
               --  Look past white space and comments for an adjacent
               --  literal; if none follows, roll the LOOKAHEAD back so
               --  the scan resumes just after this piece's closing
               --  quote.
               Skip_Blank_And_Comments;
               if At_End or else Text (Pos) /= '"' then
                  Pos := After_Pos;
                  Line := After_Line;
                  Col := After_Col;
                  Line_Start := After_Line_Start;
                  exit;
               end if;
               Piece_Start := Pos;   --  next piece starts at its quote
            end;
         end loop;
         Tok.Kind := T.K_String_Literal;
         Tok.Text := Raw;
      end Lex_String;

      --  7.2.6.1 (integer: decimal, octal after a leading 0, hex after
      --  0x/0X), 7.2.6.4 (floating point), 7.2.6.5 (fixed point with
      --  the d/D suffix).  The longest-match rule of 7.2.1 applies.
      procedure Lex_Number (Tok : out T.Token_T) is
         Start : constant Positive := Pos;
         Start_Col : constant Positive := Col;
         Saw_Hex   : Boolean := False;
         Saw_Dot   : Boolean := False;
         Saw_Exp   : Boolean := False;
         Saw_Fixed : Boolean := False;
      begin
         if Text (Pos) = '0' then
            Advance (1);
            if not At_End
              and then (Text (Pos) = 'x' or else Text (Pos) = 'X')
            then
               Advance (1);
               Saw_Hex := True;
               if At_End or else not Is_Hex (Text (Pos)) then
                  Error
                    (Line, Col,
                     "hexadecimal literal requires at least one digit "
                       & "(7.2.6.1)");
               end if;
               while not At_End and then Is_Hex (Text (Pos)) loop
                  Advance (1);
               end loop;
            else
               while not At_End and then Text (Pos) in '0' .. '9' loop
                  Advance (1);
               end loop;
            end if;
         else
            while not At_End and then Text (Pos) in '0' .. '9' loop
               Advance (1);
            end loop;
         end if;

         if not Saw_Hex then
            if not At_End and then Text (Pos) = '.' then
               Advance (1);
               Saw_Dot := True;
               while not At_End and then Text (Pos) in '0' .. '9' loop
                  Advance (1);
               end loop;
            end if;
            if not At_End
              and then (Text (Pos) = 'e' or else Text (Pos) = 'E')
            then
               Advance (1);
               Saw_Exp := True;
               if not At_End
                 and then (Text (Pos) = '+' or else Text (Pos) = '-')
               then
                  Advance (1);
               end if;
               if At_End or else Text (Pos) not in '0' .. '9' then
                  Error
                    (Line, Col,
                     "floating-point exponent requires digits (7.2.6.4)");
               end if;
               while not At_End and then Text (Pos) in '0' .. '9' loop
                  Advance (1);
               end loop;
            elsif not At_End
              and then (Text (Pos) = 'd' or else Text (Pos) = 'D')
            then
               Advance (1);
               Saw_Fixed := True;
            end if;
         end if;

         if Saw_Fixed then
            Tok.Kind := T.K_Fixed_Point_Literal;
         elsif Saw_Dot or else Saw_Exp then
            Tok.Kind := T.K_Floating_Point_Literal;
         else
            --  7.2.6.1: "The digits 8 and 9 are not octal digits and
            --  thus are not allowed in an octal integer literal."
            --  Hexadecimal literals (0x/0X) are exempt.
            if not Saw_Hex
              and then Text (Start) = '0'
              and then Pos - Start > 1
            then
               for I in Start + 1 .. Pos - 1 loop
                  if Text (I) not in '0' .. '7' then
                     raise IDL2Lang.Lexical_Error
                       with "line " & Img (Line) & ", column "
                         & Img (Start_Col + (I - Start))
                         & ": digit """ & Text (I)
                         & """ is not an octal digit (7.2.6.1)";
                  end if;
               end loop;
            end if;
            Tok.Kind := T.K_Integer_Literal;
         end if;
         Tok.Text := To_Unbounded_String (Text (Start .. Pos - 1));
      end Lex_Number;

      --  7.3: a directive is a line whose first non-white-space
      --  character is '#'; a backslash immediately before the newline
      --  continues it on the next line.  The token keeps the raw
      --  source text through the last continuation.
      procedure Lex_Directive (Tok : out T.Token_T) is
         Start : constant Positive := Pos;
      begin
         loop
            exit when At_End
              or else Text (Pos) = ASCII.CR
              or else Text (Pos) = ASCII.LF;
            if Text (Pos) = '\'
              and then Pos < Text'Last
              and then (Text (Pos + 1) = ASCII.LF
                        or else Text (Pos + 1) = ASCII.CR)
            then
               Advance (1);   --  the backslash
               if not At_End then
                  Advance (1);   --  the newline (CRLF counted once)
               end if;
            else
               Advance (1);
            end if;
         end loop;
         Tok.Kind := T.K_Directive;
         Tok.Text := To_Unbounded_String (Text (Start .. Pos - 1));
      end Lex_Directive;

      --  Tables 7-7 / 7-8 punctuation, with the longest-match rule of
      --  7.2.1 for '::', '<<', '>>', '&&', and '||'.
      procedure Lex_Punct (Tok : out T.Token_T) is
         Start : constant Positive := Pos;
         C : constant Character := Text (Pos);

         function Peek return Character is
            (if Pos < Text'Last then Text (Pos + 1) else ASCII.NUL);

      begin
         case C is
            when ';' => Tok.Kind := T.K_Semicolon;     Advance (1);
            when '{' => Tok.Kind := T.K_Left_Brace;    Advance (1);
            when '}' => Tok.Kind := T.K_Right_Brace;   Advance (1);
            when ':' =>
               if Peek = ':' then
                  Tok.Kind := T.K_Scope;
                  Advance (2);
               else
                  Tok.Kind := T.K_Colon;
                  Advance (1);
               end if;
            when ',' => Tok.Kind := T.K_Comma;         Advance (1);
            when '=' => Tok.Kind := T.K_Equal;         Advance (1);
            when '+' => Tok.Kind := T.K_Plus;          Advance (1);
            when '-' => Tok.Kind := T.K_Minus;         Advance (1);
            when '(' => Tok.Kind := T.K_Left_Paren;    Advance (1);
            when ')' => Tok.Kind := T.K_Right_Paren;   Advance (1);
            when '<' =>
               if Peek = '<' then
                  Tok.Kind := T.K_Shift_Left;
                  Advance (2);
               else
                  Tok.Kind := T.K_Less;
                  Advance (1);
               end if;
            when '>' =>
               if Peek = '>' then
                  Tok.Kind := T.K_Shift_Right;
                  Advance (2);
               else
                  Tok.Kind := T.K_Greater;
                  Advance (1);
               end if;
            when '[' => Tok.Kind := T.K_Left_Bracket;  Advance (1);
            when ']' => Tok.Kind := T.K_Right_Bracket; Advance (1);
            when '|' =>
               if Peek = '|' then
                  Tok.Kind := T.K_Or_Or;
                  Advance (2);
               else
                  Tok.Kind := T.K_Bar;
                  Advance (1);
               end if;
            when '^' => Tok.Kind := T.K_Caret;         Advance (1);
            when '&' =>
               if Peek = '&' then
                  Tok.Kind := T.K_And_And;
                  Advance (2);
               else
                  Tok.Kind := T.K_Ampersand;
                  Advance (1);
               end if;
            when '*' => Tok.Kind := T.K_Asterisk;      Advance (1);
            when '/' => Tok.Kind := T.K_Solidus;       Advance (1);
            when '%' => Tok.Kind := T.K_Percent;       Advance (1);
            when '~' => Tok.Kind := T.K_Tilde;         Advance (1);
            when '@' => Tok.Kind := T.K_At;            Advance (1);
            when '!' => Tok.Kind := T.K_Bang;          Advance (1);
            when '\' => Tok.Kind := T.K_Backslash;     Advance (1);
            when others =>
               Error
                 (Line, Col,
                  "character " & Character'Image (C)
                    & " does not start an IDL token (Tables 7-7 / 7-8)");
         end case;
         Tok.Text := To_Unbounded_String (Text (Start .. Pos - 1));
      end Lex_Punct;

      --  7.2.3: an identifier is an arbitrarily long sequence of ASCII
      --  alphabetic, digit, and underscore characters; the first must
      --  be ASCII alphabetic.  An identifier may be "escaped" by a
      --  leading underscore, which only turns off keyword checking
      --  (7.2.3.2).  7.2.4: keywords are matched with exact spelling,
      --  and identifiers that collide with a keyword only in letter
      --  case are illegal.  Also recognizes the L prefix of wide
      --  character / string literals (7.2.6.2.1 / 7.2.6.3).
      procedure Lex_Identifier (Tok : out T.Token_T) is
         Start : constant Positive := Pos;
         Start_Line : constant Positive := Line;
         Start_Col : constant Positive := Col;
      begin
         Advance (1);   --  first character: ASCII alphabetic or '_'
         while not At_End
           and then Text (Pos) in 'a' .. 'z' | 'A' .. 'Z'
                            | '0' .. '9' | '_'
         loop
            Advance (1);
         end loop;
         declare
            Lexeme : constant String := Text (Start .. Pos - 1);

            use all type T.Token_Kind_T;
         begin
            if Lexeme = "_" then
               Error (Start_Line, Start_Col,
                      "a lone underscore is not an identifier (7.2.3)");
            elsif Lexeme (Lexeme'First) = '_' then
               --  Escaped identifier (7.2.3.2): the leading underscore
               --  only turns off keyword checking; the name after it
               --  must still satisfy 7.2.3 (first char ASCII alphabetic).
               if Lexeme (Lexeme'First + 1) not in 'a' .. 'z' | 'A' .. 'Z'
               then
                  Error
                    (Start_Line, Start_Col,
                     "escaped identifier """ & Lexeme
                       & """ must be followed by a name starting with an "
                       & "ASCII alphabetic character (7.2.3.2)");
               end if;
               Tok.Kind := T.K_Identifier;
               Tok.Text := To_Unbounded_String (Lexeme);
            elsif T.Is_Keyword (Lexeme) then
               Tok.Kind := T.K_Keyword;
               Tok.Text := To_Unbounded_String (Lexeme);
            else
               declare
                  Coll : constant String := T.Colliding_Keyword (Lexeme);
               begin
                  if Coll /= "" then
                     Error
                       (Start_Line, Start_Col,
                        "identifier """ & Lexeme
                          & """ collides with keyword """ & Coll
                          & """ (7.2.3.1 / 7.2.4)");
                  end if;
                  Tok.Kind := T.K_Identifier;
                  Tok.Text := To_Unbounded_String (Lexeme);
               end;
            end if;
            --  L prefix of a wide character / string literal: the
            --  lexeme is exactly "L" and the next character is a quote.
            if Tok.Kind = T.K_Identifier
              and then Lexeme = "L"
              and then not At_End
              and then (Text (Pos) = Apos or else Text (Pos) = '"')
            then
               if Text (Pos) = Apos then
                  Lex_Char (Tok, Start);
               else
                  Lex_String (Tok, Start);
               end if;
            end if;
         end;
      end Lex_Identifier;

      Result : Token_Vectors.Vector;

   begin
      while not At_End loop
         Skip_Blank_And_Comments;
         exit when At_End;
         declare
            Tok : T.Token_T :=
              (Kind => T.K_Eof,
               Text => Null_Unbounded_String,
               Line => Line,
               Col  => Col);
         begin
            case Text (Pos) is
               when 'a' .. 'z' | 'A' .. 'Z' | '_' =>
                  Lex_Identifier (Tok);
               when '0' .. '9' =>
                  Lex_Number (Tok);
               when '.' =>
                  --  A '.' only starts a literal when followed by a
                  --  digit (7.2.6.4 / 7.2.6.5: the integer part may be
                  --  missing, but not both parts).
                  if Pos + 1 <= Text'Last
                    and then Text (Pos + 1) in '0' .. '9'
                  then
                     Lex_Number (Tok);
                  else
                     Error
                       (Line, Col,
                        "a '.' not followed by a digit does not start "
                          & "an IDL token");
                  end if;
               when Apos =>
                  Lex_Char (Tok, Pos);
               when '"' =>
                  Lex_String (Tok, Pos);
               when '#' =>
                  if Line_Start then
                     Lex_Directive (Tok);
                  else
                     Error (Line, Col, "'#' outside a directive line (7.3)");
                  end if;
               when others =>
                  Lex_Punct (Tok);
            end case;
            Line_Start := False;
            Token_Vectors.Append (Result, Tok);
         end;
      end loop;
      Token_Vectors.Append
        (Result,
         T.Token_T'(Kind => T.K_Eof,
                    Text => Null_Unbounded_String,
                    Line => Line,
                    Col  => Col));
      return Result;
   end Lex;

end IDL2Lang.Lexers;