

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from sequences.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef sequencesPlugin_704363284_h
#define sequencesPlugin_704363284_h

#include "sequences.h"

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

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_copy_data(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *out,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *in);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_destroy_data_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_destroy_data_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_destroy_data(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPluginSupport_print_data(
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *out,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample); 

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_deserialize_from_cdr_buffer(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_data_to_string(
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_new(void);

    NDDSUSERDllExport extern void
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_delete(struct PRESTypePlugin *);

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_copy_data(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *out,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *in);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_destroy_data_w_params(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_destroy_data_ex(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_destroy_data(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPluginSupport_print_data(
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *out,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample); 

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_deserialize_from_cdr_buffer(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_data_to_string(
        const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_new(void);

    NDDSUSERDllExport extern void
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* sequencesPlugin_704363284_h */
