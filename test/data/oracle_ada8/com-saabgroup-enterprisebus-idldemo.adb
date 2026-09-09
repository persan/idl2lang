--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from Demo.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body com.saabgroup.enterprisebus.idldemo is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out MyStruct) is
      function Internal
        (This : not null access MyStruct)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_MyStruct_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out MyStruct) is
      procedure Internal
        (This : access MyStruct;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out MyStruct;
      Src : in MyStruct) is
      function Internal
        (Dst : not null access MyStruct;
         Src : not null access MyStruct)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_MyStruct_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out Variants) is
      function Internal
        (This : not null access Variants)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Variants_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Variants) is
      procedure Internal
        (This : access Variants;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Variants_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Variants;
      Src : in Variants) is
      function Internal
        (Dst : not null access Variants;
         Src : not null access Variants)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Variants_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out Demo) is
      function Internal
        (This : not null access Demo)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Demo_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Demo) is
      procedure Internal
        (This : access Demo;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Demo;
      Src : in Demo) is
      function Internal
        (Dst : not null access Demo;
         Src : not null access Demo)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_saabgroup_enterprisebus_idldemo_Demo_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end com.saabgroup.enterprisebus.idldemo;

