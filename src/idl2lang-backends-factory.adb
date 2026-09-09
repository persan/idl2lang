------------------------------------------------------------------------------
--  IDL2Lang.Backends.Factory -- body
--
--  One alternative per registered back-end.  This is the single point
--  of extension for new vendor/language combinations (Goal req. 4/7).
------------------------------------------------------------------------------

with Ada.Characters.Handling;
with IDL2Lang.Backends.Ada_RTI;

package body IDL2Lang.Backends.Factory is

   function Lookup
     (Language : String;
      Vendor   : String;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String;
      Output_Dir : String)
     return Backend_Ref
   is
      pragma Unreferenced (Output_Dir);
      --  Commit targets are chosen by the caller after Generate fills
      --  the back-end's buffers; the parameter stays in the contract
      --  for the byte-parity harness.
      Lang_Upper : constant String :=
        (if Language'Length <= 64
           then Ada.Characters.Handling.To_Upper (Language)
           else Language);
      --  Vendor participates in the selection once more back-ends
      --  exist (e.g. Ada+RTI vs Ada+SomeOther); today Ada+RTI is the
      --  only registered combination, so the string is accepted as-is.
   begin
      --  Registered back-ends (Goal req. 4: growable):
      if Lang_Upper = "ADA" then
         declare
            Backend : constant Backend_Ref :=
              new IDL2Lang.Backends.Ada_RTI.Ada_RTI_Backend;
         begin
            Backend.Generate (Tree, Idl_Path);
            return Backend;
         end;
      end if;
      raise Backend_Error
        with "no back-end for language """ & Language & """, vendor """
          & Vendor & """";
   end Lookup;

end IDL2Lang.Backends.Factory;