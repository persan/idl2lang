--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from Constants.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body Constants_IDL_File is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out MYLONG) is
      function Internal
        (This : not null access MYLONG)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "MYLONG_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out MYLONG) is
      procedure Internal
        (This : access MYLONG;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "MYLONG_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out MYLONG;
      Src : in MYLONG) is
      function Internal
        (Dst : not null access MYLONG;
         Src : not null access MYLONG)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "MYLONG_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end Constants_IDL_File;

