------------------------------------------------------------------------------
--  IDL2Lang.Tokens -- body
------------------------------------------------------------------------------

package body IDL2Lang.Tokens is

   --  Table 7-6: All IDL keywords (7.2.4).  Exact spelling, including
   --  the mixed-case Object, ValueBase, TRUE, and FALSE.
   type Keyword_Ref is access constant String;
   Keywords : constant array (1 .. 83) of Keyword_Ref :=
     [new String'("abstract"),       new String'("any"),
      new String'("alias"),          new String'("attribute"),
      new String'("bitfield"),       --  row 1
      new String'("bitmask"),        new String'("bitset"),
      new String'("boolean"),        new String'("case"),
      new String'("char"),           --  row 2
      new String'("component"),      new String'("connector"),
      new String'("const"),          new String'("consumes"),
      new String'("context"),        --  row 3
      new String'("custom"),         new String'("default"),
      new String'("double"),         new String'("exception"),
      new String'("emits"),          --  row 4
      new String'("enum"),           new String'("eventtype"),
      new String'("factory"),        new String'("FALSE"),
      new String'("finder"),         --  row 5
      new String'("fixed"),          new String'("float"),
      new String'("getraises"),      new String'("home"),
      new String'("import"),         --  row 6
      new String'("in"),             new String'("inout"),
      new String'("interface"),      new String'("local"),
      new String'("long"),           --  row 7
      new String'("manages"),        new String'("map"),
      new String'("mirrorport"),     new String'("module"),
      new String'("multiple"),       --  row 8
      new String'("native"),         new String'("Object"),
      new String'("octet"),          new String'("oneway"),
      new String'("out"),            --  row 9
      new String'("primarykey"),     new String'("private"),
      new String'("port"),           new String'("porttype"),
      new String'("provides"),       --  row 10
      new String'("public"),         new String'("publishes"),
      new String'("raises"),         new String'("readonly"),
      new String'("setraises"),      --  row 11
      new String'("sequence"),       new String'("short"),
      new String'("string"),         new String'("struct"),
      new String'("supports"),       --  row 12
      new String'("switch"),         new String'("TRUE"),
      new String'("truncatable"),    new String'("typedef"),
      new String'("typeid"),         --  row 13
      new String'("typename"),       new String'("typeprefix"),
      new String'("unsigned"),       new String'("union"),
      new String'("uses"),           --  row 14
      new String'("ValueBase"),      new String'("valuetype"),
      new String'("void"),           new String'("wchar"),
      new String'("wstring"),        --  row 15
      new String'("int8"),           new String'("uint8"),
      new String'("int16"),          new String'("int32"),
      new String'("int64"),          --  row 16
      new String'("uint16"),         new String'("uint32"),
      new String'("uint64")];        --  row 17

   --  Case-insensitive equality of two characters (7.2.3.1: upper- and
   --  lower-case letters are treated as the same letter).
   function Case_Equal (L, R : Character) return Boolean is
      (if L in 'A' .. 'Z'
         then Character'Val (Character'Pos (L) + 32) = R
       elsif R in 'A' .. 'Z'
         then Character'Val (Character'Pos (R) + 32) = L
       else L = R);

   function Is_Keyword (Name : String) return Boolean is
   begin
      for K of Keywords loop
         if K.all = Name then
            return True;
         end if;
      end loop;
      return False;
   end Is_Keyword;

   --  7.2.4: identifiers that collide with a keyword only in letter
   --  case ("Boolean", "BOOLEAN") are illegal.  Report the colliding
   --  keyword's spelling, or "" if Name is not such an identifier.
   function Colliding_Keyword (Name : String) return String is
   begin
      for K of Keywords loop
         if K.all'Length = Name'Length and then K.all /= Name then
            declare
               Case_Only : Boolean := True;
            begin
               for I in K.all'Range loop
                  if K.all (I) /= Name (Name'First + (I - K.all'First))
                    and then not Case_Equal
                                  (K.all (I),
                                   Name (Name'First + (I - K.all'First)))
                  then
                     Case_Only := False;
                     exit;
                  end if;
               end loop;
               if Case_Only then
                  return K.all;
               end if;
            end;
         end if;
      end loop;
      return "";
   end Colliding_Keyword;

   function Image (Kind : Token_Kind_T) return String is
   begin
      case Kind is
         when K_Identifier            => return "identifier";
         when K_Keyword               => return "keyword";
         when K_Integer_Literal       => return "integer-literal";
         when K_Floating_Point_Literal => return "floating-point-literal";
         when K_Fixed_Point_Literal   => return "fixed-point-literal";
         when K_Character_Literal     => return "character-literal";
         when K_String_Literal        => return "string-literal";
         when K_Directive             => return "directive";
         when K_Semicolon             => return ";";
         when K_Left_Brace            => return "{";
         when K_Right_Brace           => return "}";
         when K_Colon                 => return ":";
         when K_Scope                 => return "::";
         when K_Comma                 => return ",";
         when K_Equal                 => return "=";
         when K_Plus                  => return "+";
         when K_Minus                 => return "-";
         when K_Left_Paren            => return "(";
         when K_Right_Paren           => return ")";
         when K_Less                  => return "<";
         when K_Greater               => return ">";
         when K_Shift_Left            => return "<<";
         when K_Shift_Right           => return ">>";
         when K_Left_Bracket          => return "[";
         when K_Right_Bracket         => return "]";
         when K_Bar                   => return "|";
         when K_Caret                 => return "^";
         when K_Ampersand             => return "&";
         when K_Asterisk              => return "*";
         when K_Solidus               => return "/";
         when K_Percent               => return "%";
         when K_Tilde                 => return "~";
         when K_At                    => return "@";
         when K_Bang                  => return "!";
         when K_And_And               => return "&&";
         when K_Or_Or                 => return "||";
         when K_Double_Hash           => return "##";
         when K_Backslash             => return "\";
         when K_Eof                   => return "end-of-file";
      end case;
   end Image;

end IDL2Lang.Tokens;