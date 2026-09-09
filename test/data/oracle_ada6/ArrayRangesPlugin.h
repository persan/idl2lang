

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from ArrayRanges.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef ArrayRangesPlugin_237584959_h
#define ArrayRangesPlugin_237584959_h

#include "ArrayRanges.h"

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

    #define hello_World_TPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define hello_World_TPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define hello_World_TPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define hello_World_TPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define hello_World_TPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern hello_World_T*
    hello_World_TPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern hello_World_T*
    hello_World_TPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern hello_World_T*
    hello_World_TPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    hello_World_TPluginSupport_copy_data(
        hello_World_T *out,
        const hello_World_T *in);

    NDDSUSERDllExport extern void 
    hello_World_TPluginSupport_destroy_data_w_params(
        hello_World_T *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    hello_World_TPluginSupport_destroy_data_ex(
        hello_World_T *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    hello_World_TPluginSupport_destroy_data(
        hello_World_T *sample);

    NDDSUSERDllExport extern void 
    hello_World_TPluginSupport_print_data(
        const hello_World_T *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    hello_World_TPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    hello_World_TPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    hello_World_TPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    hello_World_TPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    hello_World_TPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        hello_World_T *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    hello_World_TPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        hello_World_T *out,
        const hello_World_T *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    hello_World_TPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const hello_World_T *sample); 

    NDDSUSERDllExport extern RTIBool
    hello_World_TPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const hello_World_T *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    hello_World_TPlugin_deserialize_from_cdr_buffer(
        hello_World_T *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    hello_World_TPlugin_data_to_string(
        const hello_World_T *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    hello_World_TPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    hello_World_TPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    hello_World_TPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    hello_World_TPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    hello_World_TPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        hello_World_T ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * hello_World_TPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    hello_World_TPlugin_new(void);

    NDDSUSERDllExport extern void
    hello_World_TPlugin_delete(struct PRESTypePlugin *);

    #define hello_HelloWorldPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define hello_HelloWorldPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define hello_HelloWorldPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define hello_HelloWorldPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define hello_HelloWorldPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern hello_HelloWorld*
    hello_HelloWorldPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern hello_HelloWorld*
    hello_HelloWorldPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern hello_HelloWorld*
    hello_HelloWorldPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    hello_HelloWorldPluginSupport_copy_data(
        hello_HelloWorld *out,
        const hello_HelloWorld *in);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPluginSupport_destroy_data_w_params(
        hello_HelloWorld *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPluginSupport_destroy_data_ex(
        hello_HelloWorld *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPluginSupport_destroy_data(
        hello_HelloWorld *sample);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPluginSupport_print_data(
        const hello_HelloWorld *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    hello_HelloWorldPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    hello_HelloWorldPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    hello_HelloWorldPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    hello_HelloWorldPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        hello_HelloWorld *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    hello_HelloWorldPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        hello_HelloWorld *out,
        const hello_HelloWorld *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    hello_HelloWorldPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const hello_HelloWorld *sample); 

    NDDSUSERDllExport extern RTIBool
    hello_HelloWorldPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const hello_HelloWorld *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    hello_HelloWorldPlugin_deserialize_from_cdr_buffer(
        hello_HelloWorld *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    hello_HelloWorldPlugin_data_to_string(
        const hello_HelloWorld *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    hello_HelloWorldPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    hello_HelloWorldPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    hello_HelloWorldPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    hello_HelloWorldPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    hello_HelloWorldPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        hello_HelloWorld ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * hello_HelloWorldPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    hello_HelloWorldPlugin_new(void);

    NDDSUSERDllExport extern void
    hello_HelloWorldPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* ArrayRangesPlugin_237584959_h */
