------------------------------------------------------------------------------
--  IDL2Lang.Tool -- command-line driver of the idl2lang compiler
--
--  Milestone 0: tokenize one IDL source file and report the token
--  stream (one line per token: line, column, kind, lexeme).  The tool
--  grows with the front-end (parser, semantic model, codegen back-ends
--  in later milestones); the interface is: argument = IDL source file.
--
--  The main procedure is IDL2Lang.Tool (file idl2lang-tool.adb); the
--  executable is named idl2lang_tool via the project's Main attribute.
------------------------------------------------------------------------------

with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

with IDL2Lang.Lexers;
with IDL2Lang.Tokens;

procedure IDL2Lang.Tool is

   package T renames IDL2Lang.Tokens;
   use Ada.Strings.Unbounded;
   use Ada.Text_IO;
   use all type T.Token_Kind_T;

   function Img (N : Natural) return String is
      S : constant String := Natural'Image (N);
   begin
      return S (2 .. S'Last);
   end Img;

   function Read_File (File : String) return String is
      F : File_Type;
      Result : Unbounded_String;
      Line_Buf : String (1 .. 4096);
      Last : Natural;
   begin
      Open (F, In_File, File);
      while not End_Of_File (F) loop
         Get_Line (F, Line_Buf, Last);
         Result := Result & Line_Buf (1 .. Last) & ASCII.LF;
      end loop;
      Close (F);
      return To_String (Result);
   end Read_File;

begin
   if Ada.Command_Line.Argument_Count /= 1 then
      Put_Line ("usage: idl2lang_tool <file.idl>");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   declare
      File : constant String := Ada.Command_Line.Argument (1);
   begin
      declare
         Toks : constant IDL2Lang.Lexers.Token_Vectors.Vector :=
           IDL2Lang.Lexers.Lex (Read_File (File));
      begin
         for Tok of Toks loop
            Put_Line
              (Img (Tok.Line) & ":" & Img (Tok.Col) & " "
                 & T.Image (Tok.Kind) & " "
                 & To_String (Tok.Text));
            exit when Tok.Kind = T.K_Eof;
         end loop;
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
      end;
   exception
      when Err : IDL2Lang.Lexical_Error =>
         Put_Line (Ada.Exceptions.Exception_Message (Err));
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end;
end IDL2Lang.Tool;