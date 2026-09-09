

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef Demo_920141085_h
#define Demo_920141085_h

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

    extern const char *com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME;

    typedef struct com_saabgroup_enterprisebus_idldemo_MyStruct
    {

        DDS_Long X;
        DDS_Long Y;
        DDS_Long Z;

    } com_saabgroup_enterprisebus_idldemo_MyStruct ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_MyStruct_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_MyStruct_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(com_saabgroup_enterprisebus_idldemo_MyStructSeq, com_saabgroup_enterprisebus_idldemo_MyStruct);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_ex(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_return(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_optional_members(
        com_saabgroup_enterprisebus_idldemo_MyStruct* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_copy(
        com_saabgroup_enterprisebus_idldemo_MyStruct* dst,
        const com_saabgroup_enterprisebus_idldemo_MyStruct* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    typedef enum com_saabgroup_enterprisebus_idldemo_Variants
    {
        Var1 , 
        Var2 , 
        Var3 
    } com_saabgroup_enterprisebus_idldemo_Variants;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_Variants_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_Variants_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_Variants_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(com_saabgroup_enterprisebus_idldemo_VariantsSeq, com_saabgroup_enterprisebus_idldemo_Variants);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize(
        com_saabgroup_enterprisebus_idldemo_Variants* self);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize_ex(
        com_saabgroup_enterprisebus_idldemo_Variants* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize_w_params(
        com_saabgroup_enterprisebus_idldemo_Variants* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_return(
        com_saabgroup_enterprisebus_idldemo_Variants* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Variants_finalize(
        com_saabgroup_enterprisebus_idldemo_Variants* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Variants_finalize_ex(
        com_saabgroup_enterprisebus_idldemo_Variants* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_params(
        com_saabgroup_enterprisebus_idldemo_Variants* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Variants_finalize_optional_members(
        com_saabgroup_enterprisebus_idldemo_Variants* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Variants_copy(
        com_saabgroup_enterprisebus_idldemo_Variants* dst,
        const com_saabgroup_enterprisebus_idldemo_Variants* src);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    extern const char *com_saabgroup_enterprisebus_idldemo_DemoTYPENAME;

    typedef struct com_saabgroup_enterprisebus_idldemo_Demo
    {

        DDS_Long _d;
        struct com_saabgroup_enterprisebus_idldemo_Demo_u 
        {

            com_saabgroup_enterprisebus_idldemo_MyStruct aStruct;
            DDS_Boolean aBoolean;
            DDS_Long aLong;
            DDS_Double aDouble;
        }_u;

    } com_saabgroup_enterprisebus_idldemo_Demo ;
    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    #ifndef NDDS_STANDALONE_TYPE
    NDDSUSERDllExport DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_Demo_get_typecode(void); /* Type code */
    NDDSUSERDllExport RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_Demo_get_type_plugin_info(void);
    NDDSUSERDllExport RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_Demo_get_sample_access_info(void);
    #endif

    DDS_SEQUENCE(com_saabgroup_enterprisebus_idldemo_DemoSeq, com_saabgroup_enterprisebus_idldemo_Demo);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize(
        com_saabgroup_enterprisebus_idldemo_Demo* self);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize_ex(
        com_saabgroup_enterprisebus_idldemo_Demo* self,RTIBool allocatePointers,RTIBool allocateMemory);

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize_w_params(
        com_saabgroup_enterprisebus_idldemo_Demo* self,
        const struct DDS_TypeAllocationParams_t * allocParams);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_return(
        com_saabgroup_enterprisebus_idldemo_Demo* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Demo_finalize(
        com_saabgroup_enterprisebus_idldemo_Demo* self);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(
        com_saabgroup_enterprisebus_idldemo_Demo* self,RTIBool deletePointers);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params(
        com_saabgroup_enterprisebus_idldemo_Demo* self,
        const struct DDS_TypeDeallocationParams_t * deallocParams);

    NDDSUSERDllExport
    void com_saabgroup_enterprisebus_idldemo_Demo_finalize_optional_members(
        com_saabgroup_enterprisebus_idldemo_Demo* self, RTIBool deletePointers);  

    NDDSUSERDllExport
    RTIBool com_saabgroup_enterprisebus_idldemo_Demo_copy(
        com_saabgroup_enterprisebus_idldemo_Demo* dst,
        const com_saabgroup_enterprisebus_idldemo_Demo* src);

    NDDSUSERDllExport
    DDS_LongLong com_saabgroup_enterprisebus_idldemo_Demo_getDefaultDiscriminator(void);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif /* Demo */
