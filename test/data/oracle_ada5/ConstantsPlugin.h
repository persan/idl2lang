

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Constants.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef ConstantsPlugin_1942815470_h
#define ConstantsPlugin_1942815470_h

#include "Constants.h"

struct RTICdrStream;

#ifndef pres_typePlugin_h
#include "pres/pres_typePlugin.h"
#endif

#if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport __declspec(dllexport)
#endif

#if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
    #endif

    #define MYLONGPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define MYLONGPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define MYLONGPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define MYLONGPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define MYLONGPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern MYLONG*
    MYLONGPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern MYLONG*
    MYLONGPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern MYLONG*
    MYLONGPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    MYLONGPluginSupport_copy_data(
        MYLONG *out,
        const MYLONG *in);

    NDDSUSERDllExport extern void 
    MYLONGPluginSupport_destroy_data_w_params(
        MYLONG *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    MYLONGPluginSupport_destroy_data_ex(
        MYLONG *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    MYLONGPluginSupport_destroy_data(
        MYLONG *sample);

    NDDSUSERDllExport extern void 
    MYLONGPluginSupport_print_data(
        const MYLONG *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool 
    MYLONGPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        MYLONG *out,
        const MYLONG *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern unsigned int 
    MYLONGPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    MYLONGPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    MYLONGPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    MYLONGPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* ConstantsPlugin_1942815470_h */
