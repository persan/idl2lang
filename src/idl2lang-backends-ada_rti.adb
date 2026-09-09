------------------------------------------------------------------------------
--  IDL2Lang.Backends.Ada_RTI -- body
--
--  Byte-parity transcription of rtiddsgen 4.7.0's Ada output for
--  structs of primitive members (see test/data/oracle_ada for the
--  reference files this must reproduce).
------------------------------------------------------------------------------

package body IDL2Lang.Backends.Ada_RTI is

   package SU renames Ada.Strings.Unbounded;
   package S renames IDL2Lang.Syntax;

   use all type S.Type_Kind_T;
   use all type S.Definition_Kind_T;

   function To_Lower (S : String) return String;
   --  ASCII letters only, as used by rtiddsgen for file names.

   function To_Lower (S : String) return String is
      Result : String := S;
   begin
      for I in Result'Range loop
         if Result (I) in 'A' .. 'Z' then
            Result (I) := Character'Val (Character'Pos (Result (I)) + 32);
         end if;
      end loop;
      return Result;
   end To_Lower;

   function Language_Name (Self : Ada_RTI_Backend) return String is
      pragma Unreferenced (Self);
   begin
      return "Ada";
   end Language_Name;

   function Vendor_Name (Self : Ada_RTI_Backend) return String is
      pragma Unreferenced (Self);
   begin
      return "RTI";
   end Vendor_Name;

   --  Header comment block: identical in every generated file.
   procedure Emit_Header
     (Self : in out Ada_RTI_Backend; Idl_Path : String)
   is
   begin
      Self.Put_Line ("--  " & [1 .. 76 => '=']);
      Self.Put_Line ("--");
      Self.Put_Line
        ("--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.");
      Self.Put_Line ("--");
      Self.Put_Line
        ("--  This file was generated from " & Idl_Path);
      Self.Put_Line
        ("--  using RTI Code Generator (rtiddsgen) version 4.7.0.");
      Self.Put_Line
        ("--  The rtiddsgen tool is part of the RTI Connext DDS distribution.");
      Self.Put_Line
        ("--  For more information, type 'rtiddsgen -help' at a command shell");
      Self.Put_Line
        ("--  or consult the Code Generator User's Manual.");
      Self.Put_Line ("--");
      Self.Put_Line ("--  " & [1 .. 76 => '=']);
      Self.New_Line;
   end Emit_Header;

   --  The DDS full-name mapping for primitive members (see the spec
   --  table in the package comment).
   function DDS_Type (T : S.Type_Kind_T) return String is
     (case T is
         when S.T_Short              => "Standard.DDS.Short",
         when S.T_Unsigned_Short     => "Standard.DDS.Unsigned_Short",
         when S.T_Long               => "Standard.DDS.Long",
         when S.T_Unsigned_Long      => "Standard.DDS.Unsigned_Long",
         when S.T_Long_Long          => "Standard.DDS.Long_Long",
         when S.T_Unsigned_Long_Long => "Standard.DDS.Unsigned_Long_Long",
         when S.T_Float              => "Standard.DDS.Float",
         when S.T_Double             => "Standard.DDS.Double",
         when S.T_Long_Double        => "Standard.DDS.Long_Long_Double",
         when S.T_Char               => "Standard.DDS.Char",
         when S.T_Wide_Char          => "Standard.DDS.Wide_Char",
         when S.T_Boolean            => "Standard.DDS.Boolean",
         when S.T_Octet              => "Standard.DDS.Octet",
         when S.T_String             => "Standard.DDS.String",
         when S.T_Wide_String        => "Standard.DDS.Wide_String",
         when others                 => "");
   --  Non-primitive kinds (scoped names, sequences, arrays, fixed) are
   --  handled by later increments; Generate raises Backend_Error on
   --  them for now, loudly, rather than emitting wrong bytes.

   --  Collect the module/type pairs: the first implementation covers
   --  one module containing one or more structs of primitive members
   --  (the shape of the oracle input).  The walk is intentionally
   --  shallow; deeper nestings extend the File_Scope type below.

   --  The byte-parity emitters, one per generated file.

   procedure Emit_Type_Spec_File
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      Idl_Path : String);

   procedure Emit_Type_Body_File
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      Idl_Path : String);

   procedure Emit_DataReader_Spec
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String);

   procedure Emit_DataWriter_Spec
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String);

   ---------------------------------------------------------------------------

   procedure Emit_Type_Spec_File
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      Idl_Path : String)
   is
      Type_Name : constant String := SU.To_String (Def.Name);
      File_Name : constant String := To_Lower (Module_Name) & ".ads";
   begin
      Self.Select_Output_File (File_Name, F_Ada_Spec);
      Self.Emit_Header (Idl_Path);

      Self.Put_Line ("pragma Extensions_Allowed (On);");
      Self.Put_Line ("with DDS;");
      Self.Put_Line ("with DDS.Sequences_Generic;");
      Self.New_Line;
      Self.New_Line;
      Self.Put_Line ("pragma Style_Checks (off); --  Since this is autogenerated code.");
      --  rtiddsgen quirk: "package" followed by two spaces.
      Self.Put_Line ("package  " & Module_Name & " is");
      Self.New_Line;
      --  Quirk: a line holding a single space before the TypeName.
      Self.Put_Line (" ");
      Self.Put_Line
        ("  " & Type_Name & "_TypeName : aliased Standard.DDS.String :="
           & " Standard.DDS.To_DDS_String  (""" & Module_Name & "::"
           & Type_Name & """);");
      Self.Put_Line ("   type " & Type_Name & " is record");
      for I in Def.Members.First_Index .. Def.Members.Last_Index loop
         declare
            M : constant S.Member_T := Def.Members (I);
            Dcl : constant S.Declarator_T :=
              M.Declarators (M.Declarators.First_Index);
         begin
            if M.Member_Type.Kind in S.T_String | S.T_Wide_String
              or else M.Member_Type.Kind = S.T_Scoped_Name
              or else M.Member_Type.Kind = S.T_Sequence
              or else M.Member_Type.Kind = S.T_Fixed
              or else not Dcl.Array_Dims.Is_Empty
            then
               raise Backend_Error
                 with "member """ & SU.To_String (Dcl.Name)
                   & """: non-primitive members are a later increment";
            end if;
            --  Quirk: member lines end with four trailing spaces.
            Self.Put_Line
              ("    " & SU.To_String (Dcl.Name) & " : aliased "
                 & DDS_Type (M.Member_Type.Kind) & ";    ");
         end;
      end loop;
      Self.Put_Line ("   end record;");
      Self.Put_Line (" ");
      Self.Put_Line ("   pragma Convention (C, " & Type_Name & ");");
      Self.Put_Line ("   type " & Type_Name & "_Access is access all "
                       & Type_Name & ";");
      Self.Put_Line ("   pragma No_Strict_Aliasing (" & Type_Name
                       & "_Access);");
      Self.Put_Line ("   type " & Type_Name & "_Array is array "
                       & "(Standard.DDS.Natural range <>) of aliased "
                       & Type_Name & ";");
      Self.Put_Line ("   pragma Convention (C, " & Type_Name & "_Array);");
      Self.Put_Line (" ");
      Self.Put_Line ("   function " & Type_Name & "_Get_TypeCode return "
                       & "Standard.DDS.TypeCode_Access;");
      Self.Put_Line ("   pragma Import (C, " & Type_Name
                       & "_Get_TypeCode, """ & Module_Name & "_"
                       & Type_Name & "_get_typecode"");");
      Self.New_Line;
      Self.Put_Line ("   procedure Initialize (This : in out " & Type_Name
                       & ");");
      Self.Put_Line ("   procedure Finalize (This : in out " & Type_Name
                       & ");");
      Self.Put_Line ("   procedure Copy (Dst : in out " & Type_Name & ";");
      Self.Put_Line ("                   Src : in " & Type_Name & ");");
      --  Quirk: the continuation line's trailing 17 spaces.
      Self.Put_Line ("                 ");
      Self.Put_Line
        ("   package " & Type_Name & "_Seq is new "
           & "Standard.DDS.Sequences_Generic");
      Self.Put_Line ("   (" & Module_Name & "." & Type_Name & ",");
      Self.Put_Line ("    " & Module_Name & "." & Type_Name & "_Access,");
      Self.Put_Line ("    Standard.DDS.Natural,");
      Self.Put_Line ("    1,");
      Self.Put_Line ("    " & Module_Name & "." & Type_Name & "_Array);"
                       & "               ");
      Self.New_Line;
      Self.Put_Line ("end " & Module_Name & ";");
      Self.New_Line;
   end Emit_Type_Spec_File;

   ---------------------------------------------------------------------------

   procedure Emit_Type_Body_File
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      Idl_Path : String)
   is
      Type_Name : constant String := SU.To_String (Def.Name);
      File_Name : constant String := To_Lower (Module_Name) & ".adb";
   begin
      Self.Select_Output_File (File_Name, F_Ada_Body);
      Self.Emit_Header (Idl_Path);

      Self.Put_Line ("pragma Extensions_Allowed (On);");
      Self.Put_Line ("pragma Style_Checks (off);");
      Self.New_Line;
      Self.Put_Line ("with RTI;");
      Self.New_Line;
      Self.Put_Line ("package body " & Module_Name & " is");
      Self.New_Line;
      Self.New_Line;
      Self.Put_Line ("   use type Standard.RTI.Bool;");
      Self.Put_Line ("   procedure Initialize");
      Self.Put_Line ("     (This              : in out " & Type_Name
                       & ") is");
      Self.Put_Line ("      function Internal");
      Self.Put_Line ("        (This : not null access " & Type_Name & ")");
      Self.Put_Line ("         return Standard.RTI.Bool;");
      Self.Put_Line ("      pragma Import (C, Internal, """ & Module_Name
                       & "_" & Type_Name & "_initialize"");");
      Self.Put_Line ("   begin");
      Self.Put_Line ("      if not Internal (This'Unrestricted_Access) then");
      Self.Put_Line ("         raise Standard.DDS.ERROR with ""unable to "
                       & "initialize"";");
      Self.Put_Line ("      end if;");
      Self.Put_Line ("   end Initialize;");
      Self.New_Line;
      Self.Put_Line ("   procedure Finalize");
      Self.Put_Line ("     (This            : in out " & Type_Name & ") is");
      Self.Put_Line ("      procedure Internal");
      Self.Put_Line ("        (This : access " & Type_Name & ";");
      Self.Put_Line ("         deletePointers : Standard.RTI.Bool);");
      Self.Put_Line ("      pragma Import (C, Internal, """ & Module_Name
                       & "_" & Type_Name & "_finalize_ex"");");
      Self.Put_Line ("   begin");
      Self.Put_Line ("      Internal (This'Unrestricted_Access, "
                       & "Standard.RTI.RTI_BOOL_TRUE);");
      Self.Put_Line ("   end Finalize;");
      Self.New_Line;
      Self.Put_Line ("   procedure Copy");
      Self.Put_Line ("     (Dst : in out " & Type_Name & ";");
      Self.Put_Line ("      Src : in " & Type_Name & ") is");
      Self.Put_Line ("      function Internal");
      Self.Put_Line ("        (Dst : not null access " & Type_Name & ";");
      Self.Put_Line ("         Src : not null access " & Type_Name & ")");
      Self.Put_Line ("         return Standard.RTI.Bool;");
      Self.Put_Line ("      pragma Import (C, Internal, """ & Module_Name
                       & "_" & Type_Name & "_copy"");");
      Self.Put_Line ("   begin");
      Self.Put_Line ("      if not Internal (Dst'Unrestricted_Access, "
                       & "Src'Unrestricted_Access) then");
      Self.Put_Line ("         raise Standard.DDS.ERROR with ""unable to "
                       & "copy"";");
      Self.Put_Line ("      end if;");
      Self.Put_Line ("   end Copy;");
      Self.Put_Line (" end " & Module_Name & ";");
      Self.New_Line;
   end Emit_Type_Body_File;

   ---------------------------------------------------------------------------

   procedure Emit_DataReader_Spec
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String)
   is
      File_Name : constant String :=
        To_Lower (Module_Name & "-" & Type_Name & "_datareader") & ".ads";
   begin
      Self.Select_Output_File (File_Name, F_Ada_Spec);
      Self.Emit_Header (Idl_Path);
      Self.Put_Line ("pragma Extensions_Allowed (On);");
      Self.Put_Line ("pragma Style_Checks (Off);");
      Self.New_Line;
      Self.Put_Line ("with DDS.Typed_DataReader_Generic; pragma Elaborate "
                       & "(DDS.Typed_DataReader_Generic);");
      Self.Put_Line ("with " & Module_Name & "." & Type_Name
                       & "_TypeSupport;");
      Self.Put_Line ("package " & Module_Name & "." & Type_Name
                       & "_DataReader is new");
      Self.Put_Line ("  Standard.DDS.Typed_DataReader_Generic ("
                       & Module_Name & "." & Type_Name
                       & "_TypeSupport." & Type_Name & "_Treats);");
   end Emit_DataReader_Spec;

   procedure Emit_DataWriter_Spec
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String)
   is
      File_Name : constant String :=
        To_Lower (Module_Name & "-" & Type_Name & "_datawriter") & ".ads";
   begin
      Self.Select_Output_File (File_Name, F_Ada_Spec);
      Self.Emit_Header (Idl_Path);
      Self.Put_Line ("pragma Extensions_Allowed (On);");
      Self.Put_Line ("pragma Style_Checks (Off);");
      Self.New_Line;
      Self.Put_Line ("with DDS.Typed_DataWriter_Generic; pragma Elaborate "
                       & "(DDS.Typed_DataWriter_Generic);");
      Self.Put_Line ("with " & Module_Name & "." & Type_Name
                       & "_TypeSupport;");
      Self.Put_Line ("package " & Module_Name & "." & Type_Name
                       & "_DataWriter is new");
      Self.Put_Line ("  Standard.DDS.Typed_DataWriter_Generic ("
                       & Module_Name & "." & Type_Name
                       & "_TypeSupport." & Type_Name & "_Treats);");
   end Emit_DataWriter_Spec;

   ---------------------------------------------------------------------------

   procedure Generate
     (Self     : in out Ada_RTI_Backend;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String)
   is
   begin
      --  First increment: module(s) of primitive structs, per the
      --  oracle shape.  Anything else raises Backend_Error.
      for I in Tree.First_Index .. Tree.Last_Index loop
         declare
            D : constant S.Definition_Ref := Tree (I);
         begin
            if D.Kind = S.D_Module then
               declare
                  Module_Name : constant String := SU.To_String (D.Name);
               begin
                  for J in D.Module_Body.First_Index
                             .. D.Module_Body.Last_Index
                  loop
                     declare
                        Sub : constant S.Definition_Ref := D.Module_Body (J);
                     begin
                        if Sub.Kind = S.D_Struct then
                           Self.Emit_Type_Spec_File
                             (Module_Name, Sub, Idl_Path);
                           Self.Emit_Type_Body_File
                             (Module_Name, Sub, Idl_Path);
                           Self.Emit_DataReader_Spec
                             (Module_Name, SU.To_String (Sub.Name),
                              Idl_Path);
                           Self.Emit_DataWriter_Spec
                             (Module_Name, SU.To_String (Sub.Name),
                              Idl_Path);
                        else
                           raise Backend_Error
                             with "only structs inside modules are "
                               & "supported by this increment (found "
                               & S.Definition_Kind_T'Image (Sub.Kind) & ")";
                        end if;
                     end;
                  end loop;
               end;
            else
               raise Backend_Error
                 with "only modules are supported by this increment";
            end if;
         end;
      end loop;
   end Generate;

end IDL2Lang.Backends.Ada_RTI;