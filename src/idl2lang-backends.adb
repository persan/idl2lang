------------------------------------------------------------------------------
--  IDL2Lang.Backends -- body: output-buffer plumbing
--
--  Select_Output_File flushes the previous in-memory file into the
--  Emitted list; File_* accessors read that list; Write_All commits
--  every file to disk byte-exactly (LF line endings as buffered).
------------------------------------------------------------------------------

with Ada.Directories;
with Ada.Streams;
with Ada.Streams.Stream_IO;


package body IDL2Lang.Backends is

   procedure Flush_Current (Self : in out Backend_T);
   --  Append the current Out_* triple to Emitted (if a file is open
   --  and non-empty).

   procedure Flush_Current (Self : in out Backend_T) is
      use Ada.Strings.Unbounded;
      Entry_Rec : File_Entry_T;
   begin
      if Length (Self.Out_Name) > 0 then
         Entry_Rec :=
           (Name => Self.Out_Name,
            Kind => Self.Out_Kind,
            Text => Self.Out_Text);
         Self.Emitted.Append (Entry_Rec);
         Self.Out_Name := Null_Unbounded_String;
         Self.Out_Kind := F_Unknown;
         Self.Out_Text := Null_Unbounded_String;
      end if;
   end Flush_Current;

   procedure Select_Output_File
     (Self : in out Backend_T; Name : String; Kind : File_Kind_T)
   is
   begin
      Flush_Current (Self);
      Self.Out_Name := Ada.Strings.Unbounded.To_Unbounded_String (Name);
      Self.Out_Kind := Kind;
      Self.Out_Text := Ada.Strings.Unbounded.Null_Unbounded_String;
   end Select_Output_File;

   procedure Put (Self : in out Backend_T; S : String) is
   begin
      Ada.Strings.Unbounded.Append (Self.Out_Text, S);
   end Put;

   procedure Put_Line (Self : in out Backend_T; S : String) is
   begin
      Ada.Strings.Unbounded.Append (Self.Out_Text, S & ASCII.LF);
   end Put_Line;

   procedure New_Line (Self : in out Backend_T) is
   begin
      Ada.Strings.Unbounded.Append (Self.Out_Text, ASCII.LF);
   end New_Line;

   function File_Count (Self : Backend_T) return Natural is
      Pending : constant Boolean :=
        Ada.Strings.Unbounded.Length (Self.Out_Name) > 0;
      --  A file still open at query time counts too (tests may query
      --  right after Generate, whose last Select was not flushed).
      Count : constant Natural := Natural (Self.Emitted.Length);
   begin
      return (if Pending then Count + 1 else Count);
   end File_Count;

   procedure Check_Index
     (Self : Backend_T; Index : Positive; Count : Natural)
   is
      pragma Unreferenced (Self);
   begin
      if Index > Count then
         raise Backend_Error
           with "file index" & Positive'Image (Index)
             & " out of range (" & Natural'Image (Count) & " files)";
      end if;
   end Check_Index;

   function File_Name (Self : Backend_T; Index : Positive) return String is
      Count : constant Natural := File_Count (Self);
      Pending : constant Boolean := Count > Natural (Self.Emitted.Length);
   begin
      Check_Index (Self, Index, Count);
      if Pending and then Index = Count then
         return Ada.Strings.Unbounded.To_String (Self.Out_Name);
      end if;
      return Ada.Strings.Unbounded.To_String (Self.Emitted (Index).Name);
   end File_Name;

   function File_Kind (Self : Backend_T; Index : Positive)
     return File_Kind_T
   is
      Count : constant Natural := File_Count (Self);
      Pending : constant Boolean := Count > Natural (Self.Emitted.Length);
   begin
      Check_Index (Self, Index, Count);
      if Pending and then Index = Count then
         return Self.Out_Kind;
      end if;
      return Self.Emitted (Index).Kind;
   end File_Kind;

   function File_Contents (Self : Backend_T; Index : Positive)
     return String
   is
      Count : constant Natural := File_Count (Self);
      Pending : constant Boolean := Count > Natural (Self.Emitted.Length);
   begin
      Check_Index (Self, Index, Count);
      if Pending and then Index = Count then
         return Ada.Strings.Unbounded.To_String (Self.Out_Text);
      end if;
      return Ada.Strings.Unbounded.To_String (Self.Emitted (Index).Text);
   end File_Contents;

   procedure Write_All (Self : in out Backend_T; Output_Dir : String) is
      F : Ada.Streams.Stream_IO.File_Type;
   begin
      --  Flush whatever is still open, then write everything.
      --  Stream_IO, not Text_IO: Text_IO would translate LF to CRLF
      --  on Windows, breaking byte parity.
      Flush_Current (Self);
      if not Ada.Directories.Exists (Output_Dir) then
         Ada.Directories.Create_Directory (Output_Dir);
      end if;
      for I in Self.Emitted.First_Index .. Self.Emitted.Last_Index loop
         declare
            Text : constant String :=
              Ada.Strings.Unbounded.To_String (Self.Emitted (I).Text);
            Bytes : Ada.Streams.Stream_Element_Array
              (1 .. Ada.Streams.Stream_Element_Offset (Text'Length));
            J : Ada.Streams.Stream_Element_Offset := 1;
         begin
            for K in Text'Range loop
               Bytes (J) := Ada.Streams.Stream_Element
                 (Character'Pos (Text (K)));
               J := Ada.Streams.Stream_Element_Offset'Succ (J);
            end loop;
            Ada.Streams.Stream_IO.Create
              (F, Ada.Streams.Stream_IO.Out_File,
               Output_Dir & '/'
                 & Ada.Strings.Unbounded.To_String
                     (Self.Emitted (I).Name));
            Ada.Streams.Stream_IO.Write (F, Bytes);
            Ada.Streams.Stream_IO.Close (F);
         end;
      end loop;
   end Write_All;

end IDL2Lang.Backends;