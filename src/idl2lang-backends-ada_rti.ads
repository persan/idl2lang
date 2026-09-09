------------------------------------------------------------------------------
--  IDL2Lang.Backends.Ada_RTI -- Ada output for RTI Connext DDS
--
--  Goal.txt requirement 5: generate the same output files with the
--  same contents as RTI's rtiddsgen ("-language Ada -create
--  typefiles").  This first increment covers the pure-Ada files of
--  `-create typefiles` for structs of primitive members:
--
--    <module>_<type>.ads        the type definition module
--    <module>_<type>.adb        Initialize/Finalize/Copy bodies
--    <module>_<type>_datareader.ads
--    <module>_<type>_datawriter.ads
--
--  (The C plugin files Hello.c/.h, HelloPlugin.c/.h, HelloSupport.c/.h
--  are separate back-end work, tracked in the README roadmap.)
--
--  Byte parity: every line below is transcribed from rtiddsgen 4.7.0
--  output (test/data/oracle_ada), including its quirks -- "package  N"
--  with two spaces, trailing spaces on member lines ("    "), the
--  " " line before the record, and "N_TypeName" with
--  To_DDS_String  ("...") double space.
--
--  rtiddsgen type-mapping used here (dds_rtiddsgen mapping, structs
--  of primitive members):
--    short                  -> Standard.DDS.Short
--    unsigned short         -> Standard.DDS.Unsigned_Short
--    long                   -> Standard.DDS.Long
--    unsigned long          -> Standard.DDS.Unsigned_Long
--    long long              -> Standard.DDS.Long_Long
--    unsigned long long     -> Standard.DDS.Unsigned_Long_Long
--    float                  -> Standard.DDS.Float
--    double                 -> Standard.DDS.Double
--    char                   -> Standard.DDS.Char
--    boolean                -> Standard.DDS.Boolean
--    octet                  -> Standard.DDS.Octet
--
--  Naming rules (observed from rtiddsgen output):
--    file names: lowercased module, "_" separators for nested scopes
--    package name: the IDL module name as written
--    C-side link names: "Module_Type_function"
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