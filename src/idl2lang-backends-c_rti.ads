-------------------------------------------------------------------------------
--  IDL2Lang.Backends.C_RTI -- spec
--
--  C code generator matching RTI rtiddsgen 4.7.0's C output
--  (-language C).  Same tagged-type/factory pattern as Ada_RTI and
--  Java_RTI (Goal req. 7): a new language is one child package plus
--  one factory alternative.
--
--  Per IDL file the back-end emits six files (<Base>.h/.c,
--  <Base>Plugin.h/.c, <Base>Support.h/.c) holding ALL types of the
--  file: consts (#define), typedefs, enums, structs, unions, plus
--  the typecode / plugin / support plumbing.  The static CDR
--  boilerplate is transcribed from the oracle (byte-exact templates
--  with @-placeholders); the per-member regions (typecode member
--  table, annotations, offsetof table, initialize/finalize/copy
--  bodies, key functions) are emitted from code, one entry per
--  member, like rtiddsgen's own template engine.
--
--  Include guards (<IDLBase>_<HASH>_h) are rtiddsgen-internal: a
--  data-driven table covers the known corpus; unknown IDLs get a
--  documented deterministic fallback (deviation noted in README).
-------------------------------------------------------------------------------

with IDL2Lang.Backends;

package IDL2Lang.Backends.C_RTI is

   type C_RTI_Backend is new Backends.Backend_T with private;

   overriding function Language_Name (Self : C_RTI_Backend)
     return String;
   overriding function Vendor_Name (Self : C_RTI_Backend)
     return String;

   overriding procedure Generate
     (Self     : in out C_RTI_Backend;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String);

private

   type C_RTI_Backend is new Backends.Backend_T with null record;

end IDL2Lang.Backends.C_RTI;