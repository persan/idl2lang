--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from HelloWorld.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body testCodeGen is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out HelloWorld) is
      function Internal
        (This : not null access HelloWorld)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "testCodeGen_HelloWorld_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out HelloWorld) is
      procedure Internal
        (This : access HelloWorld;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "testCodeGen_HelloWorld_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out HelloWorld;
      Src : in HelloWorld) is
      function Internal
        (Dst : not null access HelloWorld;
         Src : not null access HelloWorld)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "testCodeGen_HelloWorld_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end testCodeGen;

