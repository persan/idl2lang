------------------------------------------------------------------------------
--  IDL2Lang.Syntax -- body: Image functions and scoped-name splitting
------------------------------------------------------------------------------

package body IDL2Lang.Syntax is


   ---------------------------------------------------------------------------
   --  Scoped names
   ---------------------------------------------------------------------------

   function To_Scoped_Name (Text : String) return Scoped_Name_T is
      Result : Scoped_Name_T;
      Start : Positive := Text'First;
   begin
      if Text'Length >= 2
        and then Text (Text'First) = ':'
        and then Text (Text'First + 1) = ':'
      then
         Result.Absolute := True;
         Start := Text'First + 2;
      end if;

      loop
         declare
            Sep : Natural := 0;
         begin
            for I in Start .. Text'Last - 1 loop
               if Text (I) = ':' and then Text (I + 1) = ':' then
                  Sep := I;
                  exit;
               end if;
            end loop;
            if Sep = 0 then
               Result.Parts.Append
                 (To_Unbounded_String (Text (Start .. Text'Last)));
               exit;
            else
               Result.Parts.Append
                 (To_Unbounded_String (Text (Start .. Sep - 1)));
               Start := Sep + 2;
            end if;
         end;
      end loop;
      return Result;
   end To_Scoped_Name;

   function Image (Name : Scoped_Name_T) return String is
      Result : Unbounded_String;
   begin
      if Name.Absolute then
         Result := To_Unbounded_String ("::");
      end if;
      for I in Name.Parts.First_Index .. Name.Parts.Last_Index loop
         if I > Name.Parts.First_Index then
            Result := Result & "::";
         end if;
         Result := Result & Name.Parts (I);
      end loop;
      return To_String (Result);
   end Image;

   ---------------------------------------------------------------------------
   --  Expressions
   ---------------------------------------------------------------------------

   function Image (Expr : Expression_T) return String is

      function Op_Spelling (Kind : Expr_Kind_T) return String is
        (case Kind is
            when E_Or          => "|",
            when E_Xor         => "^",
            when E_And         => "&",
            when E_Shift_Left  => "<<",
            when E_Shift_Right => ">>",
            when E_Add         => "+",
            when E_Subtract    => "-",
            when E_Multiply    => "*",
            when E_Divide      => "/",
            when E_Remainder   => "%",
            when others        => "?");

      function To_String_Body (E : Expression_T) return String is
      begin
         case E.Kind is
            when E_Scoped_Name =>
               return Image (E.Name);
            when E_Integer | E_Floating_Point | E_Fixed_Point | E_Character
               | E_Wide_Character | E_String | E_Wide_String | E_Boolean =>
               return To_String (E.Literal_Text);
            when E_Unary_Plus =>
               return "(+" & To_String_Body (E.Left.all) & ")";
            when E_Unary_Minus =>
               return "(-" & To_String_Body (E.Left.all) & ")";
            when E_Complement =>
               return "(~" & To_String_Body (E.Left.all) & ")";
            when others =>
               return "(" & To_String_Body (E.Left.all) & " "
                 & Op_Spelling (E.Kind) & " "
                 & To_String_Body (E.Right.all) & ")";
         end case;
      end To_String_Body;

   begin
      return To_String_Body (Expr);
   end Image;

   ---------------------------------------------------------------------------
   --  Types
   ---------------------------------------------------------------------------

   function Image (Typ : Type_Spec_T) return String is
   begin
      case Typ.Kind is
         when T_Short             => return "short";
         when T_Unsigned_Short    => return "unsigned short";
         when T_Long              => return "long";
         when T_Unsigned_Long     => return "unsigned long";
         when T_Long_Long         => return "long long";
         when T_Unsigned_Long_Long => return "unsigned long long";
         when T_Float             => return "float";
         when T_Double            => return "double";
         when T_Long_Double       => return "long double";
         when T_Char              => return "char";
         when T_Wide_Char         => return "wchar";
         when T_Boolean           => return "boolean";
         when T_Octet             => return "octet";
         when T_Any               => return "any";
         when T_Scoped_Name       => return Image (Typ.Type_Name);
         when T_Sequence =>
            if Typ.Bound = null then
               return "sequence<" & Image (Typ.Element_Type.all) & ">";
            else
               return "sequence<" & Image (Typ.Element_Type.all) & ", "
                 & Image (Typ.Bound.all) & ">";
            end if;
         when T_String =>
            if Typ.String_Bound = null then
               return "string";
            else
               return "string<" & Image (Typ.String_Bound.all) & ">";
            end if;
         when T_Wide_String =>
            if Typ.String_Bound = null then
               return "wstring";
            else
               return "wstring<" & Image (Typ.String_Bound.all) & ">";
            end if;
         when T_Fixed =>
            return "fixed<" & Image (Typ.Fixed_Digits.all) & ", "
              & Image (Typ.Fixed_Scale.all) & ">";
      end case;
   end Image;

   ---------------------------------------------------------------------------
   --  Definitions
   ---------------------------------------------------------------------------

   function Image (D : Definition_T; Indent : Natural := 0) return String is
      Pad : constant String (1 .. Indent * 2) := (others => ' ');
      Result : Unbounded_String;

      procedure Add (S : String) is
      begin
         Result := Result & Pad & S & ASCII.LF;
      end Add;

      procedure Add_Declarators
        (Decls : Declarator_Vectors.Vector)
      is
      begin
         for I in Decls.First_Index .. Decls.Last_Index loop
            Add ("    (" & To_String (Decls (I).Name)
                   & (if Decls (I).Array_Dims.Is_Empty then ""
                      else " [dim]") & ")");
         end loop;
      end Add_Declarators;

   begin
      case D.Kind is
         when D_Module =>
            Add ("(module " & To_String (D.Name));
            for I in D.Module_Body.First_Index .. D.Module_Body.Last_Index
            loop
               Result := Result
                 & Image (D.Module_Body (I).all, Indent + 1);
            end loop;
            Add (")");
         when D_Const =>
            Add ("(const " & Image (D.Const_Type.all) & " "
                   & To_String (D.Name));
            Add ("  (value " & Image (D.Const_Value.all) & ")");
            Add (")");
         when D_Typedef =>
            Add ("(typedef " & Image (D.Typedef_Type.all));
            Add_Declarators (D.Typedef_Declarators);
            Add (")");
         when D_Struct =>
            Add ("(struct " & To_String (D.Name));
            for I in D.Members.First_Index .. D.Members.Last_Index loop
               declare
                  M : constant Member_T := D.Members (I);
               begin
                  Add ("  (member " & Image (M.Member_Type.all));
                  for J in M.Declarators.First_Index
                             .. M.Declarators.Last_Index
                  loop
                     declare
                        Dims : constant Natural :=
                          M.Declarators (J).Array_Dims.Last_Index;
                     begin
                        Add ("    " & To_String (M.Declarators (J).Name)
                               & (if Dims = 0
                                    then ""
                                  else " [dim]"
                                    & (if Dims >= 2 then " [dim]" else "")
                                    & (if Dims >= 3 then " [dim]" else "")));
                     end;
                  end loop;
                  Add ("  )");
               end;
            end loop;
            Add (")");
         when D_Struct_Forward =>
            Add ("(struct-forward " & To_String (D.Name) & ")");
         when D_Union =>
            Add ("(union " & To_String (D.Name) & " (switch "
                   & Image (D.Switch_Type.all) & ")");
            for I in D.Cases.First_Index .. D.Cases.Last_Index loop
               Add ("  (case");
               for J in D.Cases (I).Labels.First_Index
                         .. D.Cases (I).Labels.Last_Index
               loop
                  if D.Cases (I).Labels (J).Kind = L_Default then
                     Add ("    default");
                  else
                     Add ("    (label "
                            & Image (D.Cases (I).Labels (J).Value.all)
                            & ")");
                  end if;
               end loop;
               Add ("    " & Image (D.Cases (I).Element_Type.all) & " "
                      & To_String (D.Cases (I).Element_Name.Name));
               Add ("  )");
            end loop;
            Add (")");
         when D_Union_Forward =>
            Add ("(union-forward " & To_String (D.Name) & ")");
         when D_Enum =>
            Add ("(enum " & To_String (D.Name));
            for I in D.Enumerators.First_Index .. D.Enumerators.Last_Index
            loop
               Add ("  " & To_String (D.Enumerators (I).Name));
            end loop;
            Add (")");
         when D_Native =>
            Add ("(native " & To_String (D.Name) & ")");
         when D_Annotation =>
            Add ("(annotation " & To_String (D.Name) & ")");
         when D_Value_Type =>
            Add ("(valuetype " & To_String (D.Name));
            for I in D.Value_Members.First_Index
                     .. D.Value_Members.Last_Index
            loop
               Add ("  (member " & Image (D.Value_Members (I).Member_Type.all));
               for J in D.Value_Members (I).Declarators.First_Index
                         .. D.Value_Members (I).Declarators.Last_Index
               loop
                  Add ("    "
                         & To_String (D.Value_Members (I).Declarators (J).Name));
               end loop;
               Add ("  )");
            end loop;
            Add (")");
         when D_Interface =>
            Add ("(interface " & To_String (D.Name) & ")");
      end case;
      return To_String (Result);
   end Image;

end IDL2Lang.Syntax;