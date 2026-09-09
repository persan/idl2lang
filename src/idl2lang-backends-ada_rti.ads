------------------------------------------------------------------------------
--  IDL2Lang.Backends.Ada_RTI -- Ada output for RTI Connext DDS
--
--  Goal.txt requirement 5: generate the same output files with the
--  same contents as RTI's rtiddsgen ("-language Ada -create
--  typefiles").  This increment covers, for one module:
--
--    <module>.ads / .adb           all types in source order
--    <module>-<type>_typesupport.ads/.adb   per struct (not enum)
--    <module>-<type>_datareader.ads         per struct
--    <module>-<type>_datawriter.ads         per struct
--
--  supported member kinds: primitives (7.4.1 Table 7-13 etc.),
--  bounded/unbounded strings, scoped-name members (enums and structs
--  of the same module), fixed-size arrays of primitive/scoped types,
--  and sequences (mapped to the pre-instantiated Standard.DDS.*_Seq
--  for primitives, per the oracle).
--
--  Byte parity: every line is transcribed from rtiddsgen 4.7.0 output
--  (test/data/oracle_ada and oracle_ada2), including its quirks --
--  "package  N" with two spaces, the " " and "  " blank lines,
--  trailing-space member lines, enum spacing ("red, " / "blue   );"),
--  "aliased  " double space for array/sequence members, the
--  "maximum length = (N)" comments, and the token-template
--  typesupport bodies (whole-word type-name substitution over the
--  Point oracle).
--
--  Naming: file names lowercase the module ("Shapes" -> "shapes");
--  typesupport/datareader/datawriter files separate module and type
--  with "-" but keep "_" before the suffix; C-side link names are
--  "Module_Type_function"; "Shapes_Color_get_typecode".
------------------------------------------------------------------------------

with IDL2Lang.Syntax;

package IDL2Lang.Backends.Ada_RTI is

   type Ada_RTI_Backend is new Backend_T with null record;

   overriding function Language_Name (Self : Ada_RTI_Backend) return String;
   overriding function Vendor_Name (Self : Ada_RTI_Backend) return String;

   overriding procedure Generate
     (Self     : in out Ada_RTI_Backend;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String);

end IDL2Lang.Backends.Ada_RTI;