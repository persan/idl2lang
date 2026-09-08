------------------------------------------------------------------------------
--  Test_IDL2Lang -- AUnit harness for the idl2lang test suites.
--
--  Instantiates AUnit's Test_Runner_With_Status generic so the process
--  exit status reflects the outcome.
------------------------------------------------------------------------------

with AUnit;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Suites;
with Ada.Command_Line;

with IDL2Lang.Tests.Lexer;
with IDL2Lang.Tests.Parser;

procedure Test_IDL2Lang is

   use AUnit.Test_Suites;
   use all type AUnit.Status;

   function Suite return Access_Test_Suite;
   --  Build the suite: one test-case object per test package.

   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
   begin
      Add_Test (Result, new IDL2Lang.Tests.Lexer.Lexer_Test);
      Add_Test (Result, new IDL2Lang.Tests.Parser.Parser_Test);
      return Result;
   end Suite;

   --  Instantiate the status-returning runner on this suite.
   function Run_Suite is new AUnit.Run.Test_Runner_With_Status (Suite);

   Status   : AUnit.Status;
   Reporter : aliased AUnit.Reporter.Text.Text_Reporter;

begin
   Status := Run_Suite (Reporter);
   if Status = AUnit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
   else
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Test_IDL2Lang;