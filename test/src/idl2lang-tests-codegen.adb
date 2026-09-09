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

   Shapes_Idl : constant String :=
     "module Shapes {" & ASCII.LF
     & "  enum Color { red, green, blue };" & ASCII.LF
     & ASCII.LF
     & "  struct Point {" & ASCII.LF
     & "    long x;" & ASCII.LF
     & "    long y;" & ASCII.LF
     & "  };" & ASCII.LF
     & ASCII.LF
     & "  struct Polygon {" & ASCII.LF
     & "    string name;" & ASCII.LF
     & "    Color fill;" & ASCII.LF
     & "    Point corners[4];" & ASCII.LF
     & "    sequence<long> lengths;" & ASCII.LF
     & "    sequence<double, 8> weights;" & ASCII.LF
     & "    unsigned short depth;" & ASCII.LF
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
               return SU.To_String (Candidate) & "/test/data";
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

   procedure Assert_Parity
     (Idl_Text : String; Oracle_Subdir : String; Expected_Files : Natural)
   is
      Tree : constant IDL2Lang.Parsers.Definition_Vectors.Vector :=
        IDL2Lang.Parsers.Parse (Idl_Text);
      Backend : constant B.Backend_Ref :=
        IDL2Lang.Backends.Factory.Lookup
          (Language => "Ada",
           Vendor   => "RTI",
           Tree     => Tree,
           Idl_Path =>
             (if Oracle_Subdir = "/oracle_ada" then "Hello.idl"
              else "Shapes.idl"),
           Output_Dir => "");
      Oracle_Dir : constant String :=
        Find_Oracle_Dir & Oracle_Subdir;
   begin
      Assert (Find_Oracle_Dir /= "", "oracle directory not found");
      Assert (B.File_Count (Backend.all) = Expected_Files,
              "expected" & Natural'Image (Expected_Files)
                & " emitted files, got"
                & Natural'Image (B.File_Count (Backend.all)));
      for I in 1 .. Expected_Files loop
         declare
            Actual : constant String := B.File_Contents (Backend.all, I);
            Oracle_Path : constant String :=
              Oracle_Dir & "/" & B.File_Name (Backend.all, I);
            Expected : constant String := Read_File (Oracle_Path);
            Diff_At : Natural := 0;
         begin
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
               declare
                  G_Tail : constant String :=
                    Actual
                      (Natural'Max (Actual'First, Actual'Last - 15)
                         .. Actual'Last);
                  E_Tail : constant String :=
                    Expected
                      (Natural'Max (Expected'First, Expected'Last - 15)
                         .. Expected'Last);
                  Hex : constant String := "0123456789ABCDEF";
                  function Hex_Byte (C : Character) return String is
                    ("" & Hex (Character'Pos (C) / 16 + 1)
                       & Hex (Character'Pos (C) mod 16 + 1));
                  G_Hex, E_Hex : String := "  ";
               begin
                  --  Hex of the bytes around Diff_At on both sides.
                  G_Hex := "  ";
                  E_Hex := "  ";
                  if Diff_At >= 2
                    and then Diff_At <= Actual'Length
                  then
                     G_Hex := Hex_Byte (Actual (Actual'First + Diff_At - 1));
                  end if;
                  if Diff_At >= 2
                    and then Diff_At <= Expected'Length
                  then
                     E_Hex := Hex_Byte (Expected
                       (Expected'First + Diff_At - 1));
                  end if;
                  Assert (False,
                    B.File_Name (Backend.all, I)
                      & ": byte difference at offset"
                      & Natural'Image (Diff_At) & " (got length"
                      & Actual'Length'Img & ", expected"
                      & Expected'Length'Img & "); gen byte="
                      & G_Hex & " oracle byte=" & E_Hex
                      & "; gen tail=[" & G_Tail & "] ora tail=["
                      & E_Tail & "]]");
                  pragma Unreferenced (G_Hex, E_Hex);
               end;
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
      Assert_Parity (Oracle_Idl, "/oracle_ada", 6);
   end Test_Hello_Oracle;

   procedure Test_Shapes_Oracle
     (Tc : in out AUnit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (Tc);
   begin
      --  2 module files + 2 structs x 4 support files
      --  (typespec/typespec-body/datareader/datawriter).
      Assert_Parity (Shapes_Idl, "/oracle_ada2", 2 + 2 * 4);
   end Test_Shapes_Oracle;

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
      Register_Routine (T, Test_Shapes_Oracle'Access, "Shapes oracle parity");
      Register_Routine (T, Test_Factory_Unknown_Language'Access,
                        "factory unknown language");
   end Register_Tests;

   overriding function Name (T : Codegen_Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return new String'("IDL2Lang.Codegen");
   end Name;

end IDL2Lang.Tests.Codegen;