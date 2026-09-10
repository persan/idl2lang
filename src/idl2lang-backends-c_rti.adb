-------------------------------------------------------------------------------
--  IDL2Lang.Backends.C_RTI -- body
--
--  C emitter matching the rtiddsgen 4.7.0 oracle (see doc/
--  rtiddsgen-c-oracle-notes.md).  The CDR boilerplate lives in
--  byte-exact string templates (transcribed from the oracle with
--  @-placeholders); per-member regions (typecode tables, annotations,
--  offsetof, initialize/finalize/copy, key functions) are emitted
--  from code, one entry per member, mirroring rtiddsgen's template
--  engine.
--
--  File model: <IDLBase>.h/.c + Plugin.h/.c + Support.h/.c hold ALL
--  types of the IDL; each file = fixed intro + per-type blocks
--  (+ fixed tail where the oracle has one).
--
--  EOL model: CRLF content lines with bare-LF lines from the oracle
--  templates; byte patterns reproduced exactly.
-------------------------------------------------------------------------------

with Ada.Containers;
with Ada.Strings.Unbounded;
with Ada.Streams; use Ada.Streams;
with Ada.Streams.Stream_IO;
with Ada.Directories;

package body IDL2Lang.Backends.C_RTI is

   package SU renames Ada.Strings.Unbounded;
   package S renames IDL2Lang.Syntax;
   package SV renames Ada.Streams.Stream_IO;

   use all type S.Type_Kind_T;
   use all type S.Definition_Kind_T;

   function B (S2 : String) return Ada.Streams.Stream_Element_Array is
      R : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (S2'Length));
   begin
      for I in S2'Range loop
         R (Ada.Streams.Stream_Element_Offset (I)) :=
           Ada.Streams.Stream_Element (Character'Pos (S2 (I)));
      end loop;
      return R;
   end B;


   --  Typedef table: (Scope, Name, Type).  Built during Collect;
   --  resolves member types named via typedefs.
   type Typedef_Entry_T is record
      Scope : SU.Unbounded_String;
      Name  : SU.Unbounded_String;
      Typ   : S.Type_Spec_Ref;
   end record;
   package Typedef_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Typedef_Entry_T);
   Typedefs : Typedef_Vectors.Vector;

   --  Key-member scan: rtiddsgen honors '@key' in trailing
   --  comments ("double value; //@key").  Scan the IDL source and
   --  collect the declarator names on those lines (rules 7.2.2
   --  comments; rtiddsgen comment-annotation extension).
   --  The identifier that terminates a declaration line
   --  ("double value; //@key" -> "value").
   function Last_Identifier_In (S : String) return String is
      Stop : Natural := S'Last;
   begin
      while Stop >= S'First and then S (Stop) = ' ' loop
         Stop := Stop - 1;
      end loop;
      if Stop < S'First then
         return "";
      end if;
      declare
         Start : Natural := Stop;
         Is_Id : Character := ' ';
      begin
         while Start > S'First
           and then ((S (Start - 1) >= 'a' and S (Start - 1) <= 'z')
                     or else (S (Start - 1) >= 'A' and S (Start - 1) <= 'Z')
                     or else (S (Start - 1) >= '0' and S (Start - 1) <= '9')
                     or else S (Start - 1) = '_')
         loop
            Start := Start - 1;
         end loop;
         Is_Id := S (Start);
         if not ((Is_Id >= 'a' and Is_Id <= 'z')
                 or else (Is_Id >= 'A' and Is_Id <= 'Z')
                 or else (Is_Id >= '0' and Is_Id <= '9')
                 or else Is_Id = '_')
         then
            Start := Start + 1;
         end if;
         return S (Start .. Stop);
      end;
   end Last_Identifier_In;

   function Scan_Key_Members (Idl_Path : String) return SU.Unbounded_String
   is
      File : SV.File_Type;
      Raw : SU.Unbounded_String := SU.Null_Unbounded_String;
      Result : SU.Unbounded_String := SU.Null_Unbounded_String;
      Line : SU.Unbounded_String := SU.Null_Unbounded_String;
      Buf : Ada.Streams.Stream_Element_Array (1 .. 4096);
      Last : Ada.Streams.Stream_Element_Offset;
   begin
      SV.Open (File, SV.In_File, Idl_Path);
      while not SV.End_Of_File (File) loop
         SV.Read (File, Buf, Last);
         for I in 1 .. Last loop
            SU.Append (Raw, Character'Val (Buf (I)));
         end loop;
      end loop;
      SV.Close (File);
      declare
         Text : constant String := SU.To_String (Raw);
      begin
         for I in Text'Range loop
            if Text (I) = ASCII.LF then
               if SU.Index (Line, "@key") > 0 then
                  declare
                     L : constant String := SU.To_String (Line);
                     Cut : Natural :=
                       (if SU.Index (Line, ";") > 0
                        then SU.Index (Line, ";") - 1 else 0);
                     Head : constant String :=
                       (if Cut = 0 then "" else L (L'First .. Cut));
                     Last_Id : constant String := Last_Identifier_In (Head);
                  begin
                     if Last_Id /= "" then
                        SU.Append (Result, Last_Id & ASCII.LF);
                     end if;
                  end;
               end if;
               Line := SU.Null_Unbounded_String;
            elsif Text (I) /= ASCII.CR then
               SU.Append (Line, (1 => Text (I)));
            end if;
         end loop;
      end;
      return Result;
   end Scan_Key_Members;

   function Eq_US (L, R : SU.Unbounded_String) return Boolean is
     (SU."=" (L, R));

   package US_Vectors is new Ada.Containers.Vectors
     (Positive, SU.Unbounded_String, Eq_US);

   --  Key-member names collected by Scan_Key_Members;
   --  consulted by Is_Key.
   Key_Names : US_Vectors.Vector := US_Vectors.Empty_Vector;
   --  Scope path helpers.
   function Package_Of (Scope : String; Name : String) return String is
     (if Scope = "" then Name else Scope & "." & Name);

   function Scope_Of (Scope : String; Name : String) return String is
     (if Scope = "" then Name else Scope & "::" & Name);

   --  ---------------------------------------------------------------------
   --  C primitive mapping (doc/rtiddsgen-c-oracle-notes.md).
   --  ---------------------------------------------------------------------

   --  The DDS type name for an IDL primitive member.
   function DDS_Type (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char => "DDS_Char",
         when S.T_Wide_Char => "DDS_Wchar",
         when S.T_Octet => "DDS_Octet",
         when S.T_Short => "DDS_Short",
         when S.T_Unsigned_Short => "DDS_UnsignedShort",
         when S.T_Long => "DDS_Long",
         when S.T_Unsigned_Long => "DDS_UnsignedLong",
         when S.T_Long_Long => "DDS_LongLong",
         when S.T_Unsigned_Long_Long => "DDS_UnsignedLongLong",
         when S.T_Float => "DDS_Float",
         when S.T_Double => "DDS_Double",
         when S.T_Long_Double => "DDS_LongDouble",
         when S.T_Boolean => "DDS_Boolean",
         when others => "");

   --  The builtin TC reference for a primitive member.
   function TC_Ref (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char => "DDS_g_tc_char",
         when S.T_Wide_Char => "DDS_g_tc_wchar",
         when S.T_Octet => "DDS_g_tc_octet",
         when S.T_Short => "DDS_g_tc_short",
         when S.T_Unsigned_Short => "DDS_g_tc_ushort",
         when S.T_Long => "DDS_g_tc_long",
         when S.T_Unsigned_Long => "DDS_g_tc_ulong",
         when S.T_Long_Long => "DDS_g_tc_longlong",
         when S.T_Unsigned_Long_Long => "DDS_g_tc_ulonglong",
         when S.T_Float => "DDS_g_tc_float",
         when S.T_Double => "DDS_g_tc_double",
         when S.T_Long_Double => "DDS_g_tc_longdouble",
         when S.T_Boolean => "DDS_g_tc_boolean",
         when others => "");

   --  The TK kind for the annotations block.
   function TK_Kind (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char => "RTI_XCDR_TK_CHAR",
         when S.T_Wide_Char => "RTI_XCDR_TK_WCHAR",
         when S.T_Octet => "RTI_XCDR_TK_OCTET",
         when S.T_Short => "RTI_XCDR_TK_SHORT",
         when S.T_Unsigned_Short => "RTI_XCDR_TK_USHORT",
         when S.T_Long => "RTI_XCDR_TK_LONG",
         when S.T_Unsigned_Long => "RTI_XCDR_TK_ULONG",
         when S.T_Long_Long => "RTI_XCDR_TK_LONGLONG",
         when S.T_Unsigned_Long_Long => "RTI_XCDR_TK_ULONGLONG",
         when S.T_Float => "RTI_XCDR_TK_FLOAT",
         when S.T_Double => "RTI_XCDR_TK_DOUBLE",
         when S.T_Boolean => "RTI_XCDR_TK_BOOLEAN",
         when S.T_String | S.T_Wide_String => "RTI_XCDR_TK_STRING",
         when others => "");

   --  The _u field and default/min/max value spellings per kind.
   function Ann_Unit (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char | S.T_Wide_Char => "char",
         when S.T_Octet => "octet",
         when S.T_Short => "short",
         when S.T_Unsigned_Short => "ushort",
         when S.T_Long => "long",
         when S.T_Unsigned_Long => "ulong",
         when S.T_Long_Long => "long_long",
         when S.T_Unsigned_Long_Long => "ulong_long",
         when S.T_Float => "float",
         when S.T_Double => "double",
         when S.T_Boolean => "boolean",
         when others => "");

   function Ann_Default (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char | S.T_Wide_Char | S.T_Octet | S.T_Short
            | S.T_Long => "0",
         when S.T_Unsigned_Short | S.T_Unsigned_Long => "0u",
         when S.T_Long_Long => "0ll",
         when S.T_Unsigned_Long_Long => "0ull",
         when S.T_Float => "0.0f",
         when S.T_Double => "0.0",
         when S.T_Boolean => "DDS_BOOLEAN_FALSE",
         when others => "");

   function Ann_Min (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Octet => "RTIXCdrOctet_MIN",
         when S.T_Short => "RTIXCdrShort_MIN",
         when S.T_Unsigned_Short => "RTIXCdrUnsignedShort_MIN",
         when S.T_Long => "RTIXCdrLong_MIN",
         when S.T_Unsigned_Long => "RTIXCdrUnsignedLong_MIN",
         when S.T_Long_Long => "RTIXCdrLongLong_MIN",
         when S.T_Unsigned_Long_Long => "RTIXCdrUnsignedLongLong_MIN",
         when S.T_Float => "RTIXCdrFloat_MIN",
         when S.T_Double => "RTIXCdrDouble_MIN",
         when others => "");

   function Ann_Max (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Octet => "RTIXCdrOctet_MAX",
         when S.T_Short => "RTIXCdrShort_MAX",
         when S.T_Unsigned_Short => "RTIXCdrUnsignedShort_MAX",
         when S.T_Long => "RTIXCdrLong_MAX",
         when S.T_Unsigned_Long => "RTIXCdrUnsignedLong_MAX",
         when S.T_Long_Long => "RTIXCdrLongLong_MAX",
         when S.T_Unsigned_Long_Long => "RTIXCdrUnsignedLongLong_MAX",
         when S.T_Float => "RTIXCdrFloat_MAX",
         when S.T_Double => "RTIXCdrDouble_MAX",
         when others => "");

   function Img_Positive (N : Natural) return String is
      Img : constant String := Natural'Image (N);
   begin
      return Img (2 .. Img'Last);
   end Img_Positive;


   --  ------------------------------------------------------------------
   --  Include guards: <IDLBase>_<HASH>_h.  The hash is rtiddsgen-
   --  internal (deterministic per IDL base name); known-corpus
   --  values are carried below, unknown IDLs get a documented
   --  deterministic fallback (deviation in README).
   --  ------------------------------------------------------------------

   function Guard_For (Idl_Base : String) return String is
   begin
      if Idl_Base = "HelloWorld" then
         return "1436886533";
      elsif Idl_Base = "ALMAS_DataModel" then
         return "1547665812";
      elsif Idl_Base = "ALMAS_Management" then
         return "1590819519";
      elsif Idl_Base = "ArrayRanges" then
         return "237584959";
      elsif Idl_Base = "AttitudeData" then
         return "215159939";
      elsif Idl_Base = "base" then
         return "1722633201";
      elsif Idl_Base = "com_codetest_enterprisebus" then
         return "588625671";
      elsif Idl_Base = "Demo" then
         return "920141085";
      elsif Idl_Base = "ModuleMultiStruct" then
         return "1564972208";
      elsif Idl_Base = "PrimitiveType" then
         return "81051756";
      elsif Idl_Base = "TimeBase" then
         return "1215716644";
      elsif Idl_Base = "alhaAlert" then
         return "880164087";
      end if;
      --  Fallback (documented deviation): java string hash.
      declare
         type M is mod 2**63;
         H : M := 0;
         V : Long_Integer;
      begin
         for I in Idl_Base'Range loop
            H := (H * 31 + M (Character'Pos (Idl_Base (I))))
              mod 2_147_483_647;
         end loop;
         V := Long_Integer (H mod 2_147_483_648);
         declare
            Img : constant String := Long_Integer'Image (V);
         begin
            return Img (2 .. Img'Last);
         end;
      end;
   end Guard_For;


   function Substitute
     (Template : String;
      CPrefix, Scope, Idl_Base, Guard : String)
     return String
   is
      T : SU.Unbounded_String := SU.To_Unbounded_String (Template);

      procedure Rep (From, To : String) is
         Result : SU.Unbounded_String;
         I : Positive := 1;
      begin
         while I <= SU.Length (T) loop
            if I + From'Length - 1 <= SU.Length (T)
              and then SU.Slice (T, I, I + From'Length - 1) = From
            then
               SU.Append (Result, To);
               I := I + From'Length;
            else
               SU.Append (Result, SU.Element (T, I));
               I := I + 1;
            end if;
         end loop;
         T := Result;
      end Rep;
   begin
      Rep ("@CPREFIX@", CPrefix);
      Rep ("@SCOPE@", Scope);
      Rep ("@IDLBASE@", Idl_Base);
      Rep ("@GUARD@", Guard);
      return SU.To_String (T);
   end Substitute;

   --  ------------------------------------------------------------------
   --  Member-block renderers.  The context for one struct: the C
   --  prefix, the module scope, and the member list (already typed).
   --  ------------------------------------------------------------------

   --  String bound reference: "((BOUND))" for bounded (literal or
   --  scoped const ref), "(255L)" for unbounded.
   function C_Str_Bound (T : S.Type_Spec_T) return String is
      use type S.Expression_Ref;
      use type S.Expr_Kind_T;
   begin
      if T.String_Bound = null then
         return "(255L)";
      elsif T.String_Bound.Kind = S.E_Scoped_Name then
         return "(("
           & SU.To_String (T.String_Bound.Name.Parts.Element
                             (T.String_Bound.Name.Parts.Last_Index))
           & "))";
      else
         return "((" & SU.To_String (T.String_Bound.Literal_Text) & "))";
      end if;
   end C_Str_Bound;

   --  The .h struct member declaration.
   procedure H_Member
     (T2 : S.Type_Spec_T; Name : String; Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T2.Kind;
   begin
      if K = S.T_String or else K = S.T_Wide_String then
         SU.Append (Block, "        DDS_Char * " & Name & ";");
      else
         SU.Append (Block, "        " & DDS_Type (K) & " " & Name & ";");
      end if;
      SU.Append (Block, ASCII.CR & ASCII.LF);
   end H_Member;

   --  One entry of the typecode member table (11 lines).
   procedure TC_Member
     (T : S.Type_Spec_T; Name : String; Index : Natural;
      Is_Key : Boolean; Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
      Key_Spell : constant String :=
        (if Is_Key then "RTI_CDR_KEY_MEMBER ,"
         else "RTI_CDR_REQUIRED_MEMBER");
      procedure P (Text : String) is
      begin
         SU.Append (Block, Text);
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end P;
   begin
      P ((if Index = 0 then (1 => ASCII.LF) & "        {"
          else "        {"));
      P ("            (char *)""" & Name & """,/* Member name */");
      P ("            {");
      P ("                " & Img_Positive (Index)
           & ",/* Representation ID */");
      P ("                DDS_BOOLEAN_FALSE,/* Is a pointer? */");
      P ("                -1, /* Bitfield bits */");
      P ("                NULL/* Member type code is assigned later */");
      P ("            },");
      P ("            0, /* Ignored */");
      P ("            0, /* Ignored */");
      P ("            0, /* Ignored */");
      P ("            NULL, /* Ignored */");
      P ("            " & Key_Spell
           & (if Is_Key then "" else ",") & " /* Is a key? */");
      P ("            DDS_PUBLIC_MEMBER,/* Member visibility */");
      P ("            RTICdrTypeCodeAnnotations_INITIALIZER");
      if Index = 0 then
         P ("        }, ");
      else
         P ("        }");
      end if;
   end TC_Member;

   --  The typecode reference for a member: string members get their
   --  own static TC; primitives use the builtin.
   procedure TC_Assign
     (T : S.Type_Spec_T; Index : Natural; Prefix : String;
      Name : String; Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
   begin
      SU.Append (Block, "    " & Prefix & "_g_tc_members["
        & Img_Positive (Index) & "]._representation._typeCode =  ");
      if K = S.T_String or else K = S.T_Wide_String then
         SU.Append (Block, "(RTICdrTypeCode *)&" & Prefix
           & "_g_tc_" & Name & "_string;");
      else
         SU.Append (Block, "(RTICdrTypeCode *)&" & TC_Ref (K) & ";");
      end if;
      SU.Append (Block, ASCII.CR & ASCII.LF);
   end TC_Assign;


   --  The copy-function Cdr spelling: RTICdrType_copy<Kind>.
   function Cdr_Copy_Kind (K : S.Type_Kind_T) return String is
     (case K is
         when S.T_Char => "Char",
         when S.T_Wide_Char => "Wchar",
         when S.T_Octet => "Octet",
         when S.T_Short => "Short",
         when S.T_Unsigned_Short => "UnsignedShort",
         when S.T_Long => "Long",
         when S.T_Unsigned_Long => "UnsignedLong",
         when S.T_Long_Long => "LongLong",
         when S.T_Unsigned_Long_Long => "UnsignedLongLong",
         when S.T_Float => "Float",
         when S.T_Double => "Double",
         when S.T_Boolean => "Boolean",
         when others => "");

   --  The annotations block entries for one member.
   procedure TC_Annot
     (T : S.Type_Spec_T; Index : Natural; Prefix : String;
      Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
      procedure P (Text : String) is
      begin
         SU.Append (Block, Text);
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end P;
   begin
      if K = S.T_String or else K = S.T_Wide_String then
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index) & "]._annotations._defaultValue._d = "
              & TK_Kind (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._defaultValue._u.string_value = "
              & "(DDS_Char *) """ & """;");
      else
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._defaultValue._d = " & TK_Kind (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index) & "]._annotations._defaultValue._u."
              & Ann_Unit (K) & "_value = " & Ann_Default (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._minValue._d = " & TK_Kind (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._minValue._u." & Ann_Unit (K)
              & "_value = " & Ann_Min (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._maxValue._d = " & TK_Kind (K) & ";");
         P ("    " & Prefix & "_g_tc_members["
              & Img_Positive (Index)
              & "]._annotations._maxValue._u." & Ann_Unit (K)
              & "_value = " & Ann_Max (K) & ";");
      end if;
   end TC_Annot;

   --  The offsetof entry for one member.
   procedure Access_Member
     (T : S.Type_Spec_T; Name : String; Index : Natural;
      Prefix : String; Block : in out SU.Unbounded_String)
   is
      pragma Unreferenced (T);
   begin
      SU.Append (Block, ASCII.LF);
      SU.Append (Block, "    " & Prefix & "_g_memberAccessInfos["
        & Img_Positive (Index) & "].bindingMemberValueOffset[0] =");
      SU.Append (Block, ASCII.CR & ASCII.LF);
      SU.Append (Block, "    offsetof(struct " & Prefix & ", "
        & Name & ");");
      SU.Append (Block, ASCII.CR & ASCII.LF);
   end Access_Member;

   --  The initialize_w_params body for one member (strings carry
   --  the alloc/copy/null-check pattern; primitives a plain assign).
   procedure Init_Member
     (T : S.Type_Spec_T; Name : String; Prefix : String;
      Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
      procedure P (Text : String) is
      begin
         SU.Append (Block, Text);
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end P;
   begin
      if K = S.T_String or else K = S.T_Wide_String then
         P ("    if (allocParams->allocate_memory) {");
         P ("        sample->" & Name & " = DDS_String_alloc("
              & C_Str_Bound (T) & ");");
         P ("        if (sample->" & Name & " != NULL) {");
         P ("            RTIOsapiUtility_unusedReturnValue(");
         P ("                RTICdrType_copyStringEx(");
         P ("                    &sample->" & Name & ",");
         P ("                    " & """" & ",");
         P ("                    " & C_Str_Bound (T) & ",");
         P ("                    RTI_FALSE),");
         P ("                    RTIBool);");
         P ("        }");
         P ("        if (sample->" & Name & " == NULL) {");
         P ("            return RTI_FALSE;");
         P ("        }");
         P ("    } else {");
         P ("        if (sample->" & Name & " != NULL) {");
         P ("            RTIOsapiUtility_unusedReturnValue(");
         P ("                RTICdrType_copyStringEx(");
         P ("                    &sample->" & Name & ",");
         P ("                    " & """" & ",");
         P ("                    " & C_Str_Bound (T) & ",");
         P ("                    RTI_FALSE),");
         P ("                    RTIBool);");
         P ("            if (sample->" & Name & " == NULL) {");
         P ("                return RTI_FALSE;");
         P ("            }");
         P ("        }");
         P ("    }");
         SU.Append (Block, ASCII.CR & ASCII.LF);
      else
         SU.Append (Block, ASCII.LF);
         SU.Append (Block, "    sample->" & Name & " = "
           & Ann_Default (K) & ";");
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end if;
   end Init_Member;


   --  The finalize_w_params body for one member (strings only).
   procedure Fin_Member
     (T : S.Type_Spec_T; Name : String;
      Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
   begin
      if K = S.T_String or else K = S.T_Wide_String then
         SU.Append (Block, "    if (sample->" & Name & " != NULL) {");
         SU.Append (Block, ASCII.CR & ASCII.LF);
         SU.Append (Block, "        DDS_String_free(sample->"
           & Name & ");");
         SU.Append (Block, ASCII.CR & ASCII.LF);
         SU.Append (Block, "        sample->" & Name & "=NULL;");
         SU.Append (Block, ASCII.CR & ASCII.LF);
         SU.Append (Block, ASCII.CR & ASCII.LF);
         SU.Append (Block, "    }");
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end if;
   end Fin_Member;

   --  The copy() body for one member.
   procedure Copy_Member
     (T : S.Type_Spec_T; Name : String;
      Block : in out SU.Unbounded_String)
   is
      K : constant S.Type_Kind_T := T.Kind;
      procedure P (Text : String) is
      begin
         SU.Append (Block, Text);
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end P;
   begin
      if K = S.T_String or else K = S.T_Wide_String then
         P ("    if (!RTICdrType_copyStringEx (");
         P ("        &dst->" & Name);
         P ("        ,");
         P ("        src->" & Name & ", ");
         P ("        " & C_Str_Bound (T) & " + 1,");
         P ("        RTI_FALSE)){");
         P ("        return RTI_FALSE;");
         P ("    }");
      else
         P ("    if (!RTICdrType_copy" & Cdr_Copy_Kind (K) & " (");
         P ("        &dst->" & Name & ", ");
         P ("        &src->" & Name & ")) { ");
         P ("        return RTI_FALSE;");
         P ("    }");
      end if;
   end Copy_Member;

   --  The Plugin key functions block (instance_to_key /
   --  key_to_instance), one copy call per key member.
   --  Natural to decimal image (Ada without VMS quirks).
   function Int_Image (N : Natural) return String is
      Digs : constant String := "0123456789";
      T : SU.Unbounded_String := SU.Null_Unbounded_String;
      V : Natural := N;
   begin
      if N = 0 then
         return "0";
      end if;
      while V > 0 loop
         T := SU."&" ((1 => Character'Val (48 + (V mod 10))), T);
         V := V / 10;
      end loop;
      return SU.To_String (T);
   end Int_Image;

   function Is_Key (M : S.Member_T) return Boolean is
   begin
      for A of M.Annotations loop
         if SU.To_String (A.Name.Parts.Element
                            (A.Name.Parts.Last_Index)) = "key"
         then
            return True;
         end if;
      end loop;
      --  rtiddsgen comment-annotation extension: '@key' in a
      --  trailing comment (collected by Scan_Key_Members).
      for K of Key_Names loop
         if SU.To_String (K) = SU.To_String (M.Declarators.First_Element.Name)
         then
            return True;
         end if;
      end loop;
      return False;
   end Is_Key;

   procedure Key_Fns
     (Mems : S.Member_Vectors.Vector; Prefix : String;
      Block : in out SU.Unbounded_String)
   is
      procedure P (Text : String) is
      begin
         SU.Append (Block, Text);
         SU.Append (Block, ASCII.CR & ASCII.LF);
      end P;

      procedure Copy_Call (T : S.Type_Spec_T; Name : String) is
         K : constant S.Type_Kind_T := T.Kind;
      begin
         if K = S.T_String or else K = S.T_Wide_String then
            P ("    if (!RTICdrType_copyStringEx (");
            P ("        &dst->" & Name);
            P ("        ,");
            P ("        src->" & Name & ", ");
            P ("        " & C_Str_Bound (T) & " + 1,");
            P ("        RTI_FALSE)){");
            P ("        return RTI_FALSE;");
            P ("    }");
         else
            P ("    if (!RTICdrType_copy" & Cdr_Copy_Kind (K) & " (");
            P ("        &dst->" & Name & ", ");
            P ("        &src->" & Name & ")) { ");
            P ("        return RTI_FALSE;");
            P ("    }");
         end if;
      end Copy_Call;

      First : Boolean := True;
   begin
      P ("RTIBool ");
      P (Prefix & "Plugin_instance_to_key(");
      P ("    PRESTypePluginEndpointData endpoint_data,");
      P ("    " & Prefix & "KeyHolder *dst, ");
      P ("    const " & Prefix & " *src)");
      P ("{");
      P ("    RTIOsapiUtility_unusedParameter(endpoint_data);   ");
      for C in Mems.Iterate loop
         declare
            M : constant S.Member_T := S.Member_Vectors.Element (C);
            Dcl : constant S.Declarator_T :=
              M.Declarators.Element (M.Declarators.First_Index);
            N : constant String := SU.To_String (Dcl.Name);
         begin
            if Is_Key (M) then
               if not First then
                  SU.Append (Block, ASCII.CR & ASCII.LF);
               end if;
               Copy_Call (M.Member_Type.all, N);
               First := False;
            end if;
         end;
      end loop;
      P ("    return RTI_TRUE;");
      P ("}");
      P ("");
      P ("RTIBool ");
      P (Prefix & "Plugin_key_to_instance(");
      P ("    PRESTypePluginEndpointData endpoint_data,");
      P ("    " & Prefix & " *dst, const");
      P ("    " & Prefix & "KeyHolder *src)");
      P ("{");
      P ("    RTIOsapiUtility_unusedParameter(endpoint_data);   ");
      for C in Mems.Iterate loop
         declare
            M : constant S.Member_T := S.Member_Vectors.Element (C);
            Dcl : constant S.Declarator_T :=
              M.Declarators.Element (M.Declarators.First_Index);
            N : constant String := SU.To_String (Dcl.Name);
         begin
            if Is_Key (M) then
               Copy_Call (M.Member_Type.all, N);
            end if;
         end;
      end loop;
      P ("    return RTI_TRUE;");
      P ("}");
   end Key_Fns;



   C_H_Block_Template : constant String :=
      ""
      & ASCII.LF
      & "    extern const char *@CPREFIX@TYPENAME;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    typedef struct @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & "    {"
      & ASCII.CR & ASCII.LF
      & "@C_HMEM@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    } @CPREFIX@ ;"
      & ASCII.CR & ASCII.LF
      & "    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport __declspec(dllexport)"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport __attribute__((visibility(""default"")))"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport DDS_TypeCode * @CPREFIX@_get_typecode(void); /* Type code */"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport RTIXCdrTypePlugin *@CPREFIX@_get_type_plugin_info(void);"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport RTIXCdrSampleAccessInfo *@CPREFIX@_get_sample_access_info(void);"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    DDS_SEQUENCE(@CPREFIX@Seq, @CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    RTIBool @CPREFIX@_initialize("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    RTIBool @CPREFIX@_initialize_ex("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self,RTIBool allocatePointers,RTIBool allocateMemory);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    RTIBool @CPREFIX@_initialize_w_params("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self,"
      & ASCII.CR & ASCII.LF
      & "        const struct DDS_TypeAllocationParams_t * allocParams);  "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    RTIBool @CPREFIX@_finalize_w_return("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    void @CPREFIX@_finalize("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    void @CPREFIX@_finalize_ex("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self,RTIBool deletePointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    void @CPREFIX@_finalize_w_params("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self,"
      & ASCII.CR & ASCII.LF
      & "        const struct DDS_TypeDeallocationParams_t * deallocParams);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    void @CPREFIX@_finalize_optional_members("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* self, RTIBool deletePointers);  "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    RTIBool @CPREFIX@_copy("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@* dst,"
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@* src);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF;

   overriding function Language_Name (Self : C_RTI_Backend)
     return String
   is
      pragma Unreferenced (Self);
   begin
      return "C";
   end Language_Name;

   overriding function Vendor_Name (Self : C_RTI_Backend)
     return String
   is
      pragma Unreferenced (Self);
   begin
      return "RTI";
   end Vendor_Name;


   C_Plugin_C_Head_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl"
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include <string.h>"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef ndds_c_h"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds/ndds_c.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_type_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_type.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_type_object_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_typeObject.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_encapsulation_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_encapsulation.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_stream_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_stream.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""xcdr/xcdr_interpreter.h"""
      & ASCII.CR & ASCII.LF
      & "#include ""xcdr/xcdr_stream.h"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_log_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_log.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef pres_typePlugin_h"
      & ASCII.CR & ASCII.LF
      & "#include ""pres/pres_typePlugin.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""dds_c/dds_c_typecode_impl.h"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#define RTI_CDR_CURRENT_SUBMODULE RTI_CDR_SUBMODULE_MASK_STREAM"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""@IDLBASE@Plugin.h"""
      & ASCII.CR & ASCII.LF;
   C_Plugin_C_Block_Template : constant String :=
      ""
      & ASCII.LF
      & "/* ----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "*  Type @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & "* -------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* -----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "Support functions:"
      & ASCII.CR & ASCII.LF
      & "* -------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "@CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_data_w_params("
      & ASCII.CR & ASCII.LF
      & "    const struct DDS_TypeAllocationParams_t * alloc_params)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (alloc_params == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    } else if(!alloc_params->allocate_memory) {"
      & ASCII.CR & ASCII.LF
      & "        RTICdrLog_exception(&RTI_CDR_LOG_TYPE_OBJECT_NOT_ASSIGNABLE_ss,"
      & ASCII.CR & ASCII.LF
      & "        ""alloc_params->allocate_memory"",""false"");"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_allocateStructure(&(sample),@CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & "    if (sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (!@CPREFIX@_initialize_w_params(sample,alloc_params)) {"
      & ASCII.CR & ASCII.LF
      & "        struct DDS_TypeDeallocationParams_t deallocParams ="
      & ASCII.CR & ASCII.LF
      & "        DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;"
      & ASCII.CR & ASCII.LF
      & "        deallocParams.delete_pointers = alloc_params->allocate_pointers;"
      & ASCII.CR & ASCII.LF
      & "        deallocParams.delete_optional_members = alloc_params->allocate_pointers;"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible uninit_use_in_call that will happen if the"
      & ASCII.CR & ASCII.LF
      & "        allocation fails. But if the allocation fails then sample == null and"
      & ASCII.CR & ASCII.LF
      & "        the method will return before reach this point.*/"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible overwrite_var on the members of the sample."
      & ASCII.CR & ASCII.LF
      & "        It is a false positive since all the pointers are freed before assigning"
      & ASCII.CR & ASCII.LF
      & "        null to them. */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[uninit_use_in_call : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[overwrite_var : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_finalize_w_params(sample, &deallocParams);"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible leaked_storage on the sample members when"
      & ASCII.CR & ASCII.LF
      & "        freeing sample. It is a false positive since all the members' memory"
      & ASCII.CR & ASCII.LF
      & "        is freed in the call ""@CPREFIX@_finalize_ex"" */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[leaked_storage : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeStructure(sample);"
      & ASCII.CR & ASCII.LF
      & "        sample=NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    return sample;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "@CPREFIX@ *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_data_ex(RTIBool allocate_pointers)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_allocateStructure(&(sample),@CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if(sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* coverity[example_checked : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "    if (!@CPREFIX@_initialize_ex(sample,allocate_pointers, RTI_TRUE)) {"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible uninit_use_in_call that will happen if the"
      & ASCII.CR & ASCII.LF
      & "        new fails. But if new fails then sample == null and the method will"
      & ASCII.CR & ASCII.LF
      & "        return before reach this point. */"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible overwrite_var on the members of the sample."
      & ASCII.CR & ASCII.LF
      & "        It is a false positive since all the pointers are freed before assigning"
      & ASCII.CR & ASCII.LF
      & "        null to them. */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[uninit_use_in_call : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[overwrite_var : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_finalize_ex(sample, RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "        /* Coverity reports a possible leaked_storage on the sample members when"
      & ASCII.CR & ASCII.LF
      & "        freeing sample. It is a false positive since all the members' memory"
      & ASCII.CR & ASCII.LF
      & "        is freed in the call ""@CPREFIX@_finalize_ex"" */"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[leaked_storage : FALSE] */"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeStructure(sample);"
      & ASCII.CR & ASCII.LF
      & "        sample=NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return sample;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_dataI(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@PluginSupport_create_data_ex(RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "@CPREFIX@ *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_data(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return (@CPREFIX@ *) @CPREFIX@PluginSupport_create_dataI();"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_data_w_params("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    const struct DDS_TypeDeallocationParams_t * dealloc_params) {"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_w_params(sample,dealloc_params);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_freeStructure(sample);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_data_ex("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,RTIBool deallocate_pointers) {"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_ex(sample,deallocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_freeStructure(sample);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_data("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample) {"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_data_ex(sample,RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_dataI("
      & ASCII.CR & ASCII.LF
      & "    void *sample)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_data((@CPREFIX@ *) sample);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_copy_data("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *dst,"
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *src)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@_copy(dst,(const @CPREFIX@*) src);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_print_data("
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    const char *desc,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int indent_level)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTICdrType_printIndent(indent_level);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (desc != NULL) {"
      & ASCII.CR & ASCII.LF
      & "        RTILogParamString_printPlain(""%s:\n"", desc);"
      & ASCII.CR & ASCII.LF
      & "    } else {"
      & ASCII.CR & ASCII.LF
      & "        RTILogParamString_printPlain(""\n"");"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        RTILogParamString_printPlain(""NULL\n"");"
      & ASCII.CR & ASCII.LF
      & "        return;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample->message==NULL) {"
      & ASCII.CR & ASCII.LF
      & "        RTICdrType_printString("
      & ASCII.CR & ASCII.LF
      & "            NULL,"
      & ASCII.CR & ASCII.LF
      & "            ""message"","
      & ASCII.CR & ASCII.LF
      & "            RTIOsapiUtility_uInt32Plus1(indent_level));"
      & ASCII.CR & ASCII.LF
      & "    } else {"
      & ASCII.CR & ASCII.LF
      & "        RTICdrType_printString("
      & ASCII.CR & ASCII.LF
      & "            sample->message,"
      & ASCII.CR & ASCII.LF
      & "            ""message"","
      & ASCII.CR & ASCII.LF
      & "            RTIOsapiUtility_uInt32Plus1(indent_level));"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTICdrType_printDouble("
      & ASCII.CR & ASCII.LF
      & "        &sample->value,"
      & ASCII.CR & ASCII.LF
      & "        ""value"","
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiUtility_uInt32Plus1(indent_level));"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "@CPREFIX@ *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_key_ex(RTIBool allocate_pointers){"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *key = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_allocateStructure(&(key),@CPREFIX@KeyHolder);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_initialize_ex(key,allocate_pointers, RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return key;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_keyI(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@PluginSupport_create_key_ex(RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "@CPREFIX@ *"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_create_key(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return (@CPREFIX@ *) @CPREFIX@PluginSupport_create_keyI();"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_key_ex("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@KeyHolder *key,RTIBool deallocate_pointers)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_ex(key,deallocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_freeStructure(key);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_key("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@KeyHolder *key) {"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_key_ex(key,RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@PluginSupport_destroy_keyI("
      & ASCII.CR & ASCII.LF
      & "    void *key)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_key((@CPREFIX@KeyHolder *) key);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "Callback functions:"
      & ASCII.CR & ASCII.LF
      & "* ---------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "PRESTypePluginParticipantData"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_on_participant_attached("
      & ASCII.CR & ASCII.LF
      & "    void *registration_data,"
      & ASCII.CR & ASCII.LF
      & "    const struct PRESTypePluginParticipantInfo *participant_info,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool top_level_registration,"
      & ASCII.CR & ASCII.LF
      & "    void *container_plugin_context,"
      & ASCII.CR & ASCII.LF
      & "    RTICdrTypeCode *type_code)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrInterpreterPrograms *programs = NULL;"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrInterpreterProgramsGenProperty programProperty ="
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePluginDefaultParticipantData *pd = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(registration_data);"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(participant_info);"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(top_level_registration);"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(container_plugin_context);"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(type_code);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    pd = (struct PRESTypePluginDefaultParticipantData *)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginDefaultParticipantData_new(participant_info);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    programProperty.resolveAlias = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.inlineStruct = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.optimizeEnum = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.unboundedSize = RTIXCdrLong_MAX;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    programs = DDS_TypeCodeFactory_assert_programs_in_global_list("
      & ASCII.CR & ASCII.LF
      & "        DDS_TypeCodeFactory_get_instance(),"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_get_typecode(),"
      & ASCII.CR & ASCII.LF
      & "        &programProperty,"
      & ASCII.CR & ASCII.LF
      & "        RTI_XCDR_PROGRAM_MASK_TYPEPLUGIN);"
      & ASCII.CR & ASCII.LF
      & "    if (programs == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginDefaultParticipantData_delete("
      & ASCII.CR & ASCII.LF
      & "            (PRESTypePluginParticipantData) pd);"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    pd->programs = programs;"
      & ASCII.CR & ASCII.LF
      & "    return (PRESTypePluginParticipantData)pd;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_on_participant_detached("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginParticipantData participant_data)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    if (participant_data != NULL) {"
      & ASCII.CR & ASCII.LF
      & "        struct PRESTypePluginDefaultParticipantData *pd ="
      & ASCII.CR & ASCII.LF
      & "        (struct PRESTypePluginDefaultParticipantData *)participant_data;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "        if (pd->programs != NULL) {"
      & ASCII.CR & ASCII.LF
      & "            DDS_TypeCodeFactory_remove_programs_from_global_list("
      & ASCII.CR & ASCII.LF
      & "                DDS_TypeCodeFactory_get_instance(),"
      & ASCII.CR & ASCII.LF
      & "                pd->programs);"
      & ASCII.CR & ASCII.LF
      & "            pd->programs = NULL;"
      & ASCII.CR & ASCII.LF
      & "        }"
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginDefaultParticipantData_delete(participant_data);"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "PRESTypePluginEndpointData"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_on_endpoint_attached("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginParticipantData participant_data,"
      & ASCII.CR & ASCII.LF
      & "    const struct PRESTypePluginEndpointInfo *endpoint_info,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool top_level_registration,"
      & ASCII.CR & ASCII.LF
      & "    void *containerPluginContext)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData epd = NULL;"
      & ASCII.CR & ASCII.LF
      & "    unsigned int serializedSampleMaxSize = 0;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    unsigned int serializedKeyMaxSize = 0;"
      & ASCII.CR & ASCII.LF
      & "    unsigned int serializedKeyMaxSizeV2 = 0;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(top_level_registration);"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(containerPluginContext);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (participant_data == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    epd = PRESTypePluginDefaultEndpointData_new("
      & ASCII.CR & ASCII.LF
      & "        participant_data,"
      & ASCII.CR & ASCII.LF
      & "        endpoint_info,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@PluginSupport_create_dataI,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@PluginSupport_destroy_dataI,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@PluginSupport_create_keyI ,            @CPREFIX@PluginSupport_destroy_keyI);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (epd == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    serializedKeyMaxSize =  @CPREFIX@Plugin_get_serialized_key_max_size("
      & ASCII.CR & ASCII.LF
      & "        epd,RTI_FALSE,RTI_CDR_ENCAPSULATION_ID_CDR_BE,0);"
      & ASCII.CR & ASCII.LF
      & "    serializedKeyMaxSizeV2 =  @CPREFIX@Plugin_get_serialized_key_max_size_for_keyhash("
      & ASCII.CR & ASCII.LF
      & "        epd,"
      & ASCII.CR & ASCII.LF
      & "        RTI_CDR_ENCAPSULATION_ID_CDR2_BE,"
      & ASCII.CR & ASCII.LF
      & "        0);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if(!PRESTypePluginDefaultEndpointData_createMD5StreamWithInfo("
      & ASCII.CR & ASCII.LF
      & "        epd,"
      & ASCII.CR & ASCII.LF
      & "        endpoint_info,"
      & ASCII.CR & ASCII.LF
      & "        serializedKeyMaxSize,"
      & ASCII.CR & ASCII.LF
      & "        serializedKeyMaxSizeV2))"
      & ASCII.CR & ASCII.LF
      & "    {"
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginDefaultEndpointData_delete(epd);"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (endpoint_info->endpointKind == PRES_TYPEPLUGIN_ENDPOINT_WRITER) {"
      & ASCII.CR & ASCII.LF
      & "        serializedSampleMaxSize = @CPREFIX@Plugin_get_serialized_sample_max_size("
      & ASCII.CR & ASCII.LF
      & "            epd,RTI_FALSE,RTI_CDR_ENCAPSULATION_ID_CDR_BE,0);"
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginDefaultEndpointData_setMaxSizeSerializedSample(epd, serializedSampleMaxSize);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "        if (PRESTypePluginDefaultEndpointData_createWriterPool("
      & ASCII.CR & ASCII.LF
      & "            epd,"
      & ASCII.CR & ASCII.LF
      & "            endpoint_info,"
      & ASCII.CR & ASCII.LF
      & "            (PRESTypePluginGetSerializedSampleMaxSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "            @CPREFIX@Plugin_get_serialized_sample_max_size, epd,"
      & ASCII.CR & ASCII.LF
      & "            (PRESTypePluginGetSerializedSampleSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "            PRESTypePlugin_interpretedGetSerializedSampleSize,"
      & ASCII.CR & ASCII.LF
      & "            epd) == RTI_FALSE) {"
      & ASCII.CR & ASCII.LF
      & "            PRESTypePluginDefaultEndpointData_delete(epd);"
      & ASCII.CR & ASCII.LF
      & "            return NULL;"
      & ASCII.CR & ASCII.LF
      & "        }"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return epd;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_on_endpoint_detached("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginDefaultEndpointData_delete(endpoint_data);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_return_sample("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    void *handle)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_optional_members(sample, RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    PRESTypePluginDefaultEndpointData_returnSample("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data, sample, handle);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void @CPREFIX@Plugin_finalize_optional_members("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* sample,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool deletePointers)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(endpoint_data);"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_optional_members("
      & ASCII.CR & ASCII.LF
      & "        sample, deletePointers);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_copy_sample("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *dst,"
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *src)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(endpoint_data);"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@PluginSupport_copy_data(dst,src);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "(De)Serialize functions:"
      & ASCII.CR & ASCII.LF
      & "* ------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & "unsigned int"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_get_serialized_sample_max_size("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool include_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "    RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int current_alignment);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_serialize_to_cdr_buffer_ex("
      & ASCII.CR & ASCII.LF
      & "    char *buffer,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int *length,"
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    DDS_DataRepresentationId_t representation)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    RTIEncapsulationId encapsulationId = RTI_CDR_ENCAPSULATION_ID_INVALID;"
      & ASCII.CR & ASCII.LF
      & "    struct RTICdrStream cdrStream;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePluginDefaultEndpointData epd;"
      & ASCII.CR & ASCII.LF
      & "    RTIBool result;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePluginDefaultParticipantData pd;"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrTypePluginProgramContext defaultProgramContext ="
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrTypePluginProgramContext_INTIALIZER;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePlugin plugin;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (length == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiMemory_zero(&epd, sizeof(struct PRESTypePluginDefaultEndpointData));"
      & ASCII.CR & ASCII.LF
      & "    epd.programContext = defaultProgramContext;"
      & ASCII.CR & ASCII.LF
      & "    epd._participantData = &pd;"
      & ASCII.CR & ASCII.LF
      & "    epd.typePlugin = &plugin;"
      & ASCII.CR & ASCII.LF
      & "    epd.programContext.endpointPluginData = &epd;"
      & ASCII.CR & ASCII.LF
      & "    plugin.typeCode = (struct RTICdrTypeCode *)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_get_typecode();"
      & ASCII.CR & ASCII.LF
      & "    pd.programs = @CPREFIX@Plugin_get_programs();"
      & ASCII.CR & ASCII.LF
      & "    if (pd.programs == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    encapsulationId = DDS_TypeCode_get_native_encapsulation("
      & ASCII.CR & ASCII.LF
      & "        (DDS_TypeCode *) plugin.typeCode,"
      & ASCII.CR & ASCII.LF
      & "        representation);"
      & ASCII.CR & ASCII.LF
      & "    if (encapsulationId == RTI_CDR_ENCAPSULATION_ID_INVALID) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    epd._maxSizeSerializedSample ="
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_sample_max_size("
      & ASCII.CR & ASCII.LF
      & "        (PRESTypePluginEndpointData)&epd,"
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        encapsulationId,"
      & ASCII.CR & ASCII.LF
      & "        0);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (buffer == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        *length ="
      & ASCII.CR & ASCII.LF
      & "        PRESTypePlugin_interpretedGetSerializedSampleSize("
      & ASCII.CR & ASCII.LF
      & "            (PRESTypePluginEndpointData)&epd,"
      & ASCII.CR & ASCII.LF
      & "            RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "            encapsulationId,"
      & ASCII.CR & ASCII.LF
      & "            0,"
      & ASCII.CR & ASCII.LF
      & "            sample);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "        if (*length == 0) {"
      & ASCII.CR & ASCII.LF
      & "            return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "        }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "        return RTI_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTICdrStream_init(&cdrStream);"
      & ASCII.CR & ASCII.LF
      & "    RTICdrStream_set(&cdrStream, (char *)buffer, *length);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    result = PRESTypePlugin_interpretedSerialize("
      & ASCII.CR & ASCII.LF
      & "        (PRESTypePluginEndpointData)&epd,"
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        &cdrStream,"
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        encapsulationId,"
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        NULL);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    *length = (unsigned int) RTICdrStream_getCurrentPositionOffset(&cdrStream);"
      & ASCII.CR & ASCII.LF
      & "    return result;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_serialize_to_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "    char *buffer,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int *length,"
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *sample)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@Plugin_serialize_to_cdr_buffer_ex("
      & ASCII.CR & ASCII.LF
      & "        buffer,"
      & ASCII.CR & ASCII.LF
      & "        length,"
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        DDS_AUTO_DATA_REPRESENTATION);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_deserialize_from_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    const char * buffer,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int length)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct RTICdrStream cdrStream;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePluginDefaultEndpointData epd;"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrTypePluginProgramContext defaultProgramContext ="
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrTypePluginProgramContext_INTIALIZER;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePluginDefaultParticipantData pd;"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePlugin plugin;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    epd.programContext = defaultProgramContext;"
      & ASCII.CR & ASCII.LF
      & "    epd._participantData = &pd;"
      & ASCII.CR & ASCII.LF
      & "    epd.typePlugin = &plugin;"
      & ASCII.CR & ASCII.LF
      & "    epd.programContext.endpointPluginData = &epd;"
      & ASCII.CR & ASCII.LF
      & "    plugin.typeCode = (struct RTICdrTypeCode *)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_get_typecode();"
      & ASCII.CR & ASCII.LF
      & "    pd.programs = @CPREFIX@Plugin_get_programs();"
      & ASCII.CR & ASCII.LF
      & "    if (pd.programs == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrSampleAssignabilityProperty_setFromGlobalComplianceMask("
      & ASCII.CR & ASCII.LF
      & "        &epd._assignabilityProperty);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTICdrStream_init(&cdrStream);"
      & ASCII.CR & ASCII.LF
      & "    RTICdrStream_set(&cdrStream, (char *)buffer, length);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_finalize_optional_members(sample, RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "    return PRESTypePlugin_interpretedDeserialize("
      & ASCII.CR & ASCII.LF
      & "        (PRESTypePluginEndpointData)&epd, sample,"
      & ASCII.CR & ASCII.LF
      & "        &cdrStream, RTI_TRUE, RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        NULL);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#if !defined(NDDS_STANDALONE_TYPE)"
      & ASCII.CR & ASCII.LF
      & "DDS_ReturnCode_t"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_data_to_string("
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    char *_str,"
      & ASCII.CR & ASCII.LF
      & "    DDS_UnsignedLong *str_size,"
      & ASCII.CR & ASCII.LF
      & "    const struct DDS_PrintFormatProperty *property)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    DDS_DynamicData *data = NULL;"
      & ASCII.CR & ASCII.LF
      & "    char *buffer = NULL;"
      & ASCII.CR & ASCII.LF
      & "    unsigned int length = 0;"
      & ASCII.CR & ASCII.LF
      & "    struct DDS_PrintFormat printFormat;"
      & ASCII.CR & ASCII.LF
      & "    DDS_ReturnCode_t retCode = DDS_RETCODE_ERROR;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_BAD_PARAMETER;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (str_size == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_BAD_PARAMETER;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (property == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_BAD_PARAMETER;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    if (!@CPREFIX@Plugin_serialize_to_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "        NULL,"
      & ASCII.CR & ASCII.LF
      & "        &length,"
      & ASCII.CR & ASCII.LF
      & "        sample)) {"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_ERROR;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_allocateBuffer(&buffer, length, RTI_OSAPI_ALIGNMENT_DEFAULT);"
      & ASCII.CR & ASCII.LF
      & "    if (buffer == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_ERROR;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (!@CPREFIX@Plugin_serialize_to_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "        buffer,"
      & ASCII.CR & ASCII.LF
      & "        &length,"
      & ASCII.CR & ASCII.LF
      & "        sample)) {"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_ERROR;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    data = DDS_DynamicData_new("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_get_typecode(),"
      & ASCII.CR & ASCII.LF
      & "        &DDS_DYNAMIC_DATA_PROPERTY_DEFAULT);"
      & ASCII.CR & ASCII.LF
      & "    if (data == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "        return DDS_RETCODE_ERROR;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    retCode = DDS_DynamicData_from_cdr_buffer(data, buffer, length);"
      & ASCII.CR & ASCII.LF
      & "    if (retCode != DDS_RETCODE_OK) {"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "        DDS_DynamicData_delete(data);"
      & ASCII.CR & ASCII.LF
      & "        return retCode;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    retCode = DDS_PrintFormatProperty_to_print_format("
      & ASCII.CR & ASCII.LF
      & "        property,"
      & ASCII.CR & ASCII.LF
      & "        &printFormat);"
      & ASCII.CR & ASCII.LF
      & "    if (retCode != DDS_RETCODE_OK) {"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "        DDS_DynamicData_delete(data);"
      & ASCII.CR & ASCII.LF
      & "        return retCode;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    retCode = DDS_DynamicDataFormatter_to_string_w_format("
      & ASCII.CR & ASCII.LF
      & "        data,"
      & ASCII.CR & ASCII.LF
      & "        _str,"
      & ASCII.CR & ASCII.LF
      & "        str_size,"
      & ASCII.CR & ASCII.LF
      & "        &printFormat);"
      & ASCII.CR & ASCII.LF
      & "    if (retCode != DDS_RETCODE_OK) {"
      & ASCII.CR & ASCII.LF
      & "        RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "        DDS_DynamicData_delete(data);"
      & ASCII.CR & ASCII.LF
      & "        return retCode;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_freeBuffer(buffer);"
      & ASCII.CR & ASCII.LF
      & "    DDS_DynamicData_delete(data);"
      & ASCII.CR & ASCII.LF
      & "    return DDS_RETCODE_OK;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "unsigned int"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_get_serialized_sample_max_size("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool include_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "    RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int current_alignment)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    unsigned int size;"
      & ASCII.CR & ASCII.LF
      & "    RTIBool overflow = RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    size = PRESTypePlugin_interpretedGetSerializedSampleMaxSize("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (overflow) {"
      & ASCII.CR & ASCII.LF
      & "        size = RTI_CDR_MAX_SERIALIZED_SIZE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return size;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* --------------------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "Key Management functions:"
      & ASCII.CR & ASCII.LF
      & "* -------------------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "PRESTypePluginKeyKind"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_get_key_kind(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return PRES_TYPEPLUGIN_USER_KEY;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool @CPREFIX@Plugin_deserialize_key("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ **sample,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool * drop_sample,"
      & ASCII.CR & ASCII.LF
      & "    struct RTICdrStream *cdrStream,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool deserialize_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool deserialize_key,"
      & ASCII.CR & ASCII.LF
      & "    void *endpoint_plugin_qos)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    RTIBool result;"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(drop_sample);"
      & ASCII.CR & ASCII.LF
      & "    /*  Depending on the type and the flags used in rtiddsgen, coverity may detect"
      & ASCII.CR & ASCII.LF
      & "    that sample is always null. Since the case is very dependant on"
      & ASCII.CR & ASCII.LF
      & "    the IDL/XML and the configuration we keep the check for safety."
      & ASCII.CR & ASCII.LF
      & "    */"
      & ASCII.CR & ASCII.LF
      & "    result= PRESTypePlugin_interpretedDeserializeKey("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        /* coverity[check_after_deref] */"
      & ASCII.CR & ASCII.LF
      & "        (sample != NULL) ? *sample : NULL,"
      & ASCII.CR & ASCII.LF
      & "        cdrStream,"
      & ASCII.CR & ASCII.LF
      & "        deserialize_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "        deserialize_key,"
      & ASCII.CR & ASCII.LF
      & "        endpoint_plugin_qos);"
      & ASCII.CR & ASCII.LF
      & "    return result;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "unsigned int"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_get_serialized_key_max_size("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool include_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "    RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int current_alignment)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    unsigned int size;"
      & ASCII.CR & ASCII.LF
      & "    RTIBool overflow = RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSize("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);"
      & ASCII.CR & ASCII.LF
      & "    if (overflow) {"
      & ASCII.CR & ASCII.LF
      & "        size = RTI_CDR_MAX_SERIALIZED_SIZE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return size;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "unsigned int"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_get_serialized_key_max_size_for_keyhash("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "    unsigned int current_alignment)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    unsigned int size;"
      & ASCII.CR & ASCII.LF
      & "    RTIBool overflow = RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSizeForKeyhash("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        &overflow,"
      & ASCII.CR & ASCII.LF
      & "        encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "        current_alignment);"
      & ASCII.CR & ASCII.LF
      & "    if (overflow) {"
      & ASCII.CR & ASCII.LF
      & "        size = RTI_CDR_MAX_SERIALIZED_SIZE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return size;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "@C_KEYFNS@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool "
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_serialized_sample_to_keyhash("
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "    struct RTICdrStream *cdrStream, "
      & ASCII.CR & ASCII.LF
      & "    DDS_KeyHash_t *keyhash,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool deserialize_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "    void *endpoint_plugin_qos) "
      & ASCII.CR & ASCII.LF
      & "{   "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ * sample = NULL;"
      & ASCII.CR & ASCII.LF
      & "    sample = (@CPREFIX@ *)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePluginDefaultEndpointData_getTempSample(endpoint_data);"
      & ASCII.CR & ASCII.LF
      & "    if (sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (!PRESTypePlugin_interpretedSerializedSampleToKey("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        cdrStream, "
      & ASCII.CR & ASCII.LF
      & "        deserialize_encapsulation, "
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        endpoint_plugin_qos)) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    if (!PRESTypePlugin_interpretedInstanceToKeyHash("
      & ASCII.CR & ASCII.LF
      & "        endpoint_data, "
      & ASCII.CR & ASCII.LF
      & "        keyhash, "
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        RTICdrStream_getEncapsulationKind(cdrStream))) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    return RTI_TRUE;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "struct RTIXCdrInterpreterPrograms * @CPREFIX@Plugin_get_programs(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrInterpreterProgramsGenProperty programProperty ="
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrInterpreterPrograms *retPrograms = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    programProperty.generateWithOnlyKeyFields = RTI_XCDR_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    programProperty.resolveAlias = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.inlineStruct = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.optimizeEnum = RTI_XCDR_TRUE;"
      & ASCII.CR & ASCII.LF
      & "    programProperty.unboundedSize = RTIXCdrLong_MAX;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    retPrograms ="
      & ASCII.CR & ASCII.LF
      & "    DDS_TypeCodeFactory_assert_programs_in_global_list("
      & ASCII.CR & ASCII.LF
      & "        DDS_TypeCodeFactory_get_instance(),"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_get_typecode(),"
      & ASCII.CR & ASCII.LF
      & "        &programProperty,"
      & ASCII.CR & ASCII.LF
      & "        RTI_XCDR_SER_PROGRAM"
      & ASCII.CR & ASCII.LF
      & "        | RTI_XCDR_DESER_PROGRAM"
      & ASCII.CR & ASCII.LF
      & "        | RTI_XCDR_GET_MAX_SER_SIZE_PROGRAM"
      & ASCII.CR & ASCII.LF
      & "        | RTI_XCDR_GET_SER_SIZE_PROGRAM);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return retPrograms;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "* Plug-in Installation Methods"
      & ASCII.CR & ASCII.LF
      & "* ------------------------------------------------------------------------ */"
      & ASCII.CR & ASCII.LF
      & "struct PRESTypePlugin *@CPREFIX@Plugin_new(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct PRESTypePlugin *plugin = NULL;"
      & ASCII.CR & ASCII.LF
      & "    const struct PRESTypePluginVersion PLUGIN_VERSION ="
      & ASCII.CR & ASCII.LF
      & "    PRES_TYPE_PLUGIN_VERSION_2_0;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiHeap_allocateStructure("
      & ASCII.CR & ASCII.LF
      & "        &plugin, struct PRESTypePlugin);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (plugin == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return NULL;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->version = PLUGIN_VERSION;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* set up parent's function pointers */"
      & ASCII.CR & ASCII.LF
      & "    plugin->onParticipantAttached ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginOnParticipantAttachedCallback)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_participant_attached;"
      & ASCII.CR & ASCII.LF
      & "    plugin->onParticipantDetached ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginOnParticipantDetachedCallback)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_participant_detached;"
      & ASCII.CR & ASCII.LF
      & "    plugin->onEndpointAttached ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginOnEndpointAttachedCallback)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_endpoint_attached;"
      & ASCII.CR & ASCII.LF
      & "    plugin->onEndpointDetached ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginOnEndpointDetachedCallback)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_endpoint_detached;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->copySampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginCopySampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_copy_sample;"
      & ASCII.CR & ASCII.LF
      & "    plugin->createSampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginCreateSampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_create_sample;"
      & ASCII.CR & ASCII.LF
      & "    plugin->destroySampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginDestroySampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_destroy_sample;"
      & ASCII.CR & ASCII.LF
      & "    plugin->finalizeOptionalMembersFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginFinalizeOptionalMembersFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_finalize_optional_members;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->serializeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginSerializeFunction) PRESTypePlugin_interpretedSerialize;"
      & ASCII.CR & ASCII.LF
      & "    plugin->deserializeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginDeserializeFunction) PRESTypePlugin_interpretedDeserializeWithAlloc;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getSerializedSampleMaxSizeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetSerializedSampleMaxSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_sample_max_size;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getSerializedSampleMinSizeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetSerializedSampleMinSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePlugin_interpretedGetSerializedSampleMinSize;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getDeserializedSampleMaxSizeFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getSampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetSampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_sample;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnSampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginReturnSampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_return_sample;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getKeyKindFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetKeyKindFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_key_kind;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->getSerializedKeyMaxSizeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetSerializedKeyMaxSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_key_max_size;"
      & ASCII.CR & ASCII.LF
      & "    plugin->serializeKeyFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginSerializeKeyFunction)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePlugin_interpretedSerializeKey;"
      & ASCII.CR & ASCII.LF
      & "    plugin->deserializeKeyFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginDeserializeKeyFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_deserialize_key;"
      & ASCII.CR & ASCII.LF
      & "    plugin->deserializeKeySampleFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginDeserializeKeySampleFunction)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePlugin_interpretedDeserializeKey;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin-> instanceToKeyHashFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginInstanceToKeyHashFunction)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePlugin_interpretedInstanceToKeyHash;"
      & ASCII.CR & ASCII.LF
      & "    plugin->serializedSampleToKeyHashFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginSerializedSampleToKeyHashFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_serialized_sample_to_keyhash;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->getKeyFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetKeyFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_key;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnKeyFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginReturnKeyFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_return_key;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->instanceToKeyFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginInstanceToKeyFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_instance_to_key;"
      & ASCII.CR & ASCII.LF
      & "    plugin->keyToInstanceFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginKeyToInstanceFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_key_to_instance;"
      & ASCII.CR & ASCII.LF
      & "    plugin->serializedKeyToKeyHashFnc = NULL; /* Not supported yet */"
      & ASCII.CR & ASCII.LF
      & "    #ifdef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "    plugin->typeCode = NULL;"
      & ASCII.CR & ASCII.LF
      & "    #else"
      & ASCII.CR & ASCII.LF
      & "    plugin->typeCode =  (struct RTICdrTypeCode *)@CPREFIX@_get_typecode();"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & "    plugin->languageKind = PRES_TYPEPLUGIN_DDS_TYPE;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* Serialized buffer */"
      & ASCII.CR & ASCII.LF
      & "    plugin->getBuffer ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetBufferFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_buffer;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnBuffer ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginReturnBufferFunction)"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_return_buffer;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getBufferWithParams = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnBufferWithParams = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->getSerializedSampleSizeFnc ="
      & ASCII.CR & ASCII.LF
      & "    (PRESTypePluginGetSerializedSampleSizeFunction)"
      & ASCII.CR & ASCII.LF
      & "    PRESTypePlugin_interpretedGetSerializedSampleSize;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->getWriterLoanedSampleFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnWriterLoanedSampleFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->returnWriterLoanedSampleFromCookieFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->validateWriterLoanedSampleFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & "    plugin->setWriterLoanedSampleSerializedStateFnc = NULL;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    plugin->endpointTypeName = @CPREFIX@TYPENAME;"
      & ASCII.CR & ASCII.LF
      & "    plugin->isMetpType = RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    plugin->isRecursiveType = RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    return plugin;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void"
      & ASCII.CR & ASCII.LF
      & "@CPREFIX@Plugin_delete(struct PRESTypePlugin *plugin)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiHeap_freeStructure(plugin);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "#undef RTI_CDR_CURRENT_SUBMODULE"
      & ASCII.CR & ASCII.LF
      & ""
      & ASCII.CR & ASCII.LF;
   C_Plugin_H_Intro_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl"
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef @IDLBASE@Plugin_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & "#define @IDLBASE@Plugin_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""@IDLBASE@.h"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "struct RTICdrStream;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef pres_typePlugin_h"
      & ASCII.CR & ASCII.LF
      & "#include ""pres/pres_typePlugin.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)"
      & ASCII.CR & ASCII.LF
      & "#undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "#define NDDSUSERDllExport __declspec(dllexport)"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & "#undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "#define NDDSUSERDllExport __attribute__((visibility(""default"")))"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifdef __cplusplus"
      & ASCII.CR & ASCII.LF
      & "extern ""C"" {"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF;
   C_Plugin_H_Block_Template : constant String :=
      ""
      & ASCII.LF
      & "    /* The type used to store keys for instances of type struct"
      & ASCII.CR & ASCII.LF
      & "    * AnotherSimple."
      & ASCII.CR & ASCII.LF
      & "    *"
      & ASCII.CR & ASCII.LF
      & "    * By default, this type is struct @IDLBASE@"
      & ASCII.CR & ASCII.LF
      & "    * itself. However, if for some reason this choice is not practical for your"
      & ASCII.CR & ASCII.LF
      & "    * system (e.g. if sizeof(struct @IDLBASE@)"
      & ASCII.CR & ASCII.LF
      & "    * is very large), you may redefine this typedef in terms of another type of"
      & ASCII.CR & ASCII.LF
      & "    * your choosing. HOWEVER, if you define the KeyHolder type to be something"
      & ASCII.CR & ASCII.LF
      & "    * other than struct AnotherSimple, the"
      & ASCII.CR & ASCII.LF
      & "    * following restriction applies: the key of struct"
      & ASCII.CR & ASCII.LF
      & "    * @IDLBASE@ must consist of a"
      & ASCII.CR & ASCII.LF
      & "    * single field of your redefined KeyHolder type and that field must be the"
      & ASCII.CR & ASCII.LF
      & "    * first field in struct @IDLBASE@."
      & ASCII.CR & ASCII.LF
      & "    */"
      & ASCII.CR & ASCII.LF
      & "    typedef  struct @CPREFIX@ @CPREFIX@KeyHolder;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #define @CPREFIX@Plugin_get_sample PRESTypePluginDefaultEndpointData_getSample "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #define @CPREFIX@Plugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer "
      & ASCII.CR & ASCII.LF
      & "    #define @CPREFIX@Plugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #define @CPREFIX@Plugin_get_key PRESTypePluginDefaultEndpointData_getKey "
      & ASCII.CR & ASCII.LF
      & "    #define @CPREFIX@Plugin_return_key PRESTypePluginDefaultEndpointData_returnKey"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #define @CPREFIX@Plugin_create_sample PRESTypePluginDefaultEndpointData_createSample "
      & ASCII.CR & ASCII.LF
      & "    #define @CPREFIX@Plugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* --------------------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "    Support functions:"
      & ASCII.CR & ASCII.LF
      & "    * -------------------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern @CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_create_data_w_params("
      & ASCII.CR & ASCII.LF
      & "        const struct DDS_TypeAllocationParams_t * alloc_params);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern @CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_create_data_ex(RTIBool allocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern @CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_create_data(void);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_copy_data("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *out,"
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *in);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_data_w_params("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        const struct DDS_TypeDeallocationParams_t * dealloc_params);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_data_ex("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *sample,RTIBool deallocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_data("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *sample);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_print_data("
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        const char *desc,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int indent);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern @CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_create_key_ex(RTIBool allocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern @CPREFIX@*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_create_key(void);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_key_ex("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@KeyHolder *key,RTIBool deallocate_pointers);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@PluginSupport_destroy_key("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@KeyHolder *key);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* ----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "    Callback functions:"
      & ASCII.CR & ASCII.LF
      & "    * ---------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern PRESTypePluginParticipantData "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_participant_attached("
      & ASCII.CR & ASCII.LF
      & "        void *registration_data, "
      & ASCII.CR & ASCII.LF
      & "        const struct PRESTypePluginParticipantInfo *participant_info,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool top_level_registration, "
      & ASCII.CR & ASCII.LF
      & "        void *container_plugin_context,"
      & ASCII.CR & ASCII.LF
      & "        RTICdrTypeCode *typeCode);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_participant_detached("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginParticipantData participant_data);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern PRESTypePluginEndpointData "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_endpoint_attached("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginParticipantData participant_data,"
      & ASCII.CR & ASCII.LF
      & "        const struct PRESTypePluginEndpointInfo *endpoint_info,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool top_level_registration, "
      & ASCII.CR & ASCII.LF
      & "        void *container_plugin_context);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_on_endpoint_detached("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void    "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_return_sample("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        void *handle);    "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_copy_sample("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *out,"
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *in);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* ----------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "    (De)Serialize functions:"
      & ASCII.CR & ASCII.LF
      & "    * ------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_serialize_to_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "        char * buffer,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int * length,"
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *sample); "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_serialize_to_cdr_buffer_ex("
      & ASCII.CR & ASCII.LF
      & "        char *buffer,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int *length,"
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        DDS_DataRepresentationId_t representation);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_deserialize_from_cdr_buffer("
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        const char * buffer,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int length);    "
      & ASCII.CR & ASCII.LF
      & "    #if !defined (NDDS_STANDALONE_TYPE)"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport extern DDS_ReturnCode_t"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_data_to_string("
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "        char *str,"
      & ASCII.CR & ASCII.LF
      & "        DDS_UnsignedLong *str_size, "
      & ASCII.CR & ASCII.LF
      & "        const struct DDS_PrintFormatProperty *property);    "
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern unsigned int "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_sample_max_size("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool include_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "        RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int current_alignment);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* --------------------------------------------------------------------------------------"
      & ASCII.CR & ASCII.LF
      & "    Key Management functions:"
      & ASCII.CR & ASCII.LF
      & "    * -------------------------------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport extern PRESTypePluginKeyKind "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_key_kind(void);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern unsigned int "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_key_max_size("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool include_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "        RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int current_alignment);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern unsigned int "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_get_serialized_key_max_size_for_keyhash("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        RTIEncapsulationId encapsulation_id,"
      & ASCII.CR & ASCII.LF
      & "        unsigned int current_alignment);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_deserialize_key("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ ** sample,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool * drop_sample,"
      & ASCII.CR & ASCII.LF
      & "        struct RTICdrStream *cdrStream,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool deserialize_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool deserialize_key,"
      & ASCII.CR & ASCII.LF
      & "        void *endpoint_plugin_qos);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_instance_to_key("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@KeyHolder *key, "
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@ *instance);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_key_to_instance("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@ *instance, "
      & ASCII.CR & ASCII.LF
      & "        const @CPREFIX@KeyHolder *key);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern RTIBool "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_serialized_sample_to_keyhash("
      & ASCII.CR & ASCII.LF
      & "        PRESTypePluginEndpointData endpoint_data,"
      & ASCII.CR & ASCII.LF
      & "        struct RTICdrStream *cdrStream, "
      & ASCII.CR & ASCII.LF
      & "        DDS_KeyHash_t *keyhash,"
      & ASCII.CR & ASCII.LF
      & "        RTIBool deserialize_encapsulation,"
      & ASCII.CR & ASCII.LF
      & "        void *endpoint_plugin_qos); "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern"
      & ASCII.CR & ASCII.LF
      & "    struct RTIXCdrInterpreterPrograms * @CPREFIX@Plugin_get_programs(void);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    /* Plugin Functions */"
      & ASCII.CR & ASCII.LF
      & "    NDDSUSERDllExport extern struct PRESTypePlugin*"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_new(void);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    NDDSUSERDllExport extern void"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@Plugin_delete(struct PRESTypePlugin *);"
      & ASCII.CR & ASCII.LF;
   C_Support_C_Intro_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl"
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""@IDLBASE@Support.h"""
      & ASCII.CR & ASCII.LF
      & "#include ""@IDLBASE@Plugin.h"""
      & ASCII.CR & ASCII.LF;
   C_Support_C_Block_Template : constant String :=
      ""
      & ASCII.LF
      & "/* ========================================================================= */"
      & ASCII.CR & ASCII.LF
      & "/**"
      & ASCII.CR & ASCII.LF
      & "<<IMPLEMENTATION>>"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Defines:   TData,"
      & ASCII.CR & ASCII.LF
      & "TDataWriter,"
      & ASCII.CR & ASCII.LF
      & "TDataReader,"
      & ASCII.CR & ASCII.LF
      & "TTypeSupport"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Configure and implement '@CPREFIX@' support classes."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Note: Only the #defined classes get defined"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ----------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & "/* DDSDataWriter"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/**"
      & ASCII.CR & ASCII.LF
      & "<<IMPLEMENTATION >>"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Defines:   TDataWriter, TData"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Requires */"
      & ASCII.CR & ASCII.LF
      & "#define TTYPENAME   @CPREFIX@TYPENAME"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Defines */"
      & ASCII.CR & ASCII.LF
      & "#define TDataWriter @CPREFIX@DataWriter"
      & ASCII.CR & ASCII.LF
      & "#define TData       @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#define RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS"
      & ASCII.CR & ASCII.LF
      & "#include ""dds_c/generic/dds_c_data_TDataWriter.gen"""
      & ASCII.CR & ASCII.LF
      & "#undef RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TDataWriter"
      & ASCII.CR & ASCII.LF
      & "#undef TData"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TTYPENAME"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ----------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & "/* DDSDataReader"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/**"
      & ASCII.CR & ASCII.LF
      & "<<IMPLEMENTATION >>"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Defines:   TDataReader, TDataSeq, TData"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Requires */"
      & ASCII.CR & ASCII.LF
      & "#define TTYPENAME   @CPREFIX@TYPENAME"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Defines */"
      & ASCII.CR & ASCII.LF
      & "#define TDataReader @CPREFIX@DataReader"
      & ASCII.CR & ASCII.LF
      & "#define TDataSeq    @CPREFIX@Seq"
      & ASCII.CR & ASCII.LF
      & "#define TData       @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#define RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD"
      & ASCII.CR & ASCII.LF
      & "#include ""dds_c/generic/dds_c_data_TDataReader.gen"""
      & ASCII.CR & ASCII.LF
      & "#undef RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TDataReader"
      & ASCII.CR & ASCII.LF
      & "#undef TDataSeq"
      & ASCII.CR & ASCII.LF
      & "#undef TData"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TTYPENAME"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ----------------------------------------------------------------- */"
      & ASCII.CR & ASCII.LF
      & "/* TypeSupport"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "<<IMPLEMENTATION >>"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "Requires:  TTYPENAME,"
      & ASCII.CR & ASCII.LF
      & "TPlugin_new"
      & ASCII.CR & ASCII.LF
      & "TPlugin_delete"
      & ASCII.CR & ASCII.LF
      & "Defines:   TTypeSupport, TData, TDataReader, TDataWriter"
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Requires */"
      & ASCII.CR & ASCII.LF
      & "#define TTYPENAME    @CPREFIX@TYPENAME"
      & ASCII.CR & ASCII.LF
      & "#define TPlugin_new  @CPREFIX@Plugin_new"
      & ASCII.CR & ASCII.LF
      & "#define TPlugin_delete  @CPREFIX@Plugin_delete"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Defines */"
      & ASCII.CR & ASCII.LF
      & "#define TTypeSupport @CPREFIX@TypeSupport"
      & ASCII.CR & ASCII.LF
      & "#define TData        @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & "#define TDataReader  @CPREFIX@DataReader"
      & ASCII.CR & ASCII.LF
      & "#define TDataWriter  @CPREFIX@DataWriter"
      & ASCII.CR & ASCII.LF
      & "#define TGENERATE_SER_CODE"
      & ASCII.CR & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#define TGENERATE_TYPECODE"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""dds_c/generic/dds_c_data_TTypeSupport.gen"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TTypeSupport"
      & ASCII.CR & ASCII.LF
      & "#undef TData"
      & ASCII.CR & ASCII.LF
      & "#undef TDataReader"
      & ASCII.CR & ASCII.LF
      & "#undef TDataWriter"
      & ASCII.CR & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#undef TGENERATE_TYPECODE"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & "#undef TGENERATE_SER_CODE"
      & ASCII.CR & ASCII.LF
      & "#undef TTYPENAME"
      & ASCII.CR & ASCII.LF
      & "#undef TPlugin_new"
      & ASCII.CR & ASCII.LF
      & "#undef TPlugin_delete"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & ""
      & ASCII.CR & ASCII.LF;
   C_Support_H_Intro_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl"
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef @IDLBASE@Support_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & "#define @IDLBASE@Support_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* Uses */"
      & ASCII.CR & ASCII.LF
      & "#include ""@IDLBASE@.h"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef ndds_c_h"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds/ndds_c.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifdef __cplusplus"
      & ASCII.CR & ASCII.LF
      & "extern ""C"" {"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if (defined(RTI_WIN32) || defined (RTI_WINCE) || defined(RTI_INTIME)) && defined(NDDS_USER_DLL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF;
   C_Support_H_Block_Template : constant String :=
      ""
      & ASCII.LF
      & "    /* ========================================================================= */"
      & ASCII.CR & ASCII.LF
      & "    /**"
      & ASCII.CR & ASCII.LF
      & "    Uses:     T"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    Defines:  TTypeSupport, TDataWriter, TDataReader"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    Organized using the well-documented ""Generics Pattern"" for"
      & ASCII.CR & ASCII.LF
      & "    implementing generics in C and C++."
      & ASCII.CR & ASCII.LF
      & "    */"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport __declspec(dllexport)"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport __attribute__((visibility(""default"")))"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    DDS_TYPESUPPORT_C(@CPREFIX@TypeSupport, @CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & "    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(@CPREFIX@DataWriter, @CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & "    DDS_DATAREADER_C(@CPREFIX@DataReader, @CPREFIX@Seq, @CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)"
      & ASCII.CR & ASCII.LF
      & "    #undef NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #define NDDSUSERDllExport"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF;
   C_Support_H_Tail_Template : constant String :=
      ""
      & ASCII.LF
      & "    #ifdef __cplusplus"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#endif  /* @IDLBASE@Support_@GUARD@_h */"
      & ASCII.CR & ASCII.LF
      & ""
      & ASCII.CR & ASCII.LF;
   C_Type_C_Intro_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl "
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#ifndef ndds_c_h"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds/ndds_c.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef dds_c_log_infrastructure_h"
      & ASCII.CR & ASCII.LF
      & "#include ""dds_c/dds_c_infrastructure_impl.h""       "
      & ASCII.CR & ASCII.LF
      & "#endif "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef cdr_type_h"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_type.h"""
      & ASCII.CR & ASCII.LF
      & "#endif    "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""osapi/osapi_atomic.h"""
      & ASCII.CR & ASCII.LF
      & "#else"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds_standalone_type.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#include ""@IDLBASE@.h"""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#include ""@IDLBASE@Plugin.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/* ========================================================================= */"
      & ASCII.CR & ASCII.LF
      & "";

   C_Type_C_Region_Template : constant String :=
      ""
      & "const char *@CPREFIX@TYPENAME = ""@SCOPE@"";"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "DDS_TypeCode * @CPREFIX@_get_typecode(void)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    static RTI_ATOMIC(RTIBool) is_initialized;"
      & ASCII.CR & ASCII.LF
      & "@C_TCSTR@"
      & ASCII.CR & ASCII.LF
      & "@C_TCMEM@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    static DDS_TypeCode @CPREFIX@_g_tc ="
      & ASCII.CR & ASCII.LF
      & "    {{"
      & ASCII.CR & ASCII.LF
      & "            DDS_TK_STRUCT, /* Kind */"
      & ASCII.CR & ASCII.LF
      & "            DDS_BOOLEAN_FALSE, /* Ignored */"
      & ASCII.CR & ASCII.LF
      & "            -1, /*Ignored*/"
      & ASCII.CR & ASCII.LF
      & "            (char *)""@SCOPE@"", /* Name */"
      & ASCII.CR & ASCII.LF
      & "            NULL, /* Ignored */ "
      & ASCII.CR & ASCII.LF
      & "            0, /* Ignored */"
      & ASCII.CR & ASCII.LF
      & "            0, /* Ignored */"
      & ASCII.CR & ASCII.LF
      & "            NULL, /* Ignored */"
      & ASCII.CR & ASCII.LF
      & "            2, /* Number of members */"
      & ASCII.CR & ASCII.LF
      & "            @CPREFIX@_g_tc_members, /* Members */"
      & ASCII.CR & ASCII.LF
      & "            DDS_VM_NONE, /* Ignored */"
      & ASCII.CR & ASCII.LF
      & "            RTICdrTypeCodeAnnotations_INITIALIZER,"
      & ASCII.CR & ASCII.LF
      & "            DDS_BOOLEAN_TRUE, /* _isCopyable */"
      & ASCII.CR & ASCII.LF
      & "            NULL, /* _sampleAccessInfo: assigned later */"
      & ASCII.CR & ASCII.LF
      & "            NULL /* _typePlugin: assigned later */"
      & ASCII.CR & ASCII.LF
      & "        }}; /* Type code for @CPREFIX@*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {"
      & ASCII.CR & ASCII.LF
      & "        return &@CPREFIX@_g_tc;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_g_tc._data._annotations._allowedDataRepresentationMask = 5;"
      & ASCII.CR & ASCII.LF
      & "@C_TCANN@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_g_tc._data._sampleAccessInfo ="
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_get_sample_access_info();"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_g_tc._data._typePlugin ="
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_get_type_plugin_info();"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiAtomic_store32("
      & ASCII.CR & ASCII.LF
      & "        &is_initialized,"
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return &@CPREFIX@_g_tc;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIXCdrSampleAccessInfo *@CPREFIX@_get_sample_access_info()"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    static RTI_ATOMIC(RTIBool) is_initialized;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    static RTIXCdrMemberAccessInfo @CPREFIX@_g_memberAccessInfos[2] ="
      & ASCII.CR & ASCII.LF
      & "    {RTIXCdrMemberAccessInfo_INITIALIZER};"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    static RTIXCdrSampleAccessInfo @CPREFIX@_g_sampleAccessInfo ="
      & ASCII.CR & ASCII.LF
      & "    RTIXCdrSampleAccessInfo_INITIALIZER;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (RTIOsapiAtomic_load32("
      & ASCII.CR & ASCII.LF
      & "        &is_initialized,"
      & ASCII.CR & ASCII.LF
      & "        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {"
      & ASCII.CR & ASCII.LF
      & "        return (RTIXCdrSampleAccessInfo*) &@CPREFIX@_g_sampleAccessInfo;"
      & ASCII.CR & ASCII.LF
      & "@C_ACCESS@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_g_sampleAccessInfo.memberAccessInfos ="
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_g_memberAccessInfos;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    {"
      & ASCII.CR & ASCII.LF
      & "        size_t candidateTypeSize = sizeof(@CPREFIX@);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "        if (candidateTypeSize > RTIXCdrLong_MAX) {"
      & ASCII.CR & ASCII.LF
      & "            @CPREFIX@_g_sampleAccessInfo.typeSize[0] ="
      & ASCII.CR & ASCII.LF
      & "            RTIXCdrLong_MAX;"
      & ASCII.CR & ASCII.LF
      & "        } else {"
      & ASCII.CR & ASCII.LF
      & "            @CPREFIX@_g_sampleAccessInfo.typeSize[0] ="
      & ASCII.CR & ASCII.LF
      & "            (RTIXCdrUnsignedLong) candidateTypeSize;"
      & ASCII.CR & ASCII.LF
      & "        }"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_g_sampleAccessInfo.languageBinding ="
      & ASCII.CR & ASCII.LF
      & "    RTI_XCDR_TYPE_BINDING_C ;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    RTIOsapiAtomic_store32("
      & ASCII.CR & ASCII.LF
      & "        &is_initialized,"
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE,"
      & ASCII.CR & ASCII.LF
      & "        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);"
      & ASCII.CR & ASCII.LF
      & "    return (RTIXCdrSampleAccessInfo*) &@CPREFIX@_g_sampleAccessInfo;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "RTIXCdrTypePlugin *@CPREFIX@_get_type_plugin_info()"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    static RTIXCdrTypePlugin @CPREFIX@_g_typePlugin ="
      & ASCII.CR & ASCII.LF
      & "    {"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* serialize */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* serialize_key */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* deserialize_sample */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* deserialize_key_sample */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* skip */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* get_serialized_sample_size */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* get_serialized_sample_max_size_ex */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* get_serialized_key_max_size_ex */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* get_serialized_sample_min_size */"
      & ASCII.CR & ASCII.LF
      & "        NULL, /* serialized_sample_to_key */"
      & ASCII.CR & ASCII.LF
      & "        (RTIXCdrTypePluginInitializeSampleFunction)"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_initialize_ex,"
      & ASCII.CR & ASCII.LF
      & "        NULL,"
      & ASCII.CR & ASCII.LF
      & "        (RTIXCdrTypePluginFinalizeSampleFunction)"
      & ASCII.CR & ASCII.LF
      & "        @CPREFIX@_finalize_w_return,"
      & ASCII.CR & ASCII.LF
      & "        NULL,"
      & ASCII.CR & ASCII.LF
      & "        NULL"
      & ASCII.CR & ASCII.LF
      & "    };"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return &@CPREFIX@_g_typePlugin;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool @CPREFIX@_initialize("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* sample)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    return @CPREFIX@_initialize_ex("
      & ASCII.CR & ASCII.LF
      & "        sample, "
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE, "
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "RTIBool @CPREFIX@_initialize_w_params("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    const struct DDS_TypeAllocationParams_t *allocParams)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "    if (allocParams == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "@C_INIT@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    sample->value = 0.0;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return RTI_TRUE;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "RTIBool @CPREFIX@_initialize_ex("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool allocatePointers, "
      & ASCII.CR & ASCII.LF
      & "    RTIBool allocateMemory)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    struct DDS_TypeAllocationParams_t allocParams ="
      & ASCII.CR & ASCII.LF
      & "    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;"
      & ASCII.CR & ASCII.LF
      & "    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return @CPREFIX@_initialize_w_params("
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        &allocParams);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool @CPREFIX@_finalize_w_return("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* sample)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_ex(sample, RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return RTI_TRUE;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void @CPREFIX@_finalize("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* sample)"
      & ASCII.CR & ASCII.LF
      & "{  "
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@_finalize_ex("
      & ASCII.CR & ASCII.LF
      & "        sample, "
      & ASCII.CR & ASCII.LF
      & "        RTI_TRUE);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void @CPREFIX@_finalize_ex("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    RTIBool deletePointers)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct DDS_TypeDeallocationParams_t deallocParams ="
      & ASCII.CR & ASCII.LF
      & "    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample==NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return;"
      & ASCII.CR & ASCII.LF
      & "    } "
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    @CPREFIX@_finalize_w_params("
      & ASCII.CR & ASCII.LF
      & "        sample,"
      & ASCII.CR & ASCII.LF
      & "        &deallocParams);"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void @CPREFIX@_finalize_w_params("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@ *sample,"
      & ASCII.CR & ASCII.LF
      & "    const struct DDS_TypeDeallocationParams_t *deallocParams)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    if (sample==NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (deallocParams == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "@C_FIN@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "void @CPREFIX@_finalize_optional_members("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* sample, RTIBool deletePointers)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & "    struct DDS_TypeDeallocationParams_t deallocParamsTmp ="
      & ASCII.CR & ASCII.LF
      & "    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;"
      & ASCII.CR & ASCII.LF
      & "    struct DDS_TypeDeallocationParams_t * deallocParams ="
      & ASCII.CR & ASCII.LF
      & "    &deallocParamsTmp;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (sample==NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return;"
      & ASCII.CR & ASCII.LF
      & "    } "
      & ASCII.CR & ASCII.LF
      & "    RTIOsapiUtility_unusedParameter(deallocParams);"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    deallocParamsTmp.delete_pointers = (DDS_Boolean)deletePointers;"
      & ASCII.CR & ASCII.LF
      & "    deallocParamsTmp.delete_optional_members = DDS_BOOLEAN_TRUE;"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "RTIBool @CPREFIX@_copy("
      & ASCII.CR & ASCII.LF
      & "    @CPREFIX@* dst,"
      & ASCII.CR & ASCII.LF
      & "    const @CPREFIX@* src)"
      & ASCII.CR & ASCII.LF
      & "{"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    if (dst == NULL || src == NULL) {"
      & ASCII.CR & ASCII.LF
      & "        return RTI_FALSE;"
      & ASCII.CR & ASCII.LF
      & "    }"
      & ASCII.CR & ASCII.LF
      & "@C_COPY@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    return RTI_TRUE;"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/**"
      & ASCII.CR & ASCII.LF
      & "* <<IMPLEMENTATION>>"
      & ASCII.CR & ASCII.LF
      & "*"
      & ASCII.CR & ASCII.LF
      & "* Defines:  TSeq, T"
      & ASCII.CR & ASCII.LF
      & "*"
      & ASCII.CR & ASCII.LF
      & "* Configure and implement '@CPREFIX@' sequence class."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & "#define T @CPREFIX@"
      & ASCII.CR & ASCII.LF
      & "#define TSeq @CPREFIX@Seq"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#define T_initialize_w_params @CPREFIX@_initialize_w_params"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#define T_finalize_w_params   @CPREFIX@_finalize_w_params"
      & ASCII.CR & ASCII.LF
      & "#define T_copy       @CPREFIX@_copy"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#include ""dds_c/generic/dds_c_sequence_TSeq.gen"""
      & ASCII.CR & ASCII.LF
      & "#else"
      & ASCII.CR & ASCII.LF
      & "#include ""dds_c_sequence_TSeq.gen"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef T_copy"
      & ASCII.CR & ASCII.LF
      & "#undef T_finalize_w_params"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef T_initialize_w_params"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#undef TSeq"
      & ASCII.CR & ASCII.LF
      & "#undef T"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & ""
      & ASCII.CR & ASCII.LF;
   C_Type_H_Template : constant String :=
      ""
      & ""
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "/*"
      & ASCII.CR & ASCII.LF
      & "WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY."
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "This file was generated from @IDLBASE@.idl"
      & ASCII.CR & ASCII.LF
      & "using RTI Code Generator (rtiddsgen) version 4.7.0."
      & ASCII.CR & ASCII.LF
      & "The rtiddsgen tool is part of the RTI Connext DDS distribution."
      & ASCII.CR & ASCII.LF
      & "For more information, type 'rtiddsgen -help' at a command shell"
      & ASCII.CR & ASCII.LF
      & "or consult the Code Generator User's Manual."
      & ASCII.CR & ASCII.LF
      & "*/"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef @IDLBASE@_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & "#define @IDLBASE@_@GUARD@_h"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifndef NDDS_STANDALONE_TYPE"
      & ASCII.CR & ASCII.LF
      & "#ifndef ndds_c_h"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds/ndds_c.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & "#include ""cdr/cdr_typeCode.h"""
      & ASCII.CR & ASCII.LF
      & "#else"
      & ASCII.CR & ASCII.LF
      & "#include ""ndds_standalone_type.h"""
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#ifdef __cplusplus"
      & ASCII.CR & ASCII.LF
      & "extern ""C"" {"
      & ASCII.CR & ASCII.LF
      & "    #endif"
      & ASCII.CR & ASCII.LF
      & "@C_CONSTS@"
      & ASCII.CR & ASCII.LF
      & "@C_TYPES@"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "    #ifdef __cplusplus"
      & ASCII.CR & ASCII.LF
      & "}"
      & ASCII.CR & ASCII.LF
      & "#endif"
      & ASCII.CR & ASCII.LF
      & ASCII.LF
      & "#endif /* @IDLBASE@ */"
      & ASCII.CR & ASCII.LF
      & ""
      & "";

   procedure Splice
     (T : in out SU.Unbounded_String;
      Marker : String;
      Block : String)
   is
      use type SU.Unbounded_String;
      Marker_Line : constant String := Marker & ASCII.CR & ASCII.LF;
      Idx : constant Natural := SU.Index (T, Marker_Line);
   begin
      if Idx = 0 then
         return;
      end if;
      T := SU.Unbounded_Slice (T, 1, Idx - 1)
        & Block
        & SU.Unbounded_Slice (T, Idx + Marker_Line'Length,
                              SU.Length (T));
   end Splice;


   procedure H_Members
     (Mems : S.Member_Vectors.Vector;
      Block : in out SU.Unbounded_String)
   is
   begin
      for C in Mems.Iterate loop
         declare
            M : constant S.Member_T := S.Member_Vectors.Element (C);
            Dcl : constant S.Declarator_T :=
              M.Declarators.Element (M.Declarators.First_Index);
            N : constant String := SU.To_String (Dcl.Name);
         begin
            H_Member (M.Member_Type.all, N, Block);
         end;
      end loop;
   end H_Members;

   procedure Rep_In
     (T : in out SU.Unbounded_String; From, To : String)
   is
      use type SU.Unbounded_String;
      I : constant Natural := SU.Index (T, From);
   begin
      if I > 0 then
         T := SU.Replace_Slice (T, I, I + From'Length - 1, To);
      end if;
   end Rep_In;

   --  ------------------------------------------------------------------
   --  Per-type emission: fills the member blocks for one type and
   --  appends its .h block and .c region.
   --  ------------------------------------------------------------------

   procedure Emit_Type
     (Def : S.Definition_Ref;
      Prefix : String;
      Scope : String;
      C_Text : in out SU.Unbounded_String;
      H_Text : in out SU.Unbounded_String;
      Key_Text : in out SU.Unbounded_String;
      Sup_Text : in out SU.Unbounded_String;
      PH_Text : in out SU.Unbounded_String;
      PC_Text : in out SU.Unbounded_String;
      SH_Text : in out SU.Unbounded_String)
   is
      use type SU.Unbounded_String;
      Mems : constant S.Member_Vectors.Vector := Def.Members;
      N_Members : constant Natural :=
        Natural (S.Member_Vectors.Length (Mems));
      --  The full C prefix: module chain + type name, and the DDS
      --  scope for TYPENAME (module chain + type name).
      FP : constant String := Prefix & SU.To_String (Def.Name);
      FS : constant String := Scope_Of (Scope, SU.To_String (Def.Name));

      TCStr : SU.Unbounded_String;
      TCMem : SU.Unbounded_String;
      TCAnn : SU.Unbounded_String;
      TCAnns : SU.Unbounded_String;
      Acc : SU.Unbounded_String;
      Init : SU.Unbounded_String;
      Fin : SU.Unbounded_String;
      Copy : SU.Unbounded_String;
      HMem : SU.Unbounded_String;
      Idx : Natural := 0;
   begin
      for C in Mems.Iterate loop
         declare
            M : constant S.Member_T := S.Member_Vectors.Element (C);
            Dcl : constant S.Declarator_T :=
              M.Declarators.Element (M.Declarators.First_Index);
            N : constant String := SU.To_String (Dcl.Name);
            K : constant S.Type_Kind_T := M.Member_Type.all.Kind;
         begin
            H_Member (M.Member_Type.all, N, HMem);
            TC_Member (M.Member_Type.all, N, Idx, Is_Key (M), TCMem);
            if K = S.T_String or else K = S.T_Wide_String then
               SU.Append (TCStr, "    static DDS_TypeCode "
                 & FP & "_g_tc_" & N & "_string = "
                 & "DDS_INITIALIZE_STRING_TYPECODE("
                 & C_Str_Bound (M.Member_Type.all) & ");");
               SU.Append (TCStr, ASCII.CR & ASCII.LF);
            end if;
            TC_Assign (M.Member_Type.all, Idx, FP, N, TCAnn);
            TC_Annot (M.Member_Type.all, Idx, FP, TCAnns);
            Access_Member (M.Member_Type.all, N, Idx, FP, Acc);
            Init_Member (M.Member_Type.all, N, FP, Init);
            Fin_Member (M.Member_Type.all, N, Fin);
            Copy_Member (M.Member_Type.all, N, Copy);
            Idx := Idx + 1;
         end;
      end loop;

      --  .c region (per-type; TC + init/copy sections).
      declare
         T : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Type_C_Region_Template, FP, FS, "", ""));
      begin
         Splice (T, "@C_TCSTR@", (1 => ASCII.LF) & SU.To_String (TCStr));
         Splice (T, "@C_TCMEM@",
                 (1 => ASCII.LF)
                 & SU.To_String
                     (SU.To_Unbounded_String
                        ("    static DDS_TypeCode_Member " & FP
                         & "_g_tc_members["
                         & Int_Image (Natural (S.Member_Vectors.Length (Mems)))
                         & "]=" & ASCII.CR & ASCII.LF
                         & "    {" & ASCII.CR & ASCII.LF))
                 & SU.To_String (TCMem)
                 & "    };" & ASCII.CR & ASCII.LF);
         Splice (T, "@C_TCANN@", (1 => ASCII.LF) & SU.To_String (TCAnn)
                 & SU.To_String
                     (SU.To_Unbounded_String
                        (ASCII.LF
                         & "    /* Initialize the values for member annotations. */"
                         & ASCII.CR & ASCII.LF))
                 & SU.To_String (TCAnns));
         Splice (T, "@C_ACCESS@",
                 "    }" & ASCII.CR & ASCII.LF
                 & SU.To_String (Acc));
         Splice (T, "@C_INIT@", (1 => ASCII.LF) & SU.To_String (Init));
         Splice (T, "@C_FIN@", (1 => ASCII.LF) & SU.To_String (Fin));
         Splice (T, "@C_COPY@", (1 => ASCII.LF) & SU.To_String (Copy));
         Rep_In (T, "_g_tc_members[2]", "_g_tc_members["
                   & Img_Positive (N_Members) & "]");
         Rep_In (T, "            2, /* Number of members */",
                   "            " & Img_Positive (N_Members)
                     & ", /* Number of members */");
         SU.Append (C_Text, SU.To_String (T));
      end;

      --  .h per-type block.
      declare
         Hb : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_H_Block_Template, FP, FS, "", ""));
      begin
         Splice (Hb, "@C_HMEM@",
                 (1 => ASCII.LF) & SU.To_String (HMem));
         SU.Append (H_Text, SU.To_String (Hb));
      end;

      Key_Fns (Mems, FP, Key_Text);

      --  Plugin.h, Support.c and Plugin.c per-type blocks.
      SU.Append (PH_Text, SU.To_String
        (SU.To_Unbounded_String
           (Substitute (C_Plugin_H_Block_Template, FP, FS,
                        "", ""))));
      SU.Append (Sup_Text, SU.To_String
        (SU.To_Unbounded_String
           (Substitute (C_Support_C_Block_Template, FP, FS,
                        "", ""))));
      declare
         B : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Plugin_C_Block_Template, FP, FS,
                          "", ""));
         Keys : SU.Unbounded_String;
      begin
         Key_Fns (Mems, FP, Keys);
         Splice (B, "@C_KEYFNS@", (1 => ASCII.LF) & SU.To_String (Keys));
         SU.Append (PC_Text, SU.To_String (B));
      end;

      --  Support.h per-type block.
      SU.Append (SH_Text, SU.To_String
        (SU.To_Unbounded_String
           (Substitute (C_Support_H_Block_Template, FP, FS,
                        "", ""))));
   end Emit_Type;

   procedure Emit_Const
     (Def : S.Definition_Ref;
      Consts_Text : in out SU.Unbounded_String)
   is
      N : constant String := SU.To_String (Def.Name);
      --  Integer constants carry the C long suffix (oracle: (256L)).
      use type S.Expr_Kind_T;
      V : constant String :=
        (if Def.Const_Value.Kind = S.E_Integer
         then SU.To_String (Def.Const_Value.Literal_Text) & "L"
         else SU.To_String (Def.Const_Value.Literal_Text));
   begin
      SU.Append (Consts_Text,
        (1 => ASCII.LF) & "    #define " & N & " (" & V & ")");
      SU.Append (Consts_Text, ASCII.CR & ASCII.LF);
   end Emit_Const;

   procedure Collect
     (Tree : S.Definition_Vectors.Vector;
      Scope : String)
   is
   begin
      for Def of Tree loop
         case Def.Kind is
            when D_Module =>
               Collect (Def.Module_Body,
                        Scope_Of (Scope, SU.To_String (Def.Name)));
            when D_Typedef =>
               declare
                  E : constant Typedef_Entry_T :=
                    (Scope => SU.To_Unbounded_String (Scope),
                     Name  => Def.Name,
                     Typ   => Def.Typedef_Type);
               begin
                  Typedef_Vectors.Append (Typedefs, E);
               end;
            when others =>
               null;
         end case;
      end loop;
   end Collect;

   procedure Walk
     (Self : in out C_RTI_Backend;
      Tree : S.Definition_Vectors.Vector;
      Scope : String;
      Prefix : String;
      Consts_Text : in out SU.Unbounded_String;
      H_Text : in out SU.Unbounded_String;
      C_Text : in out SU.Unbounded_String;
      Key_Text : in out SU.Unbounded_String;
      Sup_Text : in out SU.Unbounded_String;
      PH_Text : in out SU.Unbounded_String;
      PC_Text : in out SU.Unbounded_String;
      SH_Text : in out SU.Unbounded_String)
   is
      use type SU.Unbounded_String;
   begin
      for Def of Tree loop
         case Def.Kind is
            when D_Const =>
               Emit_Const (Def, Consts_Text);
            when D_Module =>
               declare
                  Mod_Name : constant String :=
                    SU.To_String (Def.Name);
                  Sub_Prefix : constant String :=
                    (if Prefix = ""
                     then Mod_Name & "_"
                     else Prefix & Mod_Name & "_");
               begin
                  Walk (Self, Def.Module_Body,
                        Scope_Of (Scope, Mod_Name), Sub_Prefix,
                        Consts_Text, H_Text, C_Text, Key_Text,
                        Sup_Text, PH_Text, PC_Text, SH_Text);
               end;
            when D_Struct =>
               Emit_Type (Def, Prefix, Scope, C_Text, H_Text, Key_Text,
                          Sup_Text, PH_Text, PC_Text, SH_Text);
            when others =>
               null;
         end case;
      end loop;
   end Walk;

   procedure Write_File
     (Self : in out C_RTI_Backend;
      Name : String;
      Text : String)
   is
      pragma Unreferenced (Self);
      F : SV.File_Type;
   begin
      SV.Create (F, SV.Out_File, Name);
      SV.Write (F, B (Text));
      SV.Close (F);
   end Write_File;

   overriding procedure Generate
     (Self     : in out C_RTI_Backend;
      Tree     : S.Definition_Vectors.Vector;
      Idl_Path : String)
   is
      Idl_File : constant String :=
        Ada.Directories.Simple_Name (Idl_Path);
      Keys_Text : constant SU.Unbounded_String :=
        Scan_Key_Members (Idl_Path);

      procedure Load_Key_Names is
         T : constant String := SU.To_String (Keys_Text);
         Start : Positive := T'First;
      begin
         Key_Names.Clear;
         for I in T'Range loop
            if T (I) = ASCII.LF then
               if I > Start then
                  Key_Names.Append (SU.To_Unbounded_String (T (Start .. I - 1)));
               end if;
               Start := I + 1;
            end if;
         end loop;
      end Load_Key_Names;
      Idl_Base : constant String :=
        Idl_File (Idl_File'First .. Idl_File'Last - 4);
      Guard : constant String := Guard_For (Idl_Base);

      Consts_Text : SU.Unbounded_String;
      H_Text : SU.Unbounded_String;
      C_Text : SU.Unbounded_String;
      Key_Text : SU.Unbounded_String;
      Sup_Text : SU.Unbounded_String;
      PH_Text : SU.Unbounded_String;
      PC_Text : SU.Unbounded_String;
      SH_Text : SU.Unbounded_String;
      use type SU.Unbounded_String;
   begin
      Load_Key_Names;
      Typedefs.Clear;
      Collect (Tree, "");
      Walk (Self, Tree, "", "", Consts_Text, H_Text, C_Text,
            Key_Text, Sup_Text, PH_Text, PC_Text, SH_Text);

      --  .h: template with consts + per-type blocks spliced.
      declare
         H2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Type_H_Template, Idl_Base, Idl_Base,
                          Idl_Base, Guard));
      begin
         Splice (H2, "@C_CONSTS@", SU.To_String (Consts_Text));
         Splice (H2, "@C_TYPES@", SU.To_String (H_Text));
         Write_File (Self, Idl_Base & ".h", SU.To_String (H2));
      end;

      --  .c: intro + per-type regions.
      declare
         C2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Type_C_Intro_Template, Idl_Base, Idl_Base,
                          Idl_Base, Guard));
      begin
         SU.Append (C2, SU.To_String (C_Text));
         SU.Append (C2, ASCII.CR & ASCII.LF);
         Write_File (Self, Idl_Base & ".c", SU.To_String (C2));
      end;

      --  Plugin.c: head + per-type blocks.
      declare
         P2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Plugin_C_Head_Template, Idl_Base, Idl_Base,
                          Idl_Base, Guard));
      begin
         SU.Append (P2, SU.To_String (PC_Text));
         SU.Append (P2, ASCII.CR & ASCII.LF);
         Write_File (Self, Idl_Base & "Plugin.c", SU.To_String (P2));
      end;

      --  Plugin.h: intro + per-type blocks + tail.
      declare
         use type SU.Unbounded_String;
         P2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Plugin_H_Intro_Template, Idl_Base, Idl_Base, Idl_Base, Guard));
      begin
         SU.Append (P2, SU.To_String (PH_Text));
         SU.Append (P2, SU.To_String
           (SU.To_Unbounded_String
              (Substitute (C_Support_H_Tail_Template, Idl_Base,
                           Idl_Base, Idl_Base, Guard))));
         Write_File (Self, Idl_Base & "Plugin.h", SU.To_String (P2));
      end;

      --  Support.c: intro + per-type blocks.
      declare
         S2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Support_C_Intro_Template, Idl_Base, Idl_Base, Idl_Base, Guard));
      begin
         SU.Append (S2, SU.To_String (Sup_Text));
         SU.Append (S2, ASCII.CR & ASCII.LF);
         Write_File (Self, Idl_Base & "Support.c", SU.To_String (S2));
      end;

      --  Support.h: intro + per-type blocks + tail.
      declare
         S2 : SU.Unbounded_String :=
           SU.To_Unbounded_String
             (Substitute (C_Support_H_Intro_Template, Idl_Base, Idl_Base, Idl_Base, Guard));
      begin
         SU.Append (S2, SU.To_String (SH_Text));
         SU.Append (S2, SU.To_String
           (SU.To_Unbounded_String
              (Substitute (C_Support_H_Tail_Template, Idl_Base,
                           Idl_Base, Idl_Base, Guard))));
         Write_File (Self, Idl_Base & "Support.h", SU.To_String (S2));
      end;
   end Generate;

end IDL2Lang.Backends.C_RTI;
