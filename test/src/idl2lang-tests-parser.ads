------------------------------------------------------------------------------
--  IDL2Lang.Tests.Parser -- parser/AST tests (7.4.1 rules 1-68, 7.4.15)
--
--  Exercises Parse over representative IDL texts and asserts the shape
--  of the resulting tree via the Syntax Image functions.
------------------------------------------------------------------------------

with AUnit;
with AUnit.Test_Cases;

package IDL2Lang.Tests.Parser is

   type Parser_Test is new AUnit.Test_Cases.Test_Case with null record;

   overriding procedure Register_Tests (T : in out Parser_Test);
   overriding function Name (T : Parser_Test) return AUnit.Message_String;

end IDL2Lang.Tests.Parser;