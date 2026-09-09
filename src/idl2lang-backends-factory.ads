------------------------------------------------------------------------------
--  IDL2Lang.Backends.Factory -- the back-end factory
--
--  Goal.txt requirement 7: "The Output classes shall be accessed via a
--  factory located in the package containing the base class.  The
--  parameters to the factory shall be two strings "language" and
--  "vendor" and the concrete objects shall be returned by the
--  factory."
--
--  Adding a new vendor/language combination = adding one child package
--  that declares a new Backend_T descendant and one alternative in the
--  Lookup body; nothing else in the tree changes.
------------------------------------------------------------------------------

with IDL2Lang.Syntax;

package IDL2Lang.Backends.Factory is

   function Lookup
     (Language : String;
      Vendor   : String;
      Tree     : IDL2Lang.Syntax.Definition_Vectors.Vector;
      Idl_Path : String;
      Output_Dir : String)
     return Backend_Ref;
   --  Return a new instance of the back-end for (Language, Vendor) and
   --  run its Generate over Tree.  Output_Dir is where the back-end
   --  commits its files.  Both selector strings are compared
   --  case-insensitively (rtiddsgen accepts "-language ada" and
   --  "-language Ada").  Raises Backend_Error for an unknown
   --  combination.

end IDL2Lang.Backends.Factory;