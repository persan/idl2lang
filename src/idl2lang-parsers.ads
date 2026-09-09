------------------------------------------------------------------------------
--  IDL2Lang.Parsers -- recursive-descent parser for OMG IDL 4.2
--
--  Produces an IDL2Lang.Syntax tree from the token stream of
--  IDL2Lang.Lexers, following the grammar rules of clause 7.4.1 (Core
--  Data Types, rules 1-68) and clause 7.4.15 (Annotations, rules
--  218-227).  Directive tokens (7.3) are tolerated between definitions
--  and ignored for the tree (their content is a preprocessor concern).
--
--  Syntax errors raise IDL2Lang.Syntax_Error with a "line L, column C:"
--  message locating the offending token.
------------------------------------------------------------------------------

with IDL2Lang.Syntax;

package IDL2Lang.Parsers is

   Syntax_Error : exception;

   --  The "=" of access-to-definition values is needed by the vector
   --  instantiation's default equality (GNAT pitfall #1).
   use all type IDL2Lang.Syntax.Definition_Ref;

   package Definition_Vectors renames IDL2Lang.Syntax.Definition_Vectors;
   --  One shared instance: Parse's result type is the same vector the
   --  back-ends and tests walk, so there is no type conversion anywhere.

   function Parse (Text : String) return Definition_Vectors.Vector;
   --  Parse an IDL translation unit: <specification> (rule 1) is one or
   --  more <definition>s (rule 2) followed by the end of input.  The
   --  token stream comes from IDL2Lang.Lexers.Lex.

end IDL2Lang.Parsers;