

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Constants.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef Constants_1942815470_h
#define Constants_1942815470_h

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

    #define PI (3.1415)
    #define PI2 (2.0*(PI))

    typedef DDS_Long MYLONG;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * MYLONG_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *MYLONG_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *MYLONG_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(MYLONGSeq, MYLONG);

    NDDSUSERDllExport
    RTIBool MYLONG_initialize(
        MYLONG* self);

    NDDSUSERDllExport
    RTIBool MYLONG_initialize_ex(
        MYLONG* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool MYLONG_initialize_w_params(
        MYLONG* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool MYLONG_finalize_w_return(
        MYLONG* self);

    NDDSUSERDllExport
    void MYLONG_finalize(
        MYLONG* self);

    NDDSUSERDllExport
    void MYLONG_finalize_ex(
        MYLONG* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void MYLONG_finalize_w_params(
        MYLONG* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void MYLONG_finalize_optional_members(
        MYLONG* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool MYLONG_copy(
        MYLONG* dst,
        const MYLONG* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif
    #define LONG_CONST_123 (100L+23L)
    #define MY_STRING (" Hello World!")
    #define LONG_LONG_CONST (2147483648LL)
    #define LONG_LONG_CONST2 (-2147483649LL)
    #define LONG_CONST (2147483647L)
    #define LONG_CONST2 (-2147483648L)

    #ifdef __cplusplus
}
#endif

#endif /* Constants */
