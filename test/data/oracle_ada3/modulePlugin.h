

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from module.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef modulePlugin_871297053_h
#define modulePlugin_871297053_h

#include "module.h"

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

    #define a_b_c_fooPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define a_b_c_fooPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define a_b_c_fooPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define a_b_c_fooPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define a_b_c_fooPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern a_b_c_foo*
    a_b_c_fooPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern a_b_c_foo*
    a_b_c_fooPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern a_b_c_foo*
    a_b_c_fooPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    a_b_c_fooPluginSupport_copy_data(
        a_b_c_foo *out,
        const a_b_c_foo *in);

    NDDSUSERDllExport extern void 
    a_b_c_fooPluginSupport_destroy_data_w_params(
        a_b_c_foo *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    a_b_c_fooPluginSupport_destroy_data_ex(
        a_b_c_foo *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    a_b_c_fooPluginSupport_destroy_data(
        a_b_c_foo *sample);

    NDDSUSERDllExport extern void 
    a_b_c_fooPluginSupport_print_data(
        const a_b_c_foo *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    a_b_c_fooPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    a_b_c_fooPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    a_b_c_fooPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    a_b_c_fooPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    a_b_c_fooPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        a_b_c_foo *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    a_b_c_fooPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        a_b_c_foo *out,
        const a_b_c_foo *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    a_b_c_fooPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const a_b_c_foo *sample); 

    NDDSUSERDllExport extern RTIBool
    a_b_c_fooPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const a_b_c_foo *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    a_b_c_fooPlugin_deserialize_from_cdr_buffer(
        a_b_c_foo *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    a_b_c_fooPlugin_data_to_string(
        const a_b_c_foo *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    a_b_c_fooPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    a_b_c_fooPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    a_b_c_fooPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    a_b_c_fooPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    a_b_c_fooPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        a_b_c_foo ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * a_b_c_fooPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    a_b_c_fooPlugin_new(void);

    NDDSUSERDllExport extern void
    a_b_c_fooPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* modulePlugin_871297053_h */
