

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from module.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef module_871297053_h
#define module_871297053_h

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

    extern const char *a_b_c_fooTYPENAME;

    typedef struct a_b_c_foo
    {

        DDS_Long data;

    } a_b_c_foo ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * a_b_c_foo_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *a_b_c_foo_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *a_b_c_foo_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(a_b_c_fooSeq, a_b_c_foo);

    NDDSUSERDllExport
    RTIBool a_b_c_foo_initialize(
        a_b_c_foo* self);

    NDDSUSERDllExport
    RTIBool a_b_c_foo_initialize_ex(
        a_b_c_foo* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool a_b_c_foo_initialize_w_params(
        a_b_c_foo* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool a_b_c_foo_finalize_w_return(
        a_b_c_foo* self);

    NDDSUSERDllExport
    void a_b_c_foo_finalize(
        a_b_c_foo* self);

    NDDSUSERDllExport
    void a_b_c_foo_finalize_ex(
        a_b_c_foo* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void a_b_c_foo_finalize_w_params(
        a_b_c_foo* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void a_b_c_foo_finalize_optional_members(
        a_b_c_foo* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool a_b_c_foo_copy(
        a_b_c_foo* dst,
        const a_b_c_foo* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* module */
