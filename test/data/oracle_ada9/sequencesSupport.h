
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from sequences.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef sequencesSupport_704363284_h
#define sequencesSupport_704363284_h

/* Uses */
#include "sequences.h"

#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif

#ifdef __cplusplus
extern "C" {
    #endif

    #if (defined(RTI_WIN32) || defined (RTI_WINCE) || defined(RTI_INTIME)) && defined(NDDS_USER_DLL_EXPORT)

    #endif

    /* ========================================================================= */
    /**
    Uses:     T

    Defines:  TTypeSupport, TDataWriter, TDataReader

    Organized using the well-documented "Generics Pattern" for
    implementing generics in C and C++.
    */

    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    DDS_TYPESUPPORT_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTypeSupport, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataWriter, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key);
    DDS_DATAREADER_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataReader, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif
    /* ========================================================================= */
    /**
    Uses:     T

    Defines:  TTypeSupport, TDataWriter, TDataReader

    Organized using the well-documented "Generics Pattern" for
    implementing generics in C and C++.
    */

    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    DDS_TYPESUPPORT_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTypeSupport, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataWriter, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList);
    DDS_DATAREADER_C(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataReader, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListSeq, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif  /* sequencesSupport_704363284_h */
