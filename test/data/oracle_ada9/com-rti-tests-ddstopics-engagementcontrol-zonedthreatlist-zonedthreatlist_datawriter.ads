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
pragma Style_Checks (Off);

with DDS.Typed_DataWriter_Generic; pragma Elaborate (DDS.Typed_DataWriter_Generic);
with com.rti.tests.DdsTopics.EngagementControl.ZonedThreatList.ZonedThreatList_TypeSupport;
package com.rti.tests.DdsTopics.EngagementControl.ZonedThreatList.ZonedThreatList_DataWriter is new
  Standard.DDS.Typed_DataWriter_Generic (com.rti.tests.DdsTopics.EngagementControl.ZonedThreatList.ZonedThreatList_TypeSupport.ZonedThreatList_Treats);
