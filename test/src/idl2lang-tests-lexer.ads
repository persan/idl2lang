------------------------------------------------------------------------------
--  IDL2Lang.Tests.Lexer -- clause 7.2 / 7.3 lexical conventions
--
--  Every test cites the sub clause it pins down; expected values are
--  taken from the examples in the normative text (e.g. "the number
--  twelve can be written 12, 014, or 0XC").
------------------------------------------------------------------------------

with AUnit;
with AUnit.Test_Cases;

package IDL2Lang.Tests.Lexer is

   type Lexer_Test is new AUnit.Test_Cases.Test_Case with null record;

   overriding procedure Register_Tests (T : in out Lexer_Test);
   overriding function Name (T : Lexer_Test) return AUnit.Message_String;

end IDL2Lang.Tests.Lexer;