------------------------------------------------------------------------------
--  IDL2Lang.Lexers -- lexical analysis of OMG IDL 4.2 source (clause 7.2)
--
--  Lex turns a source text into the token sequence of 7.2.1: white
--  space and comments (7.2.2) separate tokens; identifiers and escaped
--  identifiers (7.2.3 / 7.2.3.2); keywords matched with exact spelling
--  (7.2.4, Table 7-6); the punctuation of Tables 7-7/7-8 with the
--  longest-match rule of 7.2.1; and the literals of 7.2.6: integer
--  (7.2.6.1), character (7.2.6.2, escape sequences of Table 7-9),
--  string (7.2.6.3, adjacent-literal concatenation), floating-point
--  (7.2.6.4) and fixed-point (7.2.6.5).  Lines whose first non-white-
--  space character is '#' are captured whole as K_Directive tokens,
--  including backslash-newline continuations (7.3).
--
--  The final token of every scan is a K_Eof token.  Lexical errors
--  raise IDL2Lang.Lexical_Error with a "line L, column C:" message.
------------------------------------------------------------------------------

with Ada.Containers.Vectors;
with IDL2Lang.Tokens;

package IDL2Lang.Lexers is

   use all type IDL2Lang.Tokens.Token_T;
   --  "=" of the token record is needed by the vector instantiation's
   --  default equality (pitfall #1: non-standard operators need
   --  use all type).

   package Token_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => IDL2Lang.Tokens.Token_T);

   function Lex (Text : String) return Token_Vectors.Vector;
   --  Tokenize Text per clause 7.2; the result ends with a K_Eof token.

end IDL2Lang.Lexers;