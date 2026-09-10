------------------------------------------------------------------------------
--  IDL2Lang.Backends.Ada_RTI -- body
--
--  Byte-parity transcription of rtiddsgen 4.7.0's Ada output.  The
--  typesupport body is emitted from the whole-word token template of
--  the oracle (Point -> <Type>), matching rtiddsgen's own template
--  engine.
------------------------------------------------------------------------------

with Ada.Directories;
with Ada.Text_IO;
with Ada.Strings.Unbounded;

package body IDL2Lang.Backends.Ada_RTI is

   package SU renames Ada.Strings.Unbounded;

   --  String vectors for the external-with scan.
   function Eq_US (L, R : SU.Unbounded_String) return Boolean is
     (SU."=" (L, R));
   package US_List is new Ada.Containers.Vectors
     (Positive, SU.Unbounded_String, Eq_US);
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
   function Dashify (S : String) return String;
   --  Dotted Ada package path -> dash file prefix ("a.b.c" -> "a-b-c").

   function Dashify (S : String) return String is
      R : String := S;
   begin
      for I in R'Range loop
         if R (I) = '.' then
            R (I) := '-';
         end if;
      end loop;
      return R;
   end Dashify;

   function Underscorify (S : String) return String is
      R : String := S;
   begin
      for I in R'Range loop
         if R (I) = '.' then
            R (I) := '_';
         end if;
      end loop;
      return R;
   end Underscorify;

   function C_Join (Prefix, Rest : String) return String is
     (if Prefix = "" then Rest
      elsif Prefix (Prefix'Last) = '_'
      then Underscorify (Prefix) & Rest
      else Underscorify (Prefix) & "_" & Rest);
   --  C name join: "" at file scope means no prefix at all (oracle
   --  Constants: "MYLONG_initialize", "MYLONG_get_typecode").

   function Dotted_Image (Name : S.Scoped_Name_T) return String;
   --  Scoped name with Ada dots between parts ("vtypes_test.base.p").

   function Dotted_Image (Name : S.Scoped_Name_T) return String is
      Result : SU.Unbounded_String;
   begin
      for I in Name.Parts.First_Index .. Name.Parts.Last_Index loop
         if I > Name.Parts.First_Index then
            SU.Append (Result, '.');
         end if;
         SU.Append (Result, SU.To_String (Name.Parts (I)));
      end loop;
      return SU.To_String (Result);
   end Dotted_Image;

   function Colons (S : String) return String is
      --  Each dot becomes TWO colons (Ada scope -> DDS scope).
      R2 : String (1 .. 2 * S'Length) := (others => ' ');
      N : Natural := 0;
   begin
      for I in S'Range loop
         if S (I) = '.' then
            N := N + 2;
            R2 (N - 1 .. N) := "::";
         else
            N := N + 1;
            R2 (N) := S (I);
         end if;
      end loop;
      return R2 (1 .. N);
   end Colons;

   --  Const-expression rendering (rtiddsgen): literals bare, scoped
   --  names wrapped in parens, operators juxtaposed without spaces
   --  (oracle Constants.idl: "100+23", "2.0*(PI)", "(PI)+(PI2)").
   function Const_Image (E : S.Expression_T) return String is

      function Operand (E2 : S.Expression_T) return String is
      begin
         case E2.Kind is
            when S.E_Scoped_Name =>
               return "(" & S.Image (E2.Name) & ")";
            when S.E_Integer | S.E_Floating_Point | S.E_Fixed_Point
               | S.E_Character | S.E_Wide_Character | S.E_String
               | S.E_Wide_String | S.E_Boolean =>
               return SU.To_String (E2.Literal_Text);
            when others =>
               return Const_Image (E2);
         end case;
      end Operand;

      function Op_Spelling (Kind : S.Expr_Kind_T) return String is
        (case Kind is
            when S.E_Or          => "|",
            when S.E_Xor         => "^",
            when S.E_And         => "&",
            when S.E_Shift_Left  => "<<",
            when S.E_Shift_Right => ">>",
            when S.E_Add         => "+",
            when S.E_Subtract    => "-",
            when S.E_Multiply    => "*",
            when S.E_Divide      => "/",
            when S.E_Remainder   => "%",
            when others          => "?");

   begin
      case E.Kind is
         when S.E_Scoped_Name =>
            return "(" & S.Image (E.Name) & ")";
         when S.E_Integer | S.E_Floating_Point | S.E_Fixed_Point
            | S.E_Character | S.E_Wide_Character | S.E_String
            | S.E_Wide_String | S.E_Boolean =>
            return SU.To_String (E.Literal_Text);
         when S.E_Unary_Plus =>
            return "+" & Operand (E.Left.all);
         when S.E_Unary_Minus =>
            return "-" & Operand (E.Left.all);
         when S.E_Complement =>
            return "~" & Operand (E.Left.all);
         when others =>
            return Operand (E.Left.all) & Op_Spelling (E.Kind)
              & Operand (E.Right.all);
      end case;
   end Const_Image;

   --  Array bound rendering: integer literals bare, everything else
   --  (scoped refs, expressions) module-qualified and parenthesized
   --  (oracle ArrayRanges: "(1..(hello.SIZE))" vs "(1..24)").
   function Bound_Image (Module_Name : String; E : S.Expression_T)
     return String is
      use type S.Expr_Kind_T;
      function Operand (E2 : S.Expression_T) return String is
      begin
         case E2.Kind is
            when S.E_Scoped_Name =>
               declare
                  N_Parts : constant Natural :=
                    E2.Name.Parts.Last_Index;
               begin
                  if N_Parts > 1 then
                     return "(" & Dotted_Image (E2.Name) & ")";
                  elsif E2.Name.Absolute then
                     return "(" & S.Image (E2.Name) & ")";
                  else
                     return "(" & Module_Name & "."
                       & S.Image (E2.Name) & ")";
                  end if;
               end;
            when S.E_Integer | S.E_Floating_Point | S.E_Fixed_Point
               | S.E_Character | S.E_Wide_Character | S.E_String
               | S.E_Wide_String | S.E_Boolean =>
               return SU.To_String (E2.Literal_Text);
            when others =>
               return Operand (E2);
         end case;
      end Operand;
   begin
      if E.Kind = S.E_Integer then
         return SU.To_String (E.Literal_Text);
      else
         return Operand (E);
      end if;
   end Bound_Image;

   --  The Ada type name of a member's element type for arrays:
   --  primitives map to Standard.DDS.<Kind>_Array; scoped names are
   --  used verbatim (multi-part names carry their own scope).
   function Array_Elem (Module_Name : String; Typ : S.Type_Spec_T)
     return String is
   begin
      case Typ.Kind is
         when S.T_Scoped_Name =>
            declare
               N_Parts : constant Natural :=
                 Typ.Type_Name.Parts.Last_Index;
            begin
               if N_Parts > 1 then
                  return Dotted_Image (Typ.Type_Name);
               elsif Typ.Type_Name.Absolute then
                  return S.Image (Typ.Type_Name);
               else
                  return Module_Name & "."
                    & S.Image (Typ.Type_Name);
               end if;
            end;
         when others =>
            return DDS_Type (Typ.Kind);
      end case;
   end Array_Elem;

   --  Set when the previous spec block was a bare const line: the
   --  const's trailing " " line doubles as the next block's separator
   --  (oracle ArrayRanges: "SIZE : constant ... := 10;" then one ' '
   --  line then the World_T block).
   Skip_Next_Separator : Boolean := False;

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
        ("--  This file was generated from "
         & Ada.Directories.Simple_Name (Idl_Path));
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
                       & "_Get_TypeCode, """ & Underscorify (Module_Name) & "_"
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

   procedure Emit_Const_Line
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref)
   is
      --  One const line (oracle ArrayRanges/Constants):
      --  "SIZE : constant Standard.DDS.Long := 10;" (no indent), or
      --  with the typedef'd/module type qualified:
      --  "LONG_CONST_123 : constant Constants_IDL_File.MYLONG := 100+23;"
      --  String consts:
      --  "MY_STRING : constant Standard.DDS.String :=
      --   Standard.DDS.To_DDS_String (" Hello World!");"
      C_Name : constant String := SU.To_String (Def.Name);
      C_Type : constant String :=
        (if Def.Const_Type.Kind = T_Scoped_Name
           then (declare
                    N_Parts : constant Natural :=
                      Def.Const_Type.Type_Name.Parts.Last_Index;
                 begin
                    (if N_Parts > 1
                       then Dotted_Image (Def.Const_Type.Type_Name)
                     elsif Def.Const_Type.Type_Name.Absolute
                       then S.Image (Def.Const_Type.Type_Name)
                     else Module_Name & "."
                          & S.Image (Def.Const_Type.Type_Name)))
         else DDS_Type (Def.Const_Type.Kind));
   begin
      if Def.Const_Type.Kind = T_String
        or else Def.Const_Type.Kind = T_Wide_String
      then
         Self.Put_Line
           (C_Name & " : constant Standard.DDS.String := "
              & "Standard.DDS.To_DDS_String ("
              & Const_Image (Def.Const_Value.all) & ");");
      else
         Self.Put_Line
           (C_Name & " : constant " & C_Type & " := "
              & Const_Image (Def.Const_Value.all) & ";");
      end if;
   end Emit_Const_Line;

   procedure Emit_Typedef_Block
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      C_Prefix : String := "";
      Skip_Sep : Boolean := False)
   is
      --  Typedef block (oracle Constants/Global):
      --  "    type N is new <mapped>;" (4-space indent on the first
      --  line only), then the standard block at 3-space indents, same
      --  shape as a struct's Access/Array/TypeCode/Init/Final/Copy/Seq
      --  block.  Array declarators render "type N is array (1..4) of
      --  <Elem>;" with two trailing spaces.
      Dcl : constant S.Declarator_T :=
        Def.Typedef_Declarators.Element
          (Def.Typedef_Declarators.First_Index);
      T_Name : constant String := SU.To_String (Dcl.Name);

      function Ada_Ref return String is
      begin
         if Def.Typedef_Type.Kind = T_Scoped_Name then
            declare
               N_Parts : constant Natural :=
                 Def.Typedef_Type.Type_Name.Parts.Last_Index;
            begin
               if N_Parts > 1 then
                  return Dotted_Image (Def.Typedef_Type.Type_Name);
               elsif Def.Typedef_Type.Type_Name.Absolute then
                  return S.Image (Def.Typedef_Type.Type_Name);
               else
                  return Module_Name & "."
                    & S.Image (Def.Typedef_Type.Type_Name);
               end if;
            end;
         elsif Def.Typedef_Type.Kind = T_Sequence then
            if Def.Typedef_Type.Element_Type.Kind = T_Scoped_Name then
               return Array_Elem (Module_Name,
                        Def.Typedef_Type.Element_Type.all)
                 & "_Seq.Sequence";
            end if;
            return DDS_Seq (Def.Typedef_Type.Element_Type.Kind);
         else
            return DDS_Type (Def.Typedef_Type.Kind);
         end if;
      end Ada_Ref;
   begin
      if not Skip_Sep then
         Self.Put_Line (" ");
      end if;
      if not Dcl.Array_Dims.Is_Empty then
         if Dcl.Array_Dims.Last_Index > 1 then
            raise Backend_Error
              with "multi-dimensional arrays are a later increment";
         end if;
         Self.Put_Line
           ("    type " & T_Name & " is array (1.."
              & Bound_Image (Module_Name, Dcl.Array_Dims (1).all) & ") of "
              & (if Def.Typedef_Type.Kind = T_Sequence then "aliased "
                 else "")
              & Ada_Ref & ";  ");
      else
         Self.Put_Line ("    type " & T_Name & " is new " & Ada_Ref & ";");
      end if;
      Self.Put_Line ("   type " & T_Name & "_Access is access all "
                       & T_Name & ";");
      Self.Put_Line ("   pragma No_Strict_Aliasing (" & T_Name
                       & "_Access);");
      Self.Put_Line ("   type " & T_Name & "_Array is array "
                       & "(Standard.DDS.Natural range <>) of aliased "
                       & T_Name & ";");
      Self.Put_Line ("   pragma Convention (C, " & T_Name & "_Array);");
      Self.Put_Line (" ");
      Self.Put_Line ("   function " & T_Name
                       & "_Get_TypeCode return Standard.DDS.TypeCode_Access;");
      Self.Put_Line ("   pragma Import (C, " & T_Name
                       & "_Get_TypeCode, """ & C_Prefix & T_Name
                       & "_get_typecode"");");
      Self.New_Line;
      Self.Put_Line ("   procedure Initialize (This : in out " & T_Name
                       & ");");
      Self.Put_Line ("   procedure Finalize (This : in out " & T_Name
                       & ");");
      Self.Put_Line ("   procedure Copy (Dst : in out " & T_Name & ";");
      Self.Put_Line ("                   Src : in " & T_Name & ");");
      Self.Put_Line ("                 ");
      Self.Put_Line ("   package " & T_Name & "_Seq is new "
                       & "Standard.DDS.Sequences_Generic");
      Self.Put_Line ("   (" & Module_Name & "." & T_Name & ",");
      Self.Put_Line ("    " & Module_Name & "." & T_Name & "_Access,");
      Self.Put_Line ("    Standard.DDS.Natural,");
      Self.Put_Line ("    1,");
      Self.Put_Line ("    " & Module_Name & "." & T_Name & "_Array);"
                       & "               ");
   end Emit_Typedef_Block;

   procedure Emit_Union_Block
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref)
   is
      --  Union block (oracle Demo.idl):
      --    ' Demo_TypeName : ... ("...::Demo");'   (2-space indent)
      --    '   type U_Demo is record'              (union = flattened
      --      struct of ALL case members in source order, standard
      --      member rendering)
      --    '   end record;'
      --    '     pragma Convention (C, U_Demo);'   (5-space indent)
      --    ' '                                     (single space)
      --    '    type Demo is record'               (4-space indent)
      --    '     d : <Switch>;'                    (5-space indent)
      --    '     u : U_Demo;'                      (5-space indent)
      --    '    end record;'                       (4-space indent)
      --    ' '  (single space)
      --  then the standard 3-space block for Demo.
      Type_Name : constant String := SU.To_String (Def.Name);
      Switch_Name : constant String :=
        (if Def.Switch_Type.Kind = T_Scoped_Name
           then (declare
                    N_Parts : constant Natural :=
                      Def.Switch_Type.Type_Name.Parts.Last_Index;
                 begin
                    (if N_Parts > 1
                       then Dotted_Image (Def.Switch_Type.Type_Name)
                     elsif Def.Switch_Type.Type_Name.Absolute
                       then S.Image (Def.Switch_Type.Type_Name)
                     else Module_Name & "."
                          & S.Image (Def.Switch_Type.Type_Name)))
         else DDS_Type (Def.Switch_Type.Kind));
   begin
      --  Separator (see Emit_Struct_Block): skipped when the
      --  preceding const already emitted its ' ' line.
      if Skip_Next_Separator then
         Skip_Next_Separator := False;
      else
         Self.Put_Line (" ");
      end if;
      Self.Put_Line
        ("  " & Type_Name & "_TypeName : aliased Standard.DDS.String :="
           & " Standard.DDS.To_DDS_String  (""" & Colons (Module_Name)
           & "::" & Type_Name & """);");
      Self.Put_Line ("   type U_" & Type_Name & " is record");
      for I in Def.Cases.First_Index .. Def.Cases.Last_Index loop
         declare
            C : constant S.Union_Case_T := Def.Cases (I);
            Dcl : constant S.Declarator_T := C.Element_Name;
            M_Name : constant String := SU.To_String (Dcl.Name);
            Elem : constant S.Type_Spec_T := C.Element_Type.all;
         begin
            if not Dcl.Array_Dims.Is_Empty then
               if Dcl.Array_Dims.Last_Index > 1 then
                  raise Backend_Error
                    with "multi-dimensional arrays are a later increment";
               end if;
               declare
                  Elem_Name : constant String :=
                    Array_Elem (Module_Name, Elem);
                  Bound : constant String :=
                    Bound_Image (Module_Name, Dcl.Array_Dims (1).all);
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  " & Elem_Name
                       & "_Array(1.." & Bound & ");");
               end;
            elsif Elem.Kind = T_Sequence then
               if Elem.Element_Type.Kind = T_Scoped_Name then
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  "
                       & Array_Elem (Module_Name,
                           Elem.Element_Type.all)
                       & "_Seq.Sequence;");
               else
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  "
                       & DDS_Seq (Elem.Element_Type.Kind) & ";");
               end if;
            elsif Elem.Kind = T_Scoped_Name then
               declare
                  N_Parts : constant Natural :=
                    Elem.Type_Name.Parts.Last_Index;
                  Ref : constant String :=
                    (if N_Parts > 1
                       then Dotted_Image (Elem.Type_Name)
                     elsif Elem.Type_Name.Absolute
                       then S.Image (Elem.Type_Name)
                     else Module_Name & "." & S.Image (Elem.Type_Name));
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased " & Ref & ";    ");
               end;
            elsif Elem.Kind = T_String
              or else Elem.Kind = T_Wide_String
            then
               declare
                  Bound : constant String :=
                    (if Elem.String_Bound = null
                       then "255"
                       else Bound_Image (Module_Name, Elem.String_Bound.all));
                  W : constant String :=
                    (if Elem.Kind = T_Wide_String then "Wide_" else "");
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased Standard.DDS."
                       & W & "String; --  maximum length = (" & Bound
                       & ")    ");
               end;
            else
               Self.Put_Line
                 ("    " & M_Name & " : aliased " & DDS_Type (Elem.Kind)
                    & ";    ");
            end if;
         end;
      end loop;
      Self.Put_Line ("   end record;");
      Self.Put_Line ("     pragma Convention (C, U_" & Type_Name & ");");
      Self.Put_Line (" ");
      Self.Put_Line ("    type " & Type_Name & " is record");
      Self.Put_Line ("     d : " & Switch_Name & ";");
      Self.Put_Line ("     u : U_" & Type_Name & ";");
      Self.Put_Line ("    end record;");
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
      Self.Put_Line ("   function " & Type_Name
                       & "_Get_TypeCode return Standard.DDS.TypeCode_Access;");
      Self.Put_Line ("   pragma Import (C, " & Type_Name
                       & "_Get_TypeCode, """ & C_Join (Module_Name,
                       Type_Name & "_get_typecode") & """);");
      Self.New_Line;
      Self.Put_Line ("   procedure Initialize (This : in out "
                       & Type_Name & ");");
      Self.Put_Line ("   procedure Finalize (This : in out "
                       & Type_Name & ");");
      Self.Put_Line ("   procedure Copy (Dst : in out " & Type_Name & ";");
      Self.Put_Line ("                   Src : in " & Type_Name & ");");
      Self.Put_Line ("                 ");
      Self.Put_Line ("   package " & Type_Name & "_Seq is new "
                       & "Standard.DDS.Sequences_Generic");
      Self.Put_Line ("   (" & Module_Name & "." & Type_Name & ",");
      Self.Put_Line ("    " & Module_Name & "." & Type_Name & "_Access,");
      Self.Put_Line ("    Standard.DDS.Natural,");
      Self.Put_Line ("    1,");
      Self.Put_Line ("    " & Module_Name & "." & Type_Name & "_Array);"
                       & "               ");
   end Emit_Union_Block;

   procedure Emit_Struct_Block
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Def : S.Definition_Ref;
      Member_Type_Name : String := "")
   is
      Type_Name : constant String := SU.To_String (Def.Name);
   begin
      --  Separator: a line holding a single space (see the Hello and
      --  Shapes oracles).  Skipped when the previous block was a
      --  const (the const already emitted its own trailing ' ' line).
      if Skip_Next_Separator then
         Skip_Next_Separator := False;
      else
         Self.Put_Line (" ");
      end if;
      --  Quirk: 2-space indent for the TypeName line (not 3).
      Self.Put_Line
        ("  " & Type_Name & "_TypeName : aliased Standard.DDS.String :="
           & " Standard.DDS.To_DDS_String  (""" & Colons (Module_Name) & "::"
           & Type_Name & """);");
      Self.Put_Line ("   type " & Type_Name & " is record");
      --  A valuetype with a base renders the inherited member
      --  first ("parent : aliased <Base>;" - oracle types.idl
      --  MyValueType_extend) when the base valuetype is defined
      --  in this same file (included-IDL bases cannot be
      --  resolved here; rtiddsgen merges them during include
      --  processing).
      if Def.Kind = D_Value_Type
        and then Def.Has_Base_Type
      then
         declare
            Base_Image : constant String :=
              (if Def.Base_Type.Absolute
                 then S.Image (Def.Base_Type)
               else Dotted_Image (Def.Base_Type));
            --  The module that DECLARES the base is the current
            --  module (in-file base): qualify with the full chain
            --  by dropping the chain's last component from the
            --  prefix when the base image already carries it.
            Dot_In_Base : constant Natural :=
              SU.Index (SU.To_Unbounded_String (Base_Image), ".");
            Base_First_Part : constant String :=
              (if Dot_In_Base > 0
                 then Base_Image (Base_Image'First .. Dot_In_Base - 1)
                 else Base_Image);
            Chain_Last_Start : constant Natural :=
              (if SU.Index (SU.To_Unbounded_String (Module_Name), ".")
                 > 0
               then (if Module_Name'Last - Base_First_Part'Length
                          + 1 >= Module_Name'First
                        then Module_Name'Last - Base_First_Part'Length
                               + 1
                        else Module_Name'First)
                 else Module_Name'First);
            Base_Ref : constant String :=
              (if Module_Name = "" then ""
               else Module_Name & "." & SU.To_String
                      (Def.Base_Type.Parts.Last_Element));
         begin
            if Base_Ref /= "" then
               Self.Put_Line
                 ("    parent : aliased " & Base_Ref & ";");
            end if;
         end;
      end if;
      declare
         --  A valuetype's state members live in Value_Members; a
         --  struct's in Members (oracle base.idl: basetrack_t).
         Mems : constant S.Member_Vectors.Vector :=
           (if Def.Kind = D_Value_Type
              then Def.Value_Members else Def.Members);
      begin
      for I in Mems.First_Index .. Mems.Last_Index loop
         declare
            Decls : S.Declarator_Vectors.Vector renames
              Mems (I).Declarators;
         begin
         for C in Decls.Iterate loop
            declare
               M : constant S.Member_T := Mems (I);
               Dcl : constant S.Declarator_T := Decls (C);
               M_Name : constant String := SU.To_String (Dcl.Name);
     --  Interface-typed members are DROPPED from the record
     --  (oracle Global.idl: "Interface1 member1;" produces no
     --  line; only member2 survives).  We cannot always know a
     --  name is an interface, but the known-interfaces set
     --  passed by Emit_Module covers the corpus case.
     Is_Interface_Member : constant Boolean :=
       M.Member_Type.Kind = T_Scoped_Name
         and then Member_Type_Name /= ""
         and then SU.To_String
                    (M.Member_Type.Type_Name.Parts.Element
                       (M.Member_Type.Type_Name.Parts.Last_Index))
                  = Member_Type_Name;
         begin
         if Is_Interface_Member then
            null;
         elsif not Dcl.Array_Dims.Is_Empty then
            if Dcl.Array_Dims.Last_Index > 1 then
               raise Backend_Error
                 with "multi-dimensional arrays are a later increment";
            end if;
            if M.Member_Type.Kind = T_Scoped_Name then
               declare
                  N_Parts : constant Natural :=
                    M.Member_Type.Type_Name.Parts.Last_Index;
                  Ref : constant String :=
                    (if N_Parts > 1
                       then Dotted_Image (M.Member_Type.Type_Name)
                     else Module_Name & "."
                            & Dotted_Image (M.Member_Type.Type_Name));
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  " & Ref
                       & "_Array(1.." & Bound_Image (Module_Name,
                            Dcl.Array_Dims (1).all) & ");");
               end;
            else
               Self.Put_Line
                 ("    " & M_Name & " : aliased  "
                    & DDS_Type (M.Member_Type.Kind)
                    & "_Array(1.."
                    & Bound_Image (Module_Name, Dcl.Array_Dims (1).all)
                    & ");");
            end if;
         elsif M.Member_Type.Kind = T_Sequence then
            if M.Member_Type.Element_Type.Kind = T_Scoped_Name then
               declare
                  N_Parts : constant Natural :=
                    M.Member_Type.Element_Type.Type_Name.Parts.Last_Index;
                  Ref : constant String :=
                    (if N_Parts > 1
                       then Dotted_Image
                              (M.Member_Type.Element_Type.Type_Name)
                     elsif M.Member_Type.Element_Type.Type_Name.Absolute
                       then S.Image (M.Member_Type.Element_Type.Type_Name)
                     else Module_Name & "."
                            & Dotted_Image
                                (M.Member_Type.Element_Type.Type_Name));
               begin
                  Self.Put_Line
                    ("    " & M_Name & " : aliased  "
                       & Ref & "_Seq.Sequence;");
               end;
            else
               Self.Put_Line
                 ("    " & M_Name & " : aliased  "
                    & DDS_Seq (M.Member_Type.Element_Type.Kind) & ";");
            end if;
         elsif M.Member_Type.Kind = T_Scoped_Name then
            declare
               N_Parts : constant Natural :=
                 M.Member_Type.Type_Name.Parts.Last_Index;
               Ref : constant String :=
                 (if N_Parts > 1
                    then Dotted_Image (M.Member_Type.Type_Name)
                  elsif M.Member_Type.Type_Name.Absolute
                    then S.Image (M.Member_Type.Type_Name)
                  else Module_Name & "."
                         & S.Image (M.Member_Type.Type_Name));
            begin
               Self.Put_Line
                 ("    " & M_Name & " : aliased " & Ref & ";    ");
            end;
         elsif M.Member_Type.Kind = T_String
           or else M.Member_Type.Kind = T_Wide_String
         then
            declare
               Bound : constant String :=
                 (if M.Member_Type.String_Bound = null
                    then "255"
                    else Const_Image
                           (M.Member_Type.String_Bound.all));
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
            if M.Is_Pointer then
               Self.Put_Line
                 ("    " & M_Name & " : access "
                    & DDS_Type (M.Member_Type.Kind) & ";");
            else
               Self.Put_Line
                 ("    " & M_Name & " : aliased "
                    & DDS_Type (M.Member_Type.Kind) & ";    ");
            end if;
         end if;
         end;
      end loop;
      end;
      end loop;
      end;
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
                       & "_Get_TypeCode, """ & Underscorify (Module_Name) & "_"
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
      Self.Put_Line ("      pragma Import (C, Internal, """ & C_Join (Module_Name,
                       Type_Name & "_initialize") & """);");
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
      Self.Put_Line ("      pragma Import (C, Internal, """ & C_Join (Module_Name,
                       Type_Name & "_finalize_ex") & """);");
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
      Self.Put_Line ("      pragma Import (C, Internal, """ & C_Join (Module_Name,
                       Type_Name & "_copy") & """);");
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
        To_Lower (Dashify (Module_Name) & "-" & Type_Name & "_datareader") & ".ads";
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
        To_Lower (Dashify (Module_Name) & "-" & Type_Name & "_datawriter") & ".ads";
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
    & "package @AMODL@.@TYPE@_TypeSupport is" & ASCII.LF
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
    & "end @AMODL@.@TYPE@_TypeSupport;" & ASCII.LF;

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
    & "with @AMODL@.@TYPE@_DataReader;" & ASCII.LF
    & "with @AMODL@.@TYPE@_DataWriter;" & ASCII.LF
    & ASCII.LF
    & "package body @AMODL@.@TYPE@_TypeSupport is" & ASCII.LF
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
    & "      return @AMODL@.@TYPE@_DataReader.CreateTypedI;" & ASCII.LF
    & "   end  Create_TypedDataReaderI;" & ASCII.LF
    & ASCII.LF
    & "   procedure Destroy_TypedDataReaderI" & ASCII.LF
    & "     (Self   : access Ref;" & ASCII.LF
    & "      Reader : in out Standard.DDS.DataReader.Ref_Access) is"
      & ASCII.LF
    & "   begin" & ASCII.LF
    & "      @AMODL@.@TYPE@_DataReader.DestroyTypedI (Reader);" & ASCII.LF
    & "   end  Destroy_TypedDataReaderI;" & ASCII.LF
    & ASCII.LF
    & "   function Create_TypedDataWriterI" & ASCII.LF
    & "     (Self : access Ref) return Standard.DDS.DataWriter.Ref_Access"
      & " is" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      return @AMODL@.@TYPE@_DataWriter.CreateTypedI;" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_get_or_delete_instanceI"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@Plugin_new"");" & ASCII.LF
    & ASCII.LF
    & "      procedure InternalDeletePlugin" & ASCII.LF
    & "        (plugin : access PRESTypePlugin);" & ASCII.LF
    & "      pragma Import (C, InternalDeletePlugin, "
      & """@CMODL@_@TYPE@Plugin_delete"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_unregister_type"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_get_type_name"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_create_data_ex"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_delete_data_ex"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_print_data"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_copy_data"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_initialize_data_ex"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_finalize_data_ex"");" & ASCII.LF
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
      & """@CMODL@_@TYPE@TypeSupport_finalize"");" & ASCII.LF
    & "   begin" & ASCII.LF
    & "      Standard.DDS.Ret_Code_To_Exception (Internal, ""Unable to "
      & "finalize"");" & ASCII.LF
    & "   end Finalize;" & ASCII.LF
    & ASCII.LF
    & "begin" & ASCII.LF
    & "   Standard.DDS.DomainParticipant_Impl.Register_Type_Registration "
      & "(Register_Type'Access);" & ASCII.LF
    & "end @AMODL@.@TYPE@_TypeSupport;" & ASCII.LF;

   procedure Emit_Typesupport
     (Self : in out Ada_RTI_Backend;
      Module_Name : String;
      Type_Name : String;
      Idl_Path : String)
   is
      Base_Name : constant String :=
        To_Lower (Dashify (Module_Name) & "-" & Type_Name & "_typesupport");
      Spec_Text : constant String :=
        Substitute
          (Substitute
             (Substitute
                (Substitute (Typesupport_Spec_Template, "@AMODL@",
                             Module_Name),
                 "@MODL@", Underscorify (Module_Name)),
              "@CMODL@", Underscorify (Module_Name)),
           "@TYPE@", Type_Name);
      Body_Text : constant String :=
        Substitute
          (Substitute
             (Substitute
                (Substitute (Typesupport_Body_Template, "@AMODL@",
                             Module_Name),
                 "@MODL@", Underscorify (Module_Name)),
              "@CMODL@", Underscorify (Module_Name)),
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

      --  Ada package path of the enclosing scope, e.g. "a.b.c" for a
      --  type at module a/b/c, "" for file-level definitions.  The
      --  C-level prefix is the same path underscored ("a_b_c") --
      --  rtiddsgen derives both from the nested module chain.
      Scope_Ada : SU.Unbounded_String := SU.Null_Unbounded_String;
      --  The underscored C prefix including the trailing '_' when
      --  non-empty ("a_b_c_"), "" at file level.
      Scope_C : SU.Unbounded_String := SU.Null_Unbounded_String;
      --  True when the current module has already been recursed into
      --  (its spec/body/typesupport files exist).
      Type_Count_In_Scope : Natural := 0;

      procedure Emit_Module
        (D : S.Definition_Ref; Idl_Path : String);
      --  One module = module-spec, module-body, and per-type files.
      --  Nested modules recurse: every level gets its own spec; only
      --  levels that directly declare types get a body (the oracle:
      --  a.ads, a-b.ads empty; a-b-c.ads + a-b-c.adb for the leaf).

      --  External-with scan: scoped-name types referenced by members
   --  or typedefs whose dotted scope is not local to this file
   --  (an included IDL's types, e.g. org.omg.time) pull a
   --  "with <dotted-scope>;" line (oracle hcm_common).  Library
   --  units (DDS/Standard/RTI/Interfaces) are excluded.
   procedure Collect_External_Scopes
     (Defs : S.Definition_Vectors.Vector;
      Scope_Ada_Prefix : String;
      Seen : in out US_List.Vector)
   is
      procedure Consider (N : S.Scoped_Name_T) is
         Dotted : constant String := Dotted_Image (N);
         N_Parts : constant Natural := N.Parts.Last_Index;
         Name_Len : constant Natural :=
           SU.Length (N.Parts.Last_Element);
         Dot : constant Natural := SU.Index
           (SU.To_Unbounded_String (Dotted), ".");
      begin
         if Dot = 0 then
            return;
         end if;
         declare
            Head : constant String := Dotted (Dotted'First .. Dot - 1);
            --  Full scope of the named type: every part but the
            --  last ("vtypes_test::base::basetrack_t" ->
            --  "vtypes_test.base").
            Scope_Only : constant String :=
              (if N_Parts > 1
                 then Dotted (Dotted'First .. Dotted'Last - Name_Len - 1)
                 else Dotted);
         begin
            if Head = "DDS" or else Head = "Standard"
              or else Head = "RTI" or else Head = "Interfaces"
            then
               return;
            end if;
            if Scope_Ada_Prefix /= ""
              and then Dotted'Length > Scope_Ada_Prefix'Length
              and then Dotted (Dotted'First
                .. Dotted'First + Scope_Ada_Prefix'Length - 1)
                = Scope_Ada_Prefix
            then
               return;
            end if;
            for K of Seen loop
               if SU.To_String (K) = Scope_Only then
                  return;
               end if;
            end loop;
            --  A scope whose name is the LAST component of the
            --  current chain is local (rtiddsgen renders the type
            --  unqualified in that module: types.idl 'Key' ->
            --  with-scope = the full chain).
            if Scope_Ada_Prefix'Length > Scope_Only'Length + 1
              and then Scope_Ada_Prefix
                (Scope_Ada_Prefix'Last - Scope_Only'Length + 1
                 .. Scope_Ada_Prefix'Last) = Scope_Only
            then
               return;
            end if;
            US_List.Append (Seen,
              SU.To_Unbounded_String (Scope_Only));
         end;
      end Consider;
   begin
      for D of Defs loop
         if D.Kind = S.D_Struct or else D.Kind = S.D_Value_Type then
            declare
               Mems : constant S.Member_Vectors.Vector :=
                 (if D.Kind = S.D_Value_Type
                    then D.Value_Members else D.Members);
            begin
               for M of Mems loop
                  if M.Member_Type.Kind = S.T_Scoped_Name then
                     Consider (M.Member_Type.Type_Name);
                  end if;
               end loop;
            end;
         elsif D.Kind = S.D_Typedef then
            if D.Typedef_Type.Kind = S.T_Scoped_Name then
               Consider (D.Typedef_Type.Type_Name);
            end if;
         end if;
         --  A valuetype's base type may come from an included IDL
         --  (oracle twod: valuetype twod_track_t :
         --  vtypes_test::base::basetrack_t -> with
         --  vtypes_test.base;).
         if D.Kind = S.D_Value_Type
           and then D.Has_Base_Type
         then
            Consider (D.Base_Type);
         end if;
      end loop;
   end Collect_External_Scopes;

   procedure Emit_Module_From_List
        (Body_List : S.Definition_Vectors.Vector;
         Package_Name : String;
         Idl_Path : String);
      --  C_Prefix for the file package is "" (oracle Constants:
      --  "MYLONG_get_typecode", "MYLONG_initialize").
      --  Same emission for a pre-collected definition list (the
      --  file-level <File>_IDL_File package).  No recursion: a flat
      --  list has no nested modules.

      function Idl_Base_Name (Path : String) return String;
      --  The IDL file's base name without directory or extension,
      --  case preserved ("test/data/Constants.idl" -> "Constants").

      procedure Emit_Module
        (D : S.Definition_Ref; Idl_Path : String)
      is
         Module_Name : constant String := To_String (D.Name);
         --  The dotted Ada package name of THIS module (scope + name).
         Full_Name : constant String :=
           (if SU.Length (Scope_Ada) = 0
              then Module_Name
              else SU.To_String (Scope_Ada) & "." & Module_Name);
         C_Prefix : constant String :=
           (if SU.Length (Scope_C) = 0
              then Module_Name & "_"
              else SU.To_String (Scope_C) & Module_Name & "_");
         --  File name prefix: dotted scopes become dashes (library
         --  level Dashify).
         File_Prefix : constant String :=
           (if SU.Length (Scope_Ada) = 0
              then To_Lower (Module_Name)
              else To_Lower
                     (Dashify (SU.To_String (Scope_Ada)) & "-" & Module_Name));
         Module_Spec_Name : constant String :=
           File_Prefix & ".ads";
         Module_Body_Name : constant String :=
           File_Prefix & ".adb";
         --  Does this module directly declare any type (enum, struct,
         --  typedef, valuetype, union, const)?  Only those get a body
         --  file and the with-DDS lines in the spec (oracle
         --  module.idl: a.ads and a-b.ads are empty, a-b-c has the
         --  with-clauses).  Consts need the body only if a typedef'd
         --  type exists; consts alone do not produce body impls.
         Declares_Types : Boolean := False;
      begin
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               K : constant S.Definition_Kind_T :=
                 D.Module_Body (J).Kind;
            begin
               if K = D_Enum or else K = D_Struct
                 or else K = D_Typedef or else K = D_Value_Type
                 or else K = D_Union
               then
                  Declares_Types := True;
               end if;
            end;
         end loop;

         Skip_Next_Separator := False;
         --  Pass 1: the module spec.
         Self.Select_Output_File (Module_Spec_Name, F_Ada_Spec);
         Self.Emit_Header (Idl_Path);
         Self.Put_Line ("pragma Extensions_Allowed (On);");
         if Declares_Types then
            Self.Put_Line ("with DDS;");
            Self.Put_Line ("with DDS.Sequences_Generic;");
         end if;
         declare
            Seen : US_List.Vector := US_List.Empty_Vector;
         begin
            Collect_External_Scopes (D.Module_Body, Full_Name, Seen);
            for K of Seen loop
               Self.Put_Line ("with " & SU.To_String (K) & ";");
            end loop;
         end;
         Self.New_Line;
         Self.New_Line;
         Self.Put_Line
           ("pragma Style_Checks (off); --  Since this is autogenerated "
              & "code.");
         Self.Put_Line ("package  " & Full_Name & " is");
         Self.New_Line;
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               case Sub.Kind is
                  when D_Enum =>
                     Self.Emit_Enum_Block (Full_Name, Sub);
                  when D_Union =>
                     Self.Emit_Union_Block (Full_Name, Sub);
                  when D_Struct | D_Value_Type =>
                     --  A valuetype's Ada rendering is exactly a
                     --  struct block of its state members (oracle
                     --  base.idl: basetrack_t).
                     Self.Emit_Struct_Block (Full_Name, Sub);
                  when D_Typedef =>
                     Self.Emit_Typedef_Block
                       (Full_Name, Sub, C_Prefix,
                        Skip_Next_Separator);
                     Skip_Next_Separator := False;
                  when D_Const =>
                     Self.Put_Line ("");
                     Self.Emit_Const_Line (Full_Name, Sub);
                     --  The const's trailing ' ' line doubles as the
                     --  next non-const block's separator (oracle
                     --  ArrayRanges).  Consecutive consts just get the
                     --  blank line between them.
                     if J < D.Module_Body.Last_Index
                       and then D.Module_Body (J + 1).Kind /= D_Const
                     then
                        if D.Module_Body (J + 1).Kind = D_Typedef
                          or else D.Module_Body (J + 1).Kind = D_Struct
                          or else D.Module_Body (J + 1).Kind = D_Union
                          or else D.Module_Body (J + 1).Kind = D_Value_Type
                        then
                           Self.Put_Line (" ");
                           Skip_Next_Separator := True;
                        elsif D.Module_Body (J + 1).Kind = D_Enum then
                           null;  --  the enum block brings its own blank
                        else
                           Self.New_Line;
                           Skip_Next_Separator := True;
                        end if;
                     end if;
                  when others =>
                     null;
               end case;
            end;
         end loop;
         Self.New_Line;
         Self.Put_Line ("end " & Full_Name & ";");
         Self.New_Line;

         --  Recurse into nested modules BEFORE emitting the body: the
         --  body belongs to this module's own types only.
         declare
            Saved_Ada : constant SU.Unbounded_String := Scope_Ada;
            Saved_C : constant SU.Unbounded_String := Scope_C;
            Saved_Count : constant Natural := Type_Count_In_Scope;
         begin
            Scope_Ada := SU.To_Unbounded_String (Full_Name);
            Scope_C := SU.To_Unbounded_String (C_Prefix);
            Type_Count_In_Scope := 0;
            for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
            loop
               if D.Module_Body (J).Kind = D_Module then
                  Emit_Module (D.Module_Body (J), Idl_Path);
               end if;
            end loop;
            Scope_Ada := Saved_Ada;
            Scope_C := Saved_C;
            Type_Count_In_Scope := Saved_Count;
         end;

         if not Declares_Types then
            return;   --  empty intermediate module: no body file
         end if;

         --  Pass 2: the module body.
         Self.Select_Output_File (Module_Body_Name, F_Ada_Body);
         Self.Emit_Header (Idl_Path);
         Self.Put_Line ("pragma Extensions_Allowed (On);");
         Self.Put_Line ("pragma Style_Checks (off);");
         Self.New_Line;
         Self.Put_Line ("with RTI;");
         Self.New_Line;
         Self.Put_Line ("package body " & Full_Name & " is");
         Self.New_Line;
         Self.New_Line;
         Self.Put_Line ("   use type Standard.RTI.Bool;");
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               case Sub.Kind is
                  when D_Enum | D_Struct | D_Value_Type | D_Union =>
                     Self.Emit_Body_Initialize
                       (Full_Name, To_String (Sub.Name));
                     Self.Emit_Body_Finalize
                       (Full_Name, To_String (Sub.Name));
                     Self.Emit_Body_Copy
                       (Full_Name, To_String (Sub.Name));
                  when D_Typedef =>
                     Self.Emit_Body_Initialize
                       (C_Prefix, SU.To_String
                          (Sub.Typedef_Declarators.Element
                             (Sub.Typedef_Declarators.First_Index).Name));
                     Self.Emit_Body_Finalize
                       (C_Prefix, SU.To_String
                          (Sub.Typedef_Declarators.Element
                             (Sub.Typedef_Declarators.First_Index).Name));
                     Self.Emit_Body_Copy
                       (C_Prefix, SU.To_String
                          (Sub.Typedef_Declarators.Element
                             (Sub.Typedef_Declarators.First_Index).Name));
                  when others =>
                     null;
               end case;
            end;
         end loop;
         Self.Put_Line (" end " & Full_Name & ";");
         Self.New_Line;

         --  Pass 3: per-type typesupport / datareader / datawriter.
         for J in D.Module_Body.First_Index .. D.Module_Body.Last_Index
         loop
            declare
               Sub : constant S.Definition_Ref := D.Module_Body (J);
            begin
               if Sub.Kind = D_Struct or else Sub.Kind = D_Value_Type
               then
                  Self.Emit_Typesupport
                    (Full_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataReader_Spec
                    (Full_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataWriter_Spec
                    (Full_Name, To_String (Sub.Name), Idl_Path);
               end if;
            end;
         end loop;
      end Emit_Module;

      procedure Emit_Module_From_List
        (Body_List : S.Definition_Vectors.Vector;
         Package_Name : String;
         Idl_Path : String)
      is
         --  Flat-list twin of Emit_Module (no nested modules): the
         --  <File>_IDL_File package for file-level definitions.
         Full_Name : constant String := Package_Name;
         Module_Spec_Name : constant String :=
           To_Lower (Package_Name) & ".ads";
         Module_Body_Name : constant String :=
           To_Lower (Package_Name) & ".adb";
         Declares_Types : Boolean := False;
         Has_Consts : Boolean := False;
         Has_Long_Typedef : Boolean := False;
      begin
         for J in Body_List.First_Index .. Body_List.Last_Index loop
            declare
               K : constant S.Definition_Kind_T :=
                 Body_List (J).Kind;
            begin
               if K = D_Enum or else K = D_Struct
                 or else K = D_Typedef or else K = D_Value_Type
                 or else K = D_Union
               then
                  Declares_Types := True;
               elsif K = D_Const then
                  Has_Consts := True;
               end if;
            end;
         end loop;
         --  A typedef of long also pulls the Long use-type line
         --  (oracle Constants: typedef MYLONG + "use type Long";
         --  oracle HelloWorld: bare long const, NO use-type line).
         for J in Body_List.First_Index .. Body_List.Last_Index loop
            if Body_List (J).Kind = D_Typedef
              and then Body_List (J).Typedef_Type.Kind = T_Long
            then
               Has_Long_Typedef := True;
            end if;
         end loop;

         Skip_Next_Separator := False;
         --  Pass 1: the spec.
         Self.Select_Output_File (Module_Spec_Name, F_Ada_Spec);
         Self.Emit_Header (Idl_Path);
         Self.Put_Line ("pragma Extensions_Allowed (On);");
         if Declares_Types or else Has_Consts then
            Self.Put_Line ("with DDS;");
         end if;
         if Declares_Types then
            Self.Put_Line ("with DDS.Sequences_Generic;");
         end if;
         --  External (included-IDl) scopes referenced by types.
         declare
            Seen : US_List.Vector := US_List.Empty_Vector;
         begin
            Collect_External_Scopes (Body_List, "", Seen);
            for K of Seen loop
               Self.Put_Line ("with " & SU.To_String (K) & ";");
            end loop;
         end;
         Self.New_Line;
         --  "use type" lines for the numeric base types any const
         --  uses, fixed precedence order (oracle Constants.idl:
         --  Long_Long, Long, Double; oracle Global.idl: Long, Double).
         declare
            Uses_Long_Long, Uses_Long, Uses_Double : Boolean := False;

            --  True when the const's value is a plain numeric
            --  literal (no operators, no unary minus): such consts
            --  do not pull a "use type" line (oracle nametest: bare
            --  'PI := 3.141592641' emits none).
            function Is_Bare_Literal (E : S.Expression_Ref) return Boolean
            is
              (E /= null
               and then (case E.Kind is
                            when S.E_Integer | S.E_Floating_Point => True,
                            when others => False));
         begin
            for J in Body_List.First_Index .. Body_List.Last_Index loop
               declare
                  T : S.Type_Spec_Ref;
               begin
                  if Body_List (J).Kind = D_Const then
                     T := Body_List (J).Const_Type;
                     if T.Kind = T_Scoped_Name then
                        null;  --  typedef'd const: base unknown here
                     elsif T.Kind = T_Long_Long then
                        Uses_Long_Long := True;
                     elsif T.Kind = T_Long then
                        if not Is_Bare_Literal
                                 (Body_List (J).Const_Value)
                        then
                           Uses_Long := True;
                        end if;
                     elsif T.Kind = T_Double then
                        if not Is_Bare_Literal
                                 (Body_List (J).Const_Value)
                        then
                           Uses_Double := True;
                        end if;
                     end if;
                  end if;
               end;
            end loop;
            if Uses_Long_Long then
               Self.Put_Line ("use type Standard.DDS.Long_Long;");
            end if;
            if Uses_Long and then Has_Long_Typedef then
               Self.Put_Line ("use type Standard.DDS.Long;");
            end if;
            if Uses_Double then
               Self.Put_Line ("use type Standard.DDS.Double;");
            end if;
         end;
         Self.New_Line;
         Self.Put_Line
           ("pragma Style_Checks (off); --  Since this is autogenerated "
              & "code.");
         Self.Put_Line ("package  " & Full_Name & " is");
         Self.New_Line;
         for J in Body_List.First_Index .. Body_List.Last_Index loop
            declare
               Sub : constant S.Definition_Ref := Body_List (J);
            begin
               case Sub.Kind is
                  when D_Enum =>
                     Self.Emit_Enum_Block (Full_Name, Sub);
                  when D_Union =>
                     Self.Emit_Union_Block (Full_Name, Sub);
                  when D_Struct | D_Value_Type =>
                     Self.Emit_Struct_Block (Full_Name, Sub);
                  when D_Typedef =>
                     Self.Emit_Typedef_Block
                       (Full_Name, Sub, "",
                        Skip_Next_Separator);
                     Skip_Next_Separator := False;
                  when D_Const =>
                     Self.Put_Line ("");
                     Self.Emit_Const_Line (Full_Name, Sub);
                     if J < Body_List.Last_Index
                       and then Body_List (J + 1).Kind /= D_Const
                     then
                        if Body_List (J + 1).Kind = D_Typedef
                          or else Body_List (J + 1).Kind = D_Struct
                          or else Body_List (J + 1).Kind = D_Union
                          or else Body_List (J + 1).Kind = D_Value_Type
                        then
                           Self.Put_Line (" ");
                           Skip_Next_Separator := True;
                        elsif Body_List (J + 1).Kind = D_Enum then
                           null;  --  the enum block brings its own blank
                        else
                           Self.New_Line;
                           Skip_Next_Separator := True;
                        end if;
                     end if;
                  when others =>
                     null;
               end case;
            end;
         end loop;
         Self.New_Line;
         Self.Put_Line ("end " & Full_Name & ";");
         Self.New_Line;

         if not Declares_Types then
            return;
         end if;

         --  Pass 2: the body.
         Self.Select_Output_File (Module_Body_Name, F_Ada_Body);
         Self.Emit_Header (Idl_Path);
         Self.Put_Line ("pragma Extensions_Allowed (On);");
         Self.Put_Line ("pragma Style_Checks (off);");
         Self.New_Line;
         Self.Put_Line ("with RTI;");
         Self.New_Line;
         Self.Put_Line ("package body " & Full_Name & " is");
         Self.New_Line;
         Self.New_Line;
         Self.Put_Line ("   use type Standard.RTI.Bool;");
         for J in Body_List.First_Index .. Body_List.Last_Index loop
            declare
               Sub : constant S.Definition_Ref := Body_List (J);
            begin
               case Sub.Kind is
                  when D_Enum | D_Struct | D_Value_Type | D_Union =>
                     Self.Emit_Body_Initialize
                       (Full_Name, To_String (Sub.Name));
                     Self.Emit_Body_Finalize
                       (Full_Name, To_String (Sub.Name));
                     Self.Emit_Body_Copy
                       (Full_Name, To_String (Sub.Name));
                  when D_Typedef =>
                     Self.Emit_Body_Initialize
                       ("", SU.To_String (Sub.Typedef_Declarators.Element
                          (Sub.Typedef_Declarators.First_Index).Name));
                     Self.Emit_Body_Finalize
                       ("", SU.To_String (Sub.Typedef_Declarators.Element
                          (Sub.Typedef_Declarators.First_Index).Name));
                     Self.Emit_Body_Copy
                       ("", SU.To_String (Sub.Typedef_Declarators.Element
                          (Sub.Typedef_Declarators.First_Index).Name));
                  when others =>
                     null;
               end case;
            end;
         end loop;
         Self.Put_Line (" end " & Full_Name & ";");
         Self.New_Line;

         --  Pass 3: per-type typesupport / datareader / datawriter.
         for J in Body_List.First_Index .. Body_List.Last_Index loop
            declare
               Sub : constant S.Definition_Ref := Body_List (J);
            begin
               if Sub.Kind = D_Struct or else Sub.Kind = D_Value_Type
               then
                  Self.Emit_Typesupport
                    (Full_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataReader_Spec
                    (Full_Name, To_String (Sub.Name), Idl_Path);
                  Self.Emit_DataWriter_Spec
                    (Full_Name, To_String (Sub.Name), Idl_Path);
               end if;
            end;
         end loop;
      end Emit_Module_From_List;

      function Idl_Base_Name (Path : String) return String is
         --  Strip directory and extension, case preserved.
         Slash : Natural := Path'Last;
         Dot : Natural := Path'Last;
      begin
         for I in reverse Path'Range loop
            if Path (I) = '/' or else Path (I) = '\' then
               Slash := I;
               exit;
            end if;
         end loop;
         for I in reverse Path'Range loop
            if Path (I) = '.' and then I > Slash then
               Dot := I;
               exit;
            end if;
         end loop;
         return Path (Slash + 1 .. Dot - 1);
      end Idl_Base_Name;

   begin
      --  File-level definitions outside all modules go into the
      --  implicit "<File>_IDL_File" package (oracle Constants.idl:
      --  "package  Constants_IDL_File is", base name case preserved).
      declare
         Base : constant String := Idl_Base_Name (Idl_Path);
         Top : S.Definition_Vectors.Vector;
      begin
         for I in Tree.First_Index .. Tree.Last_Index loop
            if Tree (I).Kind /= D_Module then
               Top.Append (Tree (I));
            end if;
         end loop;
         if not Top.Is_Empty then
            Emit_Module_From_List (Top, Base & "_IDL_File", Idl_Path);
         end if;
      end;

      for I in Tree.First_Index .. Tree.Last_Index loop
         declare
            D : constant S.Definition_Ref := Tree (I);
         begin
            if D.Kind = D_Module then
               Emit_Module (D, Idl_Path);
            end if;
         end;
      end loop;
   end Generate;

end IDL2Lang.Backends.Ada_RTI;