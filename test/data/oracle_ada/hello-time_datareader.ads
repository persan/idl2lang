--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from Hello.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (Off);

with DDS.Typed_DataReader_Generic; pragma Elaborate (DDS.Typed_DataReader_Generic);
with Hello.Time_TypeSupport;
package Hello.Time_DataReader is new
  Standard.DDS.Typed_DataReader_Generic (Hello.Time_TypeSupport.Time_Treats);
