

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef DemoPlugin_920141085_h
#define DemoPlugin_920141085_h

#include "Demo.h"

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

    #define com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define com_saabgroup_enterprisebus_idldemo_MyStructPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define com_saabgroup_enterprisebus_idldemo_MyStructPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define com_saabgroup_enterprisebus_idldemo_MyStructPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_MyStruct*
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_MyStruct*
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_MyStruct*
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_copy_data(
        com_saabgroup_enterprisebus_idldemo_MyStruct *out,
        const com_saabgroup_enterprisebus_idldemo_MyStruct *in);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data_w_params(
        com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data_ex(
        com_saabgroup_enterprisebus_idldemo_MyStruct *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data(
        com_saabgroup_enterprisebus_idldemo_MyStruct *sample);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_print_data(
        const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_MyStruct *out,
        const com_saabgroup_enterprisebus_idldemo_MyStruct *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const com_saabgroup_enterprisebus_idldemo_MyStruct *sample); 

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_deserialize_from_cdr_buffer(
        com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_data_to_string(
        const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_MyStruct ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_new(void);

    NDDSUSERDllExport extern void
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_delete(struct PRESTypePlugin *);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_VariantsPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_VariantsPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_VariantsPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* ----------------------------------------------------------------------------
    Support functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern void
    com_saabgroup_enterprisebus_idldemo_VariantsPluginSupport_print_data(
        const com_saabgroup_enterprisebus_idldemo_Variants *sample,
        const char *desc,
        unsigned int indent_level);

    #define com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define com_saabgroup_enterprisebus_idldemo_DemoPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define com_saabgroup_enterprisebus_idldemo_DemoPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define com_saabgroup_enterprisebus_idldemo_DemoPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_Demo*
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_Demo*
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern com_saabgroup_enterprisebus_idldemo_Demo*
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_copy_data(
        com_saabgroup_enterprisebus_idldemo_Demo *out,
        const com_saabgroup_enterprisebus_idldemo_Demo *in);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data_w_params(
        com_saabgroup_enterprisebus_idldemo_Demo *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data_ex(
        com_saabgroup_enterprisebus_idldemo_Demo *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data(
        com_saabgroup_enterprisebus_idldemo_Demo *sample);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_print_data(
        const com_saabgroup_enterprisebus_idldemo_Demo *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_Demo *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_Demo *out,
        const com_saabgroup_enterprisebus_idldemo_Demo *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const com_saabgroup_enterprisebus_idldemo_Demo *sample); 

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const com_saabgroup_enterprisebus_idldemo_Demo *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_deserialize_from_cdr_buffer(
        com_saabgroup_enterprisebus_idldemo_Demo *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_data_to_string(
        const com_saabgroup_enterprisebus_idldemo_Demo *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        com_saabgroup_enterprisebus_idldemo_Demo ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_new(void);

    NDDSUSERDllExport extern void
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* DemoPlugin_920141085_h */
