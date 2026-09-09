

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from base.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef base_1722633201_h
#define base_1722633201_h

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

    extern const char *vtypes_test_base_position_tTYPENAME;

    typedef struct vtypes_test_base_position_t
    {

        DDS_Double latitude;
        DDS_Double longitude;
        DDS_Double altitude;

    } vtypes_test_base_position_t ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * vtypes_test_base_position_t_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *vtypes_test_base_position_t_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *vtypes_test_base_position_t_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(vtypes_test_base_position_tSeq, vtypes_test_base_position_t);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_position_t_initialize(
        vtypes_test_base_position_t* self);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_position_t_initialize_ex(
        vtypes_test_base_position_t* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_position_t_initialize_w_params(
        vtypes_test_base_position_t* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_position_t_finalize_w_return(
        vtypes_test_base_position_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_position_t_finalize(
        vtypes_test_base_position_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_position_t_finalize_ex(
        vtypes_test_base_position_t* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void vtypes_test_base_position_t_finalize_w_params(
        vtypes_test_base_position_t* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void vtypes_test_base_position_t_finalize_optional_members(
        vtypes_test_base_position_t* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_position_t_copy(
        vtypes_test_base_position_t* dst,
        const vtypes_test_base_position_t* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    extern const char *vtypes_test_base_speed_tTYPENAME;

    typedef struct vtypes_test_base_speed_t
    {

        DDS_Double x;
        DDS_Double y;
        DDS_Double z;

    } vtypes_test_base_speed_t ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * vtypes_test_base_speed_t_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *vtypes_test_base_speed_t_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *vtypes_test_base_speed_t_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(vtypes_test_base_speed_tSeq, vtypes_test_base_speed_t);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_speed_t_initialize(
        vtypes_test_base_speed_t* self);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_speed_t_initialize_ex(
        vtypes_test_base_speed_t* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_speed_t_initialize_w_params(
        vtypes_test_base_speed_t* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_speed_t_finalize_w_return(
        vtypes_test_base_speed_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_speed_t_finalize(
        vtypes_test_base_speed_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_speed_t_finalize_ex(
        vtypes_test_base_speed_t* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void vtypes_test_base_speed_t_finalize_w_params(
        vtypes_test_base_speed_t* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void vtypes_test_base_speed_t_finalize_optional_members(
        vtypes_test_base_speed_t* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_speed_t_copy(
        vtypes_test_base_speed_t* dst,
        const vtypes_test_base_speed_t* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    extern const char *vtypes_test_base_basetrack_tTYPENAME;

    typedef struct vtypes_test_base_basetrack_t
    {

        DDS_Char * trackno;
        vtypes_test_base_position_t position;
        vtypes_test_base_speed_t speed;
        DDS_Char * callsign;

    } vtypes_test_base_basetrack_t ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * vtypes_test_base_basetrack_t_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *vtypes_test_base_basetrack_t_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *vtypes_test_base_basetrack_t_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(vtypes_test_base_basetrack_tSeq, vtypes_test_base_basetrack_t);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_basetrack_t_initialize(
        vtypes_test_base_basetrack_t* self);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_basetrack_t_initialize_ex(
        vtypes_test_base_basetrack_t* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool vtypes_test_base_basetrack_t_initialize_w_params(
        vtypes_test_base_basetrack_t* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_basetrack_t_finalize_w_return(
        vtypes_test_base_basetrack_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_basetrack_t_finalize(
        vtypes_test_base_basetrack_t* self);

    NDDSUSERDllExport
    void vtypes_test_base_basetrack_t_finalize_ex(
        vtypes_test_base_basetrack_t* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void vtypes_test_base_basetrack_t_finalize_w_params(
        vtypes_test_base_basetrack_t* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void vtypes_test_base_basetrack_t_finalize_optional_members(
        vtypes_test_base_basetrack_t* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool vtypes_test_base_basetrack_t_copy(
        vtypes_test_base_basetrack_t* dst,
        const vtypes_test_base_basetrack_t* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* base */
