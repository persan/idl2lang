------------------------------------------------------------------------------
--  IDL2Lang.Tool -- command-line driver of the idl2lang compiler
--
--  Milestone 0/1: tokenize one IDL source file and report the token
--  stream (one line per token: line, column, kind, lexeme), or parse
--  it and print the AST dump ("-ast" flag before the file).  The tool
--  grows with the front-end (semantic model, codegen back-ends in
--  later milestones).
--
--  usage: idl2lang_tool [-ast] <file.idl>
------------------------------------------------------------------------------

with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

with IDL2Lang.Backends;
with IDL2Lang.Backends.Factory;
with IDL2Lang.Lexers;
with IDL2Lang.Parsers;
with IDL2Lang.Syntax;
with IDL2Lang.Tokens;

procedure IDL2Lang.Tool is

   package T renames IDL2Lang.Tokens;
   use Ada.Strings.Unbounded;
   use Ada.Text_IO;
   use all type T.Token_Kind_T;

   Mode_Tokens : constant String := "-tokens";
   Mode_AST : constant String := "-ast";
   Mode_Gen : constant String := "-gen";

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
   if Ada.Command_Line.Argument_Count = 1
     and then Ada.Command_Line.Argument (1) /= Mode_Tokens
   then
      --  Default mode: token stream.
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
   elsif Ada.Command_Line.Argument_Count = 2
     and then Ada.Command_Line.Argument (1) = Mode_AST
   then
      --  AST dump mode.
      declare
         File : constant String := Ada.Command_Line.Argument (2);
      begin
         declare
            Tree : constant IDL2Lang.Parsers.Definition_Vectors.Vector :=
              IDL2Lang.Parsers.Parse (Read_File (File));
         begin
            for Def of Tree loop
               Put_Line (IDL2Lang.Syntax.Image (Def.all));
            end loop;
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
         end;
      exception
         when Err : IDL2Lang.Lexical_Error =>
            Put_Line (Ada.Exceptions.Exception_Message (Err));
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         when Err : IDL2Lang.Parsers.Syntax_Error =>
            Put_Line (Ada.Exceptions.Exception_Message (Err));
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      end;
   elsif Ada.Command_Line.Argument_Count = 4
     and then Ada.Command_Line.Argument (1) = Mode_Gen
   then
      --  Codegen mode: -gen <language> <vendor> <file.idl>; output
      --  goes to the current directory (the factory commits files).
      declare
         Lang : constant String := Ada.Command_Line.Argument (2);
         Vendor : constant String := Ada.Command_Line.Argument (3);
         File : constant String := Ada.Command_Line.Argument (4);
      begin
         declare
            Tree : constant IDL2Lang.Parsers.Definition_Vectors.Vector :=
              IDL2Lang.Parsers.Parse (Read_File (File));
            Be : constant IDL2Lang.Backends.Backend_Ref :=
              IDL2Lang.Backends.Factory.Lookup
                (Lang, Vendor, Tree, File, ".");
         begin
            IDL2Lang.Backends.Write_All (Be.all, ".");
            for I in 1 .. IDL2Lang.Backends.File_Count (Be.all) loop
               Put_Line (IDL2Lang.Backends.File_Name (Be.all, I));
            end loop;
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
         end;
      exception
         when Err : IDL2Lang.Lexical_Error =>
            Put_Line (Ada.Exceptions.Exception_Message (Err));
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         when Err : IDL2Lang.Parsers.Syntax_Error =>
            Put_Line (Ada.Exceptions.Exception_Message (Err));
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         when Err : IDL2Lang.Backends.Backend_Error =>
            Put_Line (Ada.Exceptions.Exception_Message (Err));
            Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      end;
   else
      Put_Line ("usage: idl2lang_tool [-ast] [-gen <language> <vendor>] <file.idl>");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end IDL2Lang.Tool;