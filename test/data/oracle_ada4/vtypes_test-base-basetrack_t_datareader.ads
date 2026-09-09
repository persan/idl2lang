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
pragma Style_Checks (Off);

with DDS.Typed_DataReader_Generic; pragma Elaborate (DDS.Typed_DataReader_Generic);
with vtypes_test.base.basetrack_t_TypeSupport;
package vtypes_test.base.basetrack_t_DataReader is new
  Standard.DDS.Typed_DataReader_Generic (vtypes_test.base.basetrack_t_TypeSupport.basetrack_t_Treats);
