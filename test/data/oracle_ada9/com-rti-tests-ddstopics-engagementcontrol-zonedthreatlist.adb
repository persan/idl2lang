--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from sequences.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body com.rti.tests.DdsTopics.EngagementControl.ZonedThreatList is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out Key) is
      function Internal
        (This : not null access Key)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Key) is
      procedure Internal
        (This : access Key;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Key;
      Src : in Key) is
      function Internal
        (Dst : not null access Key;
         Src : not null access Key)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out ZonedThreatList) is
      function Internal
        (This : not null access ZonedThreatList)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out ZonedThreatList) is
      procedure Internal
        (This : access ZonedThreatList;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out ZonedThreatList;
      Src : in ZonedThreatList) is
      function Internal
        (Dst : not null access ZonedThreatList;
         Src : not null access ZonedThreatList)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end com.rti.tests.DdsTopics.EngagementControl.ZonedThreatList;

