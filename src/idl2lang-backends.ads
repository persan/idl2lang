with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with IDL2Lang.Syntax;

package IDL2Lang.Backends is

   Backend_Error : exception;
   --  Raised on unknown language/vendor requests or misuse.

   type File_Kind_T is
     (F_Unknown,
      F_Ada_Spec,                  --  .ads
      F_Ada_Body,                  --  .adb
      F_C_Source,                  --  .c
      F_C_Header,                  --  .h
      F_Java_Source);              --  .java
   --  Classification of the files a back-end emits; used by the
   --  byte-parity harness to pick the reference files.

   type Backend_T is abstract tagged private;

   type Backend_Ref is access all Backend_T'Class;

   function Language_Name (Self : Backend_T) return String is abstract;
   --  The "language" string understood by the factory (e.g. "Ada").

   function Vendor_Name (Self : Backend_T) return String is abstract;
   --  The "vendor" string understood by the factory (e.g. "RTI").
   --  The pair (Language_Name, Vendor_Name) selects one concrete
   --  back-end class (Goal req. 7: vendor/language combinations).

   procedure Generate
     (Self     : in out Backend_T;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String)
   is abstract;
   --  Generate every output file for one IDL translation unit.  Idl_Path
   --  is the source file name as passed by the user (rtiddsgen embeds
   --  it in the generated header comment).

   --  Output plumbing during Generate (concrete, shared).

   procedure Select_Output_File
     (Self : in out Backend_T; Name : String; Kind : File_Kind_T);
   --  Close the current in-memory file (if any) and start a new one.

   procedure Put (Self : in out Backend_T; S : String);
   --  Append S verbatim to the current in-memory file.

   procedure Put_Line (Self : in out Backend_T; S : String);
   --  Append S followed by a single LF (rtiddsgen's Ada files use LF).

   procedure New_Line (Self : in out Backend_T);
   --  Append a single LF.

   --  Post-Generate access to the emitted files.

   function File_Count (Self : Backend_T) return Natural;

   function File_Name (Self : Backend_T; Index : Positive) return String;

   function File_Kind (Self : Backend_T; Index : Positive)
     return File_Kind_T;

   function File_Contents (Self : Backend_T; Index : Positive)
     return String;

   procedure Write_All (Self : in out Backend_T; Output_Dir : String);
   --  Write every emitted file to Output_Dir (created if needed),
   --  byte-exact as buffered (LF line endings preserved).

private

   type File_Entry_T is record
      Name : Ada.Strings.Unbounded.Unbounded_String;
      Kind : File_Kind_T := F_Unknown;
      Text : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   package File_Entry_Vectors is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => File_Entry_T);

   type Backend_T is abstract tagged record
      Out_Name : Ada.Strings.Unbounded.Unbounded_String;
      Out_Kind : File_Kind_T := F_Unknown;
      Out_Text : Ada.Strings.Unbounded.Unbounded_String;
      Emitted : File_Entry_Vectors.Vector;
   end record;

end IDL2Lang.Backends;