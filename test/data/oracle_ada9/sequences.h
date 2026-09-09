

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from sequences.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef sequences_704363284_h
#define sequences_704363284_h

#ifndef NDDS_STANDALONE_TYPE
#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif
#include "cdr/cdr_typeCode.h"
#else
#include "ndds_standalone_type.h"
#endif

#ifdef __cplusplus
extern "C" {
    #endif

    extern const char *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTYPENAME;

    typedef struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key
    {

        DDS_Long numberOfThreats;

    } com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_return(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_optional_members(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_copy(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* dst,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif
    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZONED_THREAT_LIST_MAXSIZE (10L)

    extern const char *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTYPENAME;

    typedef struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList
    {

        DDS_Long numberOfThreats;
        struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq zonedThreats;

    } com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListSeq, com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_return(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_optional_members(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_copy(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* dst,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* sequences */
