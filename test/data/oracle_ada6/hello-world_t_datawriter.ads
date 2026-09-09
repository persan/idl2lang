--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from ArrayRanges.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (Off);

with DDS.Typed_DataWriter_Generic; pragma Elaborate (DDS.Typed_DataWriter_Generic);
with hello.World_T_TypeSupport;
package hello.World_T_DataWriter is new
  Standard.DDS.Typed_DataWriter_Generic (hello.World_T_TypeSupport.World_T_Treats);
