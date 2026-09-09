--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from base.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body vtypes_test.base is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out position_t) is
      function Internal
        (This : not null access position_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_position_t_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out position_t) is
      procedure Internal
        (This : access position_t;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "vtypes_test_base_position_t_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out position_t;
      Src : in position_t) is
      function Internal
        (Dst : not null access position_t;
         Src : not null access position_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_position_t_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out speed_t) is
      function Internal
        (This : not null access speed_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_speed_t_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out speed_t) is
      procedure Internal
        (This : access speed_t;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "vtypes_test_base_speed_t_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out speed_t;
      Src : in speed_t) is
      function Internal
        (Dst : not null access speed_t;
         Src : not null access speed_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_speed_t_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out basetrack_t) is
      function Internal
        (This : not null access basetrack_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_basetrack_t_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out basetrack_t) is
      procedure Internal
        (This : access basetrack_t;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "vtypes_test_base_basetrack_t_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out basetrack_t;
      Src : in basetrack_t) is
      function Internal
        (Dst : not null access basetrack_t;
         Src : not null access basetrack_t)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "vtypes_test_base_basetrack_t_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end vtypes_test.base;

