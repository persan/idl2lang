------------------------------------------------------------------------------
--  IDL2Lang -- front-end for OMG IDL 4.2 and multi-language code generator.
--
--  The source of truth is the OMG Interface Definition Language (OMG IDL)
--  specification, version 4.2, OMG document formal/18-01-05 (March 2018);
--  every token form, grammar rule, and semantic rule implemented by this
--  library is cross-referenced to its clause number in the source
--  comments.
--
--  This root package holds only what all front-end phases share: the
--  error exception carrying a "line L, column C:" diagnostic in its
--  message.
------------------------------------------------------------------------------

package IDL2Lang is

   Lexical_Error : exception;
   --  Raised by IDL2Lang.Lexers on malformed source text (clauses 7.2
   --  and 7.3).

end IDL2Lang;