------------------------------------------------------------------------------
--  IDL2Lang.Backends.Ada_RTI -- body
--
--  Byte-parity transcription of rtiddsgen 4.7.0's Ada output.  The
--  typesupport body is emitted from the whole-word token template of
--  the oracle (Point -> <Type>), matching rtiddsgen's own template
--  engine.
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;

package body IDL2Lang.Backends.Ada_RTI is

   package SU renames Ada.Strings.Unbounded;
   package S renames IDL2Lang.Syntax;

   use all type S.Type_Kind_T;
   use all type S.Definition_Kind_T;
   use all type S.Expression_Ref;

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

   --  DDS full-name mapping for primitive members (dds_rtiddsgen
  --  mapping; verified against the Kitchen oracle).
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
         when S.T_Long_Double        => "Standard.DDS.Long_Double",
         when S.T_Char               => "Standard.DDS.Char",
         when S.T_Wide_Char          => "Standard.DDS.Wchar",
         when S.T_Boolean            => "Standard.DDS.Boolean",
         when S.T_Octet              => "Standard.DDS.Octet",
         when S.T_String             => "Standard.DDS.String",
         when S.T_Wide_String        => "Standard.DDS.Wide_String",
         when others                 => "");

   --  The pre-instantiated sequence type for primitive element types
   --  (oracle: "sequence<long>" -> Standard.DDS.Long_Seq.Sequence).
   function DDS_Seq (T : S.Type_Kind_T) return String is
     (case T is
         when S.T_Short              => "Standard.DDS.Short_Seq.Sequence",
         when S.T_Unsigned_Short     =>
            "Standard.DDS.Unsigned_Short_Seq.Sequence",
         when S.T_Long               => "Standard.DDS.Long_Seq.Sequence",
         when S.T_Unsigned_Long      =>
            "Standard.DDS.Unsigned_Long_Seq.Sequence",
         when S.T_Long_Long          =>
            "Standard.DDS.Long_Long_Seq.Sequence",
         when S.T_Unsigned_Long_Long =>
            "Standard.DDS.Unsigned_Long_Long_Seq.Sequence",
         when S.T_Float              => "Standard.DDS.Float_Seq.Sequence",
         when S.T_Double             => "Standard.DDS.Double_Seq.Sequence",
         when S.T_Long_Double        =>
            "Standard.DDS.Long_Double_Seq.Sequence",
         when S.T_Char               => "Standard.DDS.Char_Seq.Sequence",
         when S.T_Wide_Char          => "Standard.DDS.Wchar_Seq.Sequence",
         when S.T_Boolean            => "Standard.DDS.Boolean_Seq.Sequence",
         when S.T_Octet              => "Standard.DDS.Octet_Seq.Sequence",
         when others                 => "");

   --  Placeholder substitution (rtiddsgen's template engine): the
   --  templates carry "@TYPE@" and "@MODL@" markers; every occurrence
   --  is replaced.  Literal text like "AllocatePointers" carries no
   --  marker and survives untouched, exactly as in rtiddsgen.
   function Substitute (Template : String; Old_Tok, New_Tok : String)
     return String;

   function Substitute (Template : String; Old_Tok, New_Tok : String)
     return String
   is
      Result : SU.Unbounded_String;
      I : Positive := Template'First;
   begin
      while I <= Template'Last loop
         if I + Old_Tok'Length - 1 <= Template'Last
           and then Template (I .. I + Old_Tok'Length - 1) = Old_Tok
         then
            SU.Append (Result, New_Tok);
            I := I + Old_Tok'Length;
         else
            SU.Append (Result, Template (I));
            I := I + 1;
         end if;
      end loop;
      return SU.To_String (Result);
   end Substitute;

   function Img_Positive (N : Natural) return String is
      S : constant String := Natural'Image (N);
   begin
      return S (2 .. S'Last);   --  trim the leading space
   end Img_Positive;

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

   ---------------------------------------------------------------------
   --  <module>.ads per-type blocks
   ---------------------------------------------------------------------

   procedure Emit_Enum_Block
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref)
   is
      Enum_Name : constant String := SU.To_String (Def.Name);
   begin
      --  Separator: a plain blank line before the enum block (the
      --  struct's separator is its " " line; the enum's is blank).
      Self.Put_Line ("");
      --  Quirks: "type N is (" then 9-space-indented enumerators with
      --  trailing ", " and the last one "name   );" (3 spaces before
      --  ");").
      Self.Put_Line ("   type " & Enum_Name & " is (");
      for I in Def.Enumerators.First_Index .. Def.Enumerators.Last_Index
      loop
         declare
            E : constant String :=
              SU.To_String (Def.Enumerators (I).Name);
         begin
            if I < Def.Enumerators.Last_Index then
               Self.Put_Line ("         " & E & ", ");
            else
               Self.Put_Line
                 ("         " & E & "   );");
            end if;
         end;
      end loop;
      Self.Put_Line ("   pragma Convention (C, " & Enum_Name & ");");
      Self.Put_Line ("   for " & Enum_Name & " use (");
      for I in Def.Enumerators.First_Index .. Def.Enumerators.Last_Index
      loop
         declare
            E : constant String :=
              SU.To_String (Def.Enumerators (I).Name);
         begin
            if I < Def.Enumerators.Last_Index then
               Self.Put_Line
                 ("         " & E & " => "
                    & Img_Positive (I - 1) & " , ");
            else
               Self.Put_Line
                 ("         " & E & " => "
                    & Img_Positive (I - 1) & "    );");
            end if;
         end;
      end loop;
      Self.Put_Line ("   type " & Enum_Name & "_Access is access all "
                       & Enum_Name & ";");
      Self.Put_Line ("   pragma No_Strict_Aliasing (" & Enum_Name
                       & "_Access);");
      Self.Put_Line ("   type " & Enum_Name & "_Array is array "
                       & "(Standard.DDS.Natural range <>) of aliased "
                       & Enum_Name & ";");
      Self.Put_Line ("   pragma Convention (C, " & Enum_Name & "_Array);");
      Self.Put_Line (" ");
      Self.Put_Line ("   function " & Enum_Name & "_Get_TypeCode return "
                       & "Standard.DDS.TypeCode_Access;");
      Self.Put_Line ("   pragma Import (C, " & Enum_Name
                       & "_Get_TypeCode, """ & Module_Name & "_"
                       & Enum_Name & "_get_typecode"");");
      Self.New_Line;
      Self.Put_Line ("   procedure Initialize (This : in out "
                       & Enum_Name & ");");
      Self.Put_Line ("   procedure Finalize (This : in out " & Enum_Name
                       & ");");
      Self.Put_Line ("   procedure Copy (Dst : in out " & Enum_Name & ";");
      Self.Put_Line ("                   Src : in " & Enum_Name & ");");
      Self.Put_Line ("                 ");
      Self.Put_Line
        ("   package " & Enum_Name & "_Seq is new "
           & "Standard.DDS.Sequences_Generic");
      Self.Put_Line ("   (" & Module_Name & "." & Enum_Name & ",");
      Self.Put_Line ("    " & Module_Name & "." & Enum_Name & "_Access,");
      Self.Put_Line ("    Standard.DDS.Natural,");
      Self.Put_Line ("    1,");
      Self.Put_Line ("    " & Module_Name & "." & Enum_Name & "_Array);"
                       & "               ");
   end Emit_Enum_Block;

   procedure Emit_Struct_Block
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref)
   is
      Type_Name : constant String := SU.To_String (Def.Name);
   begin
      --  Separator: a line holding a single space (before every
      --  struct block; see the Hello and Shapes oracles).
      Self.Put_Line (" ");
      --  Quirk: 2-space indent for the TypeName line (not 3).
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
            M_Name : constant String := SU.To_String (Dcl.Name);
         begin
            if not Dcl.Array_Dims.Is_Empty then
               --  Quirk: "aliased  " double space for array members;
               --  "Module.Type_Array(1..N)" with the dims inlined.
               if Dcl.Array_Dims.Last_Index > 1 then
                  raise Backend_Error
                    with "multi-dimensional arrays are a later increment";
               end if;
               declare
                  Elem_Name : constant String :=
                    (if M.Member_Type.Kind = T_Scoped_Name
                       then S.Image (M.Member_Type.Type_Name)
                     else DDS_Type (M.Member_Type.Kind));
                  Bound : constant String :=
                    S.Image (Dcl.Array_Dims (1).all);
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  " & Module_Name
                       & "." & Elem_Name & "_Array(1.." & Bound & ");");
               end;
            elsif M.Member_Type.Kind = T_Sequence then
               --  Quirk: "aliased  " double space; primitive element
               --  types map to the pre-instantiated Standard.DDS.*_Seq.
               if M.Member_Type.Element_Type.Kind = T_Scoped_Name then
                  raise Backend_Error
                    with "sequences of non-primitive elements are a "
                      & "later increment";
               end if;
               Self.Put_Line
                 ("    " & M_Name & " : aliased  "
                    & DDS_Seq (M.Member_Type.Element_Type.Kind) & ";");
            elsif M.Member_Type.Kind = T_Scoped_Name then
               --  Scoped-name members use the fully qualified name
               --  (Module.Type) and the same four trailing spaces as
               --  primitives.
               Self.Put_Line
                 ("    " & M_Name & " : aliased " & Module_Name & "."
                    & S.Image (M.Member_Type.Type_Name) & ";    ");
            elsif M.Member_Type.Kind = T_String
              or else M.Member_Type.Kind = T_Wide_String
            then
               declare
                  Bound : constant String :=
                    (if M.Member_Type.String_Bound = null
                       then "255"
                       else S.Image (M.Member_Type.String_Bound.all));
                  W : constant String :=
                    (if M.Member_Type.Kind = T_Wide_String
                       then "Wide_" else "");
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased Standard.DDS."
                       & W & "String; --  maximum length = (" & Bound
                       & ")    ");
               end;
            else
               --  Quirk: primitive member lines end with four spaces.
               Self.Put_Line
                 ("    " & M_Name & " : aliased "
                    & DDS_Type (M.Member_Type.Kind) & ";    ");
            end if;
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
   end Emit_Struct_Block;

   ---------------------------------------------------------------------
   --  <module>.adb per-type blocks
   ---------------------------------------------------------------------

   procedure Emit_Body_Initialize
     (Self : in out Ada_RTI_Backend; Module_Name, Type_Name : String)
   is
   begin
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
   end Emit_Body_Initialize;

   procedure Emit_Body_Finalize
     (Self : in out Ada_RTI_Backend; Module_Name, Type_Name : String)
   is
   begin
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
   end Emit_Body_Finalize;

   procedure Emit_Body_Copy
     (Self : in out Ada_RTI_Backend; Module_Name, Type_Name : String)
   is
   begin
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
   end Emit_Body_Copy;

   ---------------------------------------------------------------------
   --  datareader / datawriter specs
   ---------------------------------------------------------------------

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

   ---------------------------------------------------------------------
   --  typesupport files
   ---------------------------------------------------------------------

   --  The typesupport spec template (from the Point oracle; TYPE is
   --  the type name, MODL the module name).
   Typesupport_Spec_Template : constant String :=
      "pragma Extensions_Allowed (On);" & ASCII.LF
    & "pragma Warnings (Off); --  Since this is autogenerated code."
      & ASCII.LF
    & "pragma Style_Checks (off);" & ASCII.LF
    & "pragma Extensions_Allowed (On);" & ASCII.LF
    & ASCII.LF
    & "with DDS;" & ASCII.LF
    & "with DDS.DomainParticipant;" & ASCII.LF
    & "with DDS.TypeSupport;" & ASCII.LF
    & "with DDS.DataReader;" & ASCII.LF
    & "with DDS.DataWriter;" & ASCII.LF
    & "with DDS.Treats_Generic;" & ASCII.LF
    & "with DDS.MetpTypeSupport_None;" & ASCII.LF
    & "with System;" & ASCII.LF
    & "package @MODL@.@TYPE@_TypeSupport is" & ASCII.LF
    & ASCII.LF
    & "   type Ref is new Standard.DDS.TypeSupport.Ref with null record;"
      & ASCII.LF
    & "   type Ref_Access is access all Ref'Class;" & ASCII.LF
    & ASCII.LF
    & "   function Create_TypedDataReaderI" & ASCII.LF
    & "     (Self : access Ref) return Standard.DDS.DataReader.Ref_Access;"
      & ASCII.LF
    & ASCII.LF
    & "   procedure Destroy_TypedDataReaderI" & ASCII.LF
    & "     (Self   : access Ref;" & ASCII.LF
    & "      Reader : in out Standard.DDS.DataReader.Ref_Access);"
      & ASCII.LF
    & ASCII.LF
    & "   function Create_TypedDataWriterI" & ASCII.LF
    & "     (Self : access Ref) return Standard.DDS.DataWriter.Ref_Access;"
      & ASCII.LF
    & ASCII.LF
    & "   procedure Destroy_TypedDataWriterI" & ASCII.LF
    & "     (Self   : access Ref;" & ASCII.LF
    & "      Writer : in out Standard.DDS.DataWriter.Ref_Access);"
      & ASCII.LF
    & ASCII.LF
    & "   --  static methods" & ASCII.LF
    & ASCII.LF
    & "   procedure Register_Type" & ASCII.LF
    & "     (Participant :  not null access "
      & "Standard.DDS.DomainParticipant.Ref'Class;" & ASCII.LF
    & "      Type_Name   : in Standard.DDS.String);" & ASCII.LF
    & ASCII.LF
    & "   procedure Unregister_Type" & ASCII.LF
    & "     (Participant : not null access "
      & "Standard.DDS.DomainParticipant.Ref'Class;" & ASCII.LF
    & "      Type_Name   : in Standard.DDS.String);" & ASCII.LF
    & ASCII.LF
    & "   function Get_Type_Name return Standard.DDS.String;" & ASCII.LF
    & ASCII.LF
    & "   function Create_Data (AllocatePointers : in Boolean := True)"
      & ASCII.LF
    & "     return not null @TYPE@_Access;" & ASCII.LF
    & ASCII.LF
    & "   procedure Delete_Data" & ASCII.LF
    & "     (A_Data : in out @TYPE@_Access; DeletePointers : in Boolean := "
      & "True);" & ASCII.LF
    & ASCII.LF
    & "   procedure Print_Data (A_Data : not null access constant @TYPE@);"
      & ASCII.LF
    & ASCII.LF
    & "   procedure Copy_Data" & ASCII.LF
    & "     (Dest   : not null access @TYPE@;" & ASCII.LF
    & "      Source : not null access constant @TYPE@);" & ASCII.LF
    & ASCII.LF
    & "   procedure Initialize_Data" & ASCII.LF
    & "     (Dest             : not null access @TYPE@;" & ASCII.LF
    & "      AllocatePointers : in Boolean := True);" & ASCII.LF
    & ASCII.LF
    & "   procedure Finalize_Data" & ASCII.LF
    & "     (Dest           : not null access @TYPE@;" & ASCII.LF
    & "      DeletePointers : in Boolean := True);" & ASCII.LF
    & ASCII.LF
    & "   procedure Finalize;" & ASCII.LF
    & ASCII.LF
    & "   package @TYPE@_Treats is new" & ASCII.LF
    & "     Standard.DDS.Treats_Generic (Data_Type        => @TYPE@,"
      & ASCII.LF
    & "                                  Data_Type_Access => @TYPE@_Access,"
      & ASCII.LF
    & "                                  Index_Type       => "
      & "Standard.DDS.Natural," & ASCII.LF
    & "                                  First_Element    => 1,"
      & ASCII.LF
    & "                                  Data_Array       => @TYPE@_Array,"
      & ASCII.LF
    & "                                  Initialize       => Initialize,"
      & ASCII.LF
    & "                                  Finalize         => Finalize,"
      & ASCII.LF
    & "                                  Copy             => Copy,"
      & ASCII.LF
    & "                                  Data_Sequences   => @TYPE@_Seq,"
      & ASCII.LF
    & "                                  Get_Type_Name    => Get_Type_Name,"
      & ASCII.LF
    & "                                  TypeSupport      => Ref,"
      & ASCII.LF
    & "                                  MetpTypeSupport  => "
      & "Standard.DDS.MetpTypeSupport_None.Ref);" & ASCII.LF
    & ASCII.LF
    & "end @MODL@.@TYPE@_TypeSupport;" & ASCII.LF;

   --  The typesupport body template (from the Point oracle).  Case
   --  matters: "Shapes_PointTypeSupport_..." in pragma Imports, etc.
   Typesupport_Body_Template : constant String :=
      "pragma Extensions_Allowed (On);" & ASCII.LF
    & "pragma Warnings (Off); --  Since this is autogenerated code."
      & ASCII.LF
    & "pragma Style_Checks (off);" & ASCII.LF
    & ASCII.LF
    & "with Ada.Unchecked_Conversion;" & ASCII.LF
    & ASCII.LF
    & "with DDS.Builtin_Octets_TypeSupport;" & ASCII.LF
    & "with DDS.DomainParticipant_Impl;" & ASCII.LF
    & ASCII.LF
    & "with Interfaces.C.Strings;" & ASCII.LF
    & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_dds_c_dds_c_octet_buffer_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_dds_c_dds_c_string_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_osapi_osapi_alignment_impl_h;"
      & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_pres_pres_common_h;" & ASCII.LF
    & "with RTIDDS.Low_Level.ndds_pres_pres_typePlugin_h;" & ASCII.LF
    & ASCII.LF
    & "with @MODL@.@TYPE@_DataReader;" & ASCII.LF
    & "with @MODL@.@TYPE@_DataWriter;" & ASCII.LF
    & ASCII.LF
    & "package body @MODL@.@TYPE@_TypeSupport is" & ASCII.LF
    & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_impl_h;" & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_dds_c_dds_c_domain_h;" & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_pres_pres_typePlugin_h;" & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_osapi_osapi_alignment_impl_h;"
      & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_dds_c_dds_c_builtin_h;" & ASCII.LF
    & "   use RTIDDS.Low_Level.ndds_dds_c_dds_c_string_h;" & ASCII.LF
    & ASCII.LF
    & "   The_Instance : aliased Ref;" & ASCII.LF
    & "   Instance_Ref : constant Standard.DDS.TypeSupport.Ref_Access :="
      & " The_Instance'Access;" & ASCII.LF
    & ASCII.LF
    & "   function Create_TypedDataReaderI" & ASCII.LF
    & "     (Self : access Ref) return Standard.DDS.DataReader.Ref_Access"
      & " is" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      return @MODL@.@TYPE@_DataReader.CreateTypedI;" & ASCII.LF
    & "   end  Create_TypedDataReaderI;" & ASCII.LF
    & ASCII.LF
    & "   procedure Destroy_TypedDataReaderI" & ASCII.LF
    & "     (Self   : access Ref;" & ASCII.LF
    & "      Reader : in out Standard.DDS.DataReader.Ref_Access) is"
      & ASCII.LF
    & "   begin" & ASCII.LF
    & "      @MODL@.@TYPE@_DataReader.DestroyTypedI (Reader);" & ASCII.LF
    & "   end  Destroy_TypedDataReaderI;" & ASCII.LF
    & ASCII.LF
    & "   function Create_TypedDataWriterI" & ASCII.LF
    & "     (Self : access Ref) return Standard.DDS.DataWriter.Ref_Access"
      & " is" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      return @MODL@.@TYPE@_DataWriter.CreateTypedI;" & ASCII.LF
    & "   end  Create_TypedDataWriterI;" & ASCII.LF
    & ASCII.LF
    & "   procedure Destroy_TypedDataWriterI" & ASCII.LF
    & "     (Self   : access Ref;" & ASCII.LF
    & "      Writer : in out Standard.DDS.DataWriter.Ref_Access) is"
      & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Writer := null;" & ASCII.LF
    & "   end Destroy_TypedDataWriterI;" & ASCII.LF
    & ASCII.LF
    & "   function Get_Native_Typesupport_Ptr" & ASCII.LF
    & "     (DeleteInstance : Standard.DDS.Boolean)" & ASCII.LF
    & "     return System.Address;" & ASCII.LF
    & "   pragma Import (C, Get_Native_Typesupport_Ptr, "
      & """@MODL@_@TYPE@TypeSupport_get_or_delete_instanceI"");" & ASCII.LF
    & ASCII.LF
    & "   function R_To_A is new Ada.Unchecked_Conversion" & ASCII.LF
    & "     (Source => Ref_Access," & ASCII.LF
    & "      Target => System.Address);" & ASCII.LF
    & ASCII.LF
    & "   procedure Set_User_Data" & ASCII.LF
    & "     (Self : System.Address; User_Data : System.Address);"
      & ASCII.LF
    & "   pragma Import (C, Set_User_Data,                  "
      & """DDS_DataTypeUtility_set_user_dataI"");" & ASCII.LF
    & ASCII.LF
    & "   -------------------" & ASCII.LF
    & "   -- Register_Type --" & ASCII.LF
    & "   -------------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Register_Type" & ASCII.LF
    & "     (Participant : not null access "
      & "Standard.DDS.DomainParticipant.Ref'Class;" & ASCII.LF
    & "      Type_Name   : in Standard.DDS.String) is" & ASCII.LF
    & ASCII.LF
    & "      P : constant Standard.DDS.DomainParticipant_Impl.Ref_Access :"
      & "=" & ASCII.LF
    & "            Standard.DDS.DomainParticipant_Impl.Ref_Access "
      & "(Participant);" & ASCII.LF
    & ASCII.LF
    & "      function InternalCreatePlugin" & ASCII.LF
    & "         return access PRESTypePlugin;" & ASCII.LF
    & "      pragma Import (C, InternalCreatePlugin, "
      & """@MODL@_@TYPE@Plugin_new"");" & ASCII.LF
    & ASCII.LF
    & "      procedure InternalDeletePlugin" & ASCII.LF
    & "        (plugin : access PRESTypePlugin);" & ASCII.LF
    & "      pragma Import (C, InternalDeletePlugin, "
      & """@MODL@_@TYPE@Plugin_delete"");" & ASCII.LF
    & ASCII.LF
    & "      function InternalRegister" & ASCII.LF
    & "        (Participant : System.Address;" & ASCII.LF
    & "         Type_Name   : in Interfaces.C.Strings.chars_ptr;"
      & ASCII.LF
    & "         InternalPresTypePlugin : System.Address;" & ASCII.LF
    & "         Registration_Data : in System.Address)" & ASCII.LF
    & "         return Standard.DDS.ReturnCode_T;" & ASCII.LF
    & "      pragma Import (C, InternalRegister, "
      & """DDS_DomainParticipant_register_type"");" & ASCII.LF
    & ASCII.LF
    & "      C_DataTypeUtility_Ptr : access PRESTypePlugin;" & ASCII.LF
    & "      InternalTypePlugin : access PRESTypePlugin;" & ASCII.LF
    & "      type TempT is access all "
      & "RTIDDS.Low_Level.ndds_pres_pres_common_h.PRESWord;" & ASCII.LF
    & "      function convert is new Ada.Unchecked_Conversion "
      & "(Standard.DDS.TypeSupport.Ref_Access, TempT);" & ASCII.LF
    & "      Code                  : Standard.dds.ReturnCode_T;"
      & ASCII.LF
    & "   begin" & ASCII.LF
    & "      InternalTypePlugin := InternalCreatePlugin;" & ASCII.LF
    & "      InternalTypePlugin.all.U_UserBuffer := Convert "
      & "(Instance_Ref).all'Unrestricted_Access;" & ASCII.LF
    & "      Code := InternalRegister (P.GetInterface, Type_Name.Data, "
      & "InternalTypePlugin.all'Address, System.Null_Address);" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception (Code, ""unable to "
      & "register type"");" & ASCII.LF
    & "      InternalDeletePlugin (InternalTypePlugin);" & ASCII.LF
    & "   end Register_Type;" & ASCII.LF
    & ASCII.LF
    & "   procedure Register_Type (Participant :  not null access "
      & "Standard.DDS.DomainParticipant.Ref'Class) is" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Register_Type (Participant, Get_Type_Name);" & ASCII.LF
    & "   end;" & ASCII.LF
    & "   -------------------" & ASCII.LF
    & "   -- Unregister_Type --" & ASCII.LF
    & "   -------------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Unregister_Type" & ASCII.LF
    & "     (Participant : not null access "
      & "Standard.DDS.DomainParticipant.Ref'Class;" & ASCII.LF
    & "      Type_Name   : in Standard.DDS.String) is" & ASCII.LF
    & ASCII.LF
    & "      function Internal" & ASCII.LF
    & "        (Participant : System.Address;" & ASCII.LF
    & "         Type_Name   : in Interfaces.C.Strings.chars_ptr)"
      & ASCII.LF
    & "         return Standard.DDS.ReturnCode_T;" & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_unregister_type"");" & ASCII.LF
    & ASCII.LF
    & "      Code                  : Standard.Dds.ReturnCode_T;"
      & ASCII.LF
    & "   begin" & ASCII.LF
    & "         Code := Internal (Participant.GetInterface, "
      & "Type_Name.Data);" & ASCII.LF
    & "         Standard.DDS.Ret_Code_To_Exception" & ASCII.LF
    & "           (Code, ""unable to unregister type"");" & ASCII.LF
    & "   end Unregister_Type;" & ASCII.LF
    & ASCII.LF
    & "   -------------------" & ASCII.LF
    & "   -- Get_Type_Name --" & ASCII.LF
    & "   -------------------" & ASCII.LF
    & ASCII.LF
    & "   function Get_Type_Name" & ASCII.LF
    & "     return Standard.DDS.String is" & ASCII.LF
    & "      function Internal return Interfaces.C.Strings.chars_ptr;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_get_type_name"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      return Name : Standard.DDS.String do" & ASCII.LF
    & "         Name.Data := DDS_String_dup (Internal);" & ASCII.LF
    & "      end return;" & ASCII.LF
    & "   end Get_Type_Name;" & ASCII.LF
    & ASCII.LF
    & "   -----------------" & ASCII.LF
    & "   -- Create_Data --" & ASCII.LF
    & "   -----------------" & ASCII.LF
    & ASCII.LF
    & "   function Create_Data" & ASCII.LF
    & "     (AllocatePointers : in Boolean := True)" & ASCII.LF
    & "      return not null @TYPE@_Access" & ASCII.LF
    & "   is" & ASCII.LF
    & "      function Internal (AllocatePointers : in Boolean)"
      & ASCII.LF
    & "                         return @TYPE@_Access;" & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_create_data_ex"");" & ASCII.LF
    & "      Ret : @TYPE@_Access;" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Ret := Internal (AllocatePointers);" & ASCII.LF
    & "      if Ret = null then" & ASCII.LF
    & "         raise Storage_Error with ""Unable to create "" & ""@TYPE@"";"
      & ASCII.LF
    & "      else" & ASCII.LF
    & "         return Ret;" & ASCII.LF
    & "      end if;" & ASCII.LF
    & "   end Create_Data;" & ASCII.LF
    & ASCII.LF
    & "   -----------------" & ASCII.LF
    & "   -- Delete_Data --" & ASCII.LF
    & "   -----------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Delete_Data" & ASCII.LF
    & "     (A_Data         : in out @TYPE@_Access;" & ASCII.LF
    & "      DeletePointers : in Boolean := True)" & ASCII.LF
    & "   is" & ASCII.LF
    & "      function Internal (A_Data         : in @TYPE@_Access;"
      & ASCII.LF
    & "                         DeletePointers : in Boolean := True)"
      & ASCII.LF
    & "                         return Standard.DDS.ReturnCode_T;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_delete_data_ex"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception" & ASCII.LF
    & "        (Internal (A_Data, DeletePointers)," & ASCII.LF
    & "         ""Unable to delete data"");" & ASCII.LF
    & "      A_Data := null;" & ASCII.LF
    & "   end Delete_Data;" & ASCII.LF
    & ASCII.LF
    & "   ----------------" & ASCII.LF
    & "   -- Print_Data --" & ASCII.LF
    & "   ----------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Print_Data" & ASCII.LF
    & "     (A_Data : not null access constant @TYPE@)" & ASCII.LF
    & "   is" & ASCII.LF
    & "      procedure Internal (A_Data : not null access constant @TYPE@);"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_print_data"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Internal (A_Data);" & ASCII.LF
    & "   end Print_Data;" & ASCII.LF
    & ASCII.LF
    & "   ---------------" & ASCII.LF
    & "   -- Copy_Data --" & ASCII.LF
    & "   ---------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Copy_Data" & ASCII.LF
    & "     (Dest   : not null access @TYPE@;" & ASCII.LF
    & "      Source : not null access constant @TYPE@)" & ASCII.LF
    & "   is" & ASCII.LF
    & "      function Internal (Dest   : not null access @TYPE@;"
      & ASCII.LF
    & "                         Source : not null access constant @TYPE@)"
      & ASCII.LF
    & "                         return Standard.DDS.ReturnCode_T;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_copy_data"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception" & ASCII.LF
    & "        (Internal (Dest, Source)," & ASCII.LF
    & "         ""Unable to copy data"");" & ASCII.LF
    & "   end Copy_Data;" & ASCII.LF
    & ASCII.LF
    & "   ---------------------" & ASCII.LF
    & "   -- Initialize_Data --" & ASCII.LF
    & "   ---------------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Initialize_Data" & ASCII.LF
    & "     (Dest             : not null access @TYPE@;" & ASCII.LF
    & "      AllocatePointers : in Boolean := True)" & ASCII.LF
    & "   is" & ASCII.LF
    & "      function Internal (Dest             : not null access @TYPE@;"
      & ASCII.LF
    & "                         AllocatePointers : in Boolean := True)"
      & ASCII.LF
    & "                         return Standard.DDS.ReturnCode_T;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_initialize_data_ex"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception" & ASCII.LF
    & "        (Internal (Dest, AllocatePointers)," & ASCII.LF
    & "         ""Unable to initialize data"");" & ASCII.LF
    & "   end Initialize_Data;" & ASCII.LF
    & ASCII.LF
    & "   -------------------" & ASCII.LF
    & "   -- Finalize_Data --" & ASCII.LF
    & "   -------------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Finalize_Data" & ASCII.LF
    & "     (Dest           : not null access @TYPE@;" & ASCII.LF
    & "      DeletePointers : in Boolean := True)" & ASCII.LF
    & "   is" & ASCII.LF
    & "      function Internal (Dest           : not null access @TYPE@;"
      & ASCII.LF
    & "                         DeletePointers : in Boolean := True)"
      & ASCII.LF
    & "                         return Standard.DDS.ReturnCode_T;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_finalize_data_ex"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception" & ASCII.LF
    & "        (Internal (Dest, DeletePointers)," & ASCII.LF
    & "         ""Unable to finalize data"");" & ASCII.LF
    & "   end Finalize_Data;" & ASCII.LF
    & ASCII.LF
    & "   --------------" & ASCII.LF
    & "   -- Finalize --" & ASCII.LF
    & "   --------------" & ASCII.LF
    & ASCII.LF
    & "   procedure Finalize is" & ASCII.LF
    & "      function Internal return Standard.DDS.ReturnCode_T;"
      & ASCII.LF
    & "      pragma Import (C, Internal, "
      & """@MODL@_@TYPE@TypeSupport_finalize"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception (Internal, ""Unable to "
      & "finalize"");" & ASCII.LF
    & "   end Finalize;" & ASCII.LF
    & ASCII.LF
    & "begin" & ASCII.LF
    & "   Standard.DDS.DomainParticipant_Impl.Register_Type_Registration "
      & "(Register_Type'Access);" & ASCII.LF
    & "end @MODL@.@TYPE@_TypeSupport;" & ASCII.LF;

   procedure Emit_Typesupport
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String)
   is
      Base_Name : constant String :=
        To_Lower (Module_Name & "-" & Type_Name & "_typesupport");
      Spec_Text : constant String :=
        Substitute
          (Substitute (Typesupport_Spec_Template, "@MODL@", Module_Name),
           "@TYPE@", Type_Name);
      Body_Text : constant String :=
        Substitute
          (Substitute (Typesupport_Body_Template, "@MODL@", Module_Name),
           "@TYPE@", Type_Name);
   begin
      Self.Select_Output_File (Base_Name & ".ads", F_Ada_Spec);
      Self.Emit_Header (Idl_Path);
      Self.Put (Spec_Text);
      Self.Select_Output_File (Base_Name & ".adb", F_Ada_Body);
      Self.Emit_Header (Idl_Path);
      Self.Put (Body_Text);
   end Emit_Typesupport;

   ---------------------------------------------------------------------

   procedure Generate
     (Self     : in out Ada_RTI_Backend;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String)
   is
      use SU;

      procedure Emit_Module
        (D : S.Definition_Ref; Idl_Path : String);
      --  One module = module-spec, module-body, and per-struct files.

      procedure Emit_Module
        (D : S.Definition_Ref; Idl_Path : String)
      is
         Module_Name : constant String := To_String (D.Name);
         Module_Spec_Name : constant String :=
           To_Lower (Module_Name) & ".ads";
         Module_Body_Name : constant String :=
           To_Lower (Module_Name) & ".adb";
      begin
         --  Pass 1: the module spec.
         Self.Select_Output_File (Module_Spec_Name, F_Ada_Spec);
         Self.Emit_Header (Idl_Path);
         Self.Put_Line ("pragma Extensions_Allowed (On);");
         Self.Put_Line ("with DDS;");
         Self.Put_Line ("with DDS.Sequences_Generic;");
         Self.New_Line;
         Self.New_Line;
         Self.Put_Line
           ("pragma Style_Checks (off); --  Since this is autogenerated "
              & "code.");
         Self.Put_Line ("package  " & Module_Name & " is");
         Self.New_Line;
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               case Sub.Kind is
                  when D_Enum =>
                     Self.Emit_Enum_Block (Module_Name, Sub);
                  when D_Struct =>
                     Self.Emit_Struct_Block (Module_Name, Sub);
                  when others =>
                     raise Backend_Error
                       with "unsupported definition kind "
                         & S.Definition_Kind_T'Image (Sub.Kind)
                         & " in module " & Module_Name;
               end case;
            end;
         end loop;
         Self.New_Line;
         Self.Put_Line ("end " & Module_Name & ";");
         Self.New_Line;

         --  Pass 2: the module body.
         Self.Select_Output_File (Module_Body_Name, F_Ada_Body);
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
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               case Sub.Kind is
                  when D_Enum | D_Struct =>
                     Self.Emit_Body_Initialize
                       (Module_Name, To_String (Sub.Name));
                     Self.Emit_Body_Finalize
                       (Module_Name, To_String (Sub.Name));
                     Self.Emit_Body_Copy
                       (Module_Name, To_String (Sub.Name));
                  when others =>
                     null;
               end case;
            end;
         end loop;
         Self.Put_Line (" end " & Module_Name & ";");
         Self.New_Line;

         --  Pass 3: per-struct typesupport / datareader / datawriter.
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               if Sub.Kind = D_Struct then
                  Self.Emit_Typesupport
                    (Module_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataReader_Spec
                    (Module_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataWriter_Spec
                    (Module_Name, To_String (Sub.Name), Idl_Path);
               end if;
            end;
         end loop;
      end Emit_Module;

   begin
      for I in Tree.First_Index .. Tree.Last_Index loop
         declare
            D : constant S.Definition_Ref := Tree (I);
         begin
            if D.Kind = D_Module then
               Emit_Module (D, Idl_Path);
            else
               raise Backend_Error
                 with "only modules are supported by this back-end";
            end if;
         end;
      end loop;
   end Generate;

end IDL2Lang.Backends.Ada_RTI;