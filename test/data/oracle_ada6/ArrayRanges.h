

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from ArrayRanges.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef ArrayRanges_237584959_h
#define ArrayRanges_237584959_h

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

    #define hello_SIZE (10L)

    extern const char *hello_World_TTYPENAME;

    typedef struct hello_World_T
    {

        DDS_Long data;

    } hello_World_T ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * hello_World_T_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *hello_World_T_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *hello_World_T_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(hello_World_TSeq, hello_World_T);

    NDDSUSERDllExport
    RTIBool hello_World_T_initialize(
        hello_World_T* self);

    NDDSUSERDllExport
    RTIBool hello_World_T_initialize_ex(
        hello_World_T* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool hello_World_T_initialize_w_params(
        hello_World_T* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool hello_World_T_finalize_w_return(
        hello_World_T* self);

    NDDSUSERDllExport
    void hello_World_T_finalize(
        hello_World_T* self);

    NDDSUSERDllExport
    void hello_World_T_finalize_ex(
        hello_World_T* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void hello_World_T_finalize_w_params(
        hello_World_T* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void hello_World_T_finalize_optional_members(
        hello_World_T* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool hello_World_T_copy(
        hello_World_T* dst,
        const hello_World_T* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    extern const char *hello_HelloWorldTYPENAME;

    typedef struct hello_HelloWorld
    {

        DDS_Char * msg;
        hello_World_T worlds_1[(hello_SIZE)];
        hello_World_T worlds_2[24L];
        DDS_Boolean profile_1[24L];
        DDS_Boolean profile_2[(hello_SIZE)];

    } hello_HelloWorld ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * hello_HelloWorld_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *hello_HelloWorld_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *hello_HelloWorld_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(hello_HelloWorldSeq, hello_HelloWorld);

    NDDSUSERDllExport
    RTIBool hello_HelloWorld_initialize(
        hello_HelloWorld* self);

    NDDSUSERDllExport
    RTIBool hello_HelloWorld_initialize_ex(
        hello_HelloWorld* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool hello_HelloWorld_initialize_w_params(
        hello_HelloWorld* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool hello_HelloWorld_finalize_w_return(
        hello_HelloWorld* self);

    NDDSUSERDllExport
    void hello_HelloWorld_finalize(
        hello_HelloWorld* self);

    NDDSUSERDllExport
    void hello_HelloWorld_finalize_ex(
        hello_HelloWorld* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void hello_HelloWorld_finalize_w_params(
        hello_HelloWorld* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void hello_HelloWorld_finalize_optional_members(
        hello_HelloWorld* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool hello_HelloWorld_copy(
        hello_HelloWorld* dst,
        const hello_HelloWorld* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* ArrayRanges */
