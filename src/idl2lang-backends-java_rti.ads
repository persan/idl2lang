-------------------------------------------------------------------------------
--  IDL2Lang.Backends.Java_RTI -- spec
--
--  Java code generator matching RTI rtiddsgen 4.7.0's Java output
--  (-language Java -create typefiles).  Same tagged-type/factory
--  pattern as Ada_RTI (Goal req. 7): a new language is one child
--  package plus one factory alternative.
--
--  Per declared struct the back-end emits six files into a package
--  directory (<mod-dir>/<Type>.java, <Type>Seq.java, <Type>TypeCode.
--  java, <Type>TypeSupport.java, <Type>DataReader.java, <Type>
--  DataWriter.java) plus one class file per constant.  The CDR
--  boilerplate is transcribed from the oracle (byte-parity templates
--  with @-placeholders); the per-member blocks (serialize/deserialize/
--  skip/size/hashcode/equals/copy/toString/typecode) are emitted from
--  code, one entry per member, like rtiddsgen's own template engine.
--
--  serialVersionUID is rtiddsgen-internal; the back-end carries a
--  data-driven table for known oracles and falls back to a documented
--  deterministic hash for unknown types.
-------------------------------------------------------------------------------

with IDL2Lang.Backends;

package IDL2Lang.Backends.Java_RTI is

   type Java_RTI_Backend is new Backends.Backend_T with private;

   overriding function Language_Name (Self : Java_RTI_Backend)
     return String;
   overriding function Vendor_Name (Self : Java_RTI_Backend)
     return String;

   overriding procedure Generate
     (Self     : in out Java_RTI_Backend;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String);

private

   type Java_RTI_Backend is new Backends.Backend_T with null record;

end IDL2Lang.Backends.Java_RTI;