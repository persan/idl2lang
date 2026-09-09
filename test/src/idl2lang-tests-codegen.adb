with Ada.Directories;
with Ada.Strings.Unbounded;
with Ada.Streams;
with Ada.Streams.Stream_IO;

with AUnit.Assertions;
use AUnit.Assertions;

with IDL2Lang.Backends;
with IDL2Lang.Backends.Factory;
with IDL2Lang.Parsers;

package body IDL2Lang.Tests.Codegen is

   package B renames IDL2Lang.Backends;
   package SU renames Ada.Strings.Unbounded;

   Oracle_Idl : constant String :=
     "module Hello {" & ASCII.LF
     & "  struct Time {" & ASCII.LF
     & "    unsigned long long seconds;" & ASCII.LF
     & "    unsigned long fraction;" & ASCII.LF
     & "  };" & ASCII.LF
     & "};" & ASCII.LF;

   --  File names in generation order (see the back-end's Generate).
   Expected_Names : constant array (1 .. 4) of access constant String :=
     [new String'("hello.ads"),
      new String'("hello.adb"),
      new String'("hello-time_datareader.ads"),
      new String'("hello-time_datawriter.ads")];

   function Find_Oracle_Dir return String is
      use Ada.Directories;
      Candidate : SU.Unbounded_String :=
        SU.To_Unbounded_String (Current_Directory);
      Depth : Natural := 0;
      --  Bounded walk up: at most 10 levels before giving up.
   begin
      loop
         begin
            if Exists (SU.To_String (Candidate) & "/test/data/oracle_ada") then
               return SU.To_String (Candidate) & "/test/data/oracle_ada";
            end if;
            Depth := Depth + 1;
            exit when Depth > 10;
            Candidate := SU.To_Unbounded_String
              (Containing_Directory (SU.To_String (Candidate)));
         exception
            when others =>
               return "";
         end;
      end loop;
      return "";
   end Find_Oracle_Dir;

   function Bytes_To_String (Raw : Ada.Streams.Stream_Element_Array)
     return String;
   function Bytes_To_String (Raw : Ada.Streams.Stream_Element_Array)
     return String
   is
      Result : String (1 .. Natural (Raw'Length));
   begin
      for I in Result'Range loop
         Result (I) :=
           Character'Val (Raw (Ada.Streams.Stream_Element_Offset (I)));
      end loop;
      return Result;
   end Bytes_To_String;

   function Read_File (Path : String) return String is
      --  Byte-exact read via Stream_IO: Text_IO's Get_Line/End_Of_Line
      --  state machine loses bytes on empty lines and conflates line
      --  marks; parity needs raw bytes.
      use Ada.Streams;
      F : Ada.Streams.Stream_IO.File_Type;
      Raw : Stream_Element_Array (1 .. 1_000_000);
      Last : Stream_Element_Offset;
   begin
      Ada.Streams.Stream_IO.Open
        (F, Ada.Streams.Stream_IO.In_File, Path);
      Ada.Streams.Stream_IO.Read (F, Raw, Last);
      Ada.Streams.Stream_IO.Close (F);
      return Bytes_To_String (Raw (1 .. Last));
   end Read_File;

   procedure Assert_Parity is
      Tree : constant IDL2Lang.Parsers.Definition_Vectors.Vector :=
        IDL2Lang.Parsers.Parse (Oracle_Idl);
      Backend : constant B.Backend_Ref :=
        IDL2Lang.Backends.Factory.Lookup
          (Language => "Ada",
           Vendor   => "RTI",
           Tree     => Tree,
           Idl_Path => "Hello.idl",
           Output_Dir => "");
      Oracle_Dir : constant String := Find_Oracle_Dir;
   begin
      Assert (Oracle_Dir /= "", "oracle directory not found");
      Assert (B.File_Count (Backend.all) = 4,
              "expected 4 emitted files, got"
                & Natural'Image (B.File_Count (Backend.all)));
      --  The back-end emits files in a fixed order; walk the same
      --  order and diff each against the oracle bytes.
      for I in 1 .. 4 loop
         declare
            Actual : constant String := B.File_Contents (Backend.all, I);
            Oracle_Path : constant String :=
              Oracle_Dir & "/" & Expected_Names (I).all;
            Expected : constant String := Read_File (Oracle_Path);
            Diff_At : Natural := 0;
         begin
            Assert (B.File_Name (Backend.all, I)
                      = Expected_Names (I).all,
                    "file name mismatch for file" & I'Img & ": got """
                      & B.File_Name (Backend.all, I) & """");

            --  Byte comparison with a focused first-difference report.
            if Actual /= Expected then
               declare
                  Min_Len : constant Natural :=
                    (if Actual'Length < Expected'Length
                       then Actual'Length else Expected'Length);
               begin
                  for J in 1 .. Min_Len loop
                     if Actual (Actual'First + J - 1)
                          /= Expected (Expected'First + J - 1)
                     then
                        Diff_At := J;
                        exit;
                     end if;
                  end loop;
                  if Diff_At = 0 then
                     Diff_At := Min_Len + 1;
                  end if;
               end;
               Assert (False,
                 Expected_Names (I).all & ": byte difference at offset"
                   & Natural'Image (Diff_At) & " (got length"
                   & Actual'Length'Img & ", expected"
                   & Expected'Length'Img & "); got [[" & Actual & "]]");
            end if;
         end;
      end loop;
   end Assert_Parity;

   ---------------------------------------------------------------------------

   procedure Test_Hello_Oracle
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
   begin
      Assert_Parity;
   end Test_Hello_Oracle;

   ---------------------------------------------------------------------------

   procedure Test_Factory_Unknown_Language
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
      Raised : Boolean := False;
      Tree : constant IDL2Lang.Parsers.Definition_Vectors.Vector :=
        IDL2Lang.Parsers.Parse (Oracle_Idl);
   begin
      begin
         declare
            Backend : constant B.Backend_Ref :=
              IDL2Lang.Backends.Factory.Lookup
                (Language => "Klingon", Vendor => "RTI",
                 Tree => Tree, Idl_Path => "Hello.idl",
                 Output_Dir => "");
         begin
            pragma Unreferenced (Backend);
         end;
      exception
         when B.Backend_Error =>
            Raised := True;
      end;
      Assert (Raised, "unknown language must raise Backend_Error");
   end Test_Factory_Unknown_Language;

   ---------------------------------------------------------------------------

   overriding procedure Register_Tests (T : in out Codegen_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Hello_Oracle'Access, "Hello oracle parity");
      Register_Routine (T, Test_Factory_Unknown_Language'Access,
                        "factory unknown language");
   end Register_Tests;

   overriding function Name (T : Codegen_Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return new String'("IDL2Lang.Codegen");
   end Name;

end IDL2Lang.Tests.Codegen;