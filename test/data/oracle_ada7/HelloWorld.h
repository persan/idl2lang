

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from HelloWorld.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef HelloWorld_1436886533_h
#define HelloWorld_1436886533_h

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

    #define HELLO_MAX_STRING_SIZE (256L)

    extern const char *testCodeGen_HelloWorldTYPENAME;

    typedef struct testCodeGen_HelloWorld
    {

        DDS_Char * message;
        DDS_Double value;

    } testCodeGen_HelloWorld ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * testCodeGen_HelloWorld_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *testCodeGen_HelloWorld_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *testCodeGen_HelloWorld_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(testCodeGen_HelloWorldSeq, testCodeGen_HelloWorld);

    NDDSUSERDllExport
    RTIBool testCodeGen_HelloWorld_initialize(
        testCodeGen_HelloWorld* self);

    NDDSUSERDllExport
    RTIBool testCodeGen_HelloWorld_initialize_ex(
        testCodeGen_HelloWorld* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool testCodeGen_HelloWorld_initialize_w_params(
        testCodeGen_HelloWorld* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool testCodeGen_HelloWorld_finalize_w_return(
        testCodeGen_HelloWorld* self);

    NDDSUSERDllExport
    void testCodeGen_HelloWorld_finalize(
        testCodeGen_HelloWorld* self);

    NDDSUSERDllExport
    void testCodeGen_HelloWorld_finalize_ex(
        testCodeGen_HelloWorld* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void testCodeGen_HelloWorld_finalize_w_params(
        testCodeGen_HelloWorld* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void testCodeGen_HelloWorld_finalize_optional_members(
        testCodeGen_HelloWorld* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool testCodeGen_HelloWorld_copy(
        testCodeGen_HelloWorld* dst,
        const testCodeGen_HelloWorld* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* HelloWorld */
