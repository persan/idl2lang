

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from base.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef basePlugin_1722633201_h
#define basePlugin_1722633201_h

#include "base.h"

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

    #define vtypes_test_base_position_tPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define vtypes_test_base_position_tPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define vtypes_test_base_position_tPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define vtypes_test_base_position_tPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define vtypes_test_base_position_tPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern vtypes_test_base_position_t*
    vtypes_test_base_position_tPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern vtypes_test_base_position_t*
    vtypes_test_base_position_tPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern vtypes_test_base_position_t*
    vtypes_test_base_position_tPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_position_tPluginSupport_copy_data(
        vtypes_test_base_position_t *out,
        const vtypes_test_base_position_t *in);

    NDDSUSERDllExport extern void 
    vtypes_test_base_position_tPluginSupport_destroy_data_w_params(
        vtypes_test_base_position_t *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    vtypes_test_base_position_tPluginSupport_destroy_data_ex(
        vtypes_test_base_position_t *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    vtypes_test_base_position_tPluginSupport_destroy_data(
        vtypes_test_base_position_t *sample);

    NDDSUSERDllExport extern void 
    vtypes_test_base_position_tPluginSupport_print_data(
        const vtypes_test_base_position_t *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_position_tPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_position_t *out,
        const vtypes_test_base_position_t *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_position_tPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const vtypes_test_base_position_t *sample); 

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_position_tPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const vtypes_test_base_position_t *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_position_tPlugin_deserialize_from_cdr_buffer(
        vtypes_test_base_position_t *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    vtypes_test_base_position_tPlugin_data_to_string(
        const vtypes_test_base_position_t *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_position_tPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    vtypes_test_base_position_tPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_position_tPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_position_tPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_position_tPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_position_t ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * vtypes_test_base_position_tPlugin_get_programs(void);

    #define vtypes_test_base_speed_tPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define vtypes_test_base_speed_tPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define vtypes_test_base_speed_tPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define vtypes_test_base_speed_tPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define vtypes_test_base_speed_tPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern vtypes_test_base_speed_t*
    vtypes_test_base_speed_tPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern vtypes_test_base_speed_t*
    vtypes_test_base_speed_tPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern vtypes_test_base_speed_t*
    vtypes_test_base_speed_tPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_speed_tPluginSupport_copy_data(
        vtypes_test_base_speed_t *out,
        const vtypes_test_base_speed_t *in);

    NDDSUSERDllExport extern void 
    vtypes_test_base_speed_tPluginSupport_destroy_data_w_params(
        vtypes_test_base_speed_t *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    vtypes_test_base_speed_tPluginSupport_destroy_data_ex(
        vtypes_test_base_speed_t *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    vtypes_test_base_speed_tPluginSupport_destroy_data(
        vtypes_test_base_speed_t *sample);

    NDDSUSERDllExport extern void 
    vtypes_test_base_speed_tPluginSupport_print_data(
        const vtypes_test_base_speed_t *sample,
        const char *desc,
        unsigned int indent);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_speed_tPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_speed_t *out,
        const vtypes_test_base_speed_t *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_speed_tPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const vtypes_test_base_speed_t *sample); 

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_speed_tPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const vtypes_test_base_speed_t *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_speed_tPlugin_deserialize_from_cdr_buffer(
        vtypes_test_base_speed_t *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    vtypes_test_base_speed_tPlugin_data_to_string(
        const vtypes_test_base_speed_t *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_speed_tPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    vtypes_test_base_speed_tPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_speed_tPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_speed_tPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_speed_tPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_speed_t ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * vtypes_test_base_speed_tPlugin_get_programs(void);

    /* The type used to store keys for instances of type struct
    * AnotherSimple.
    *
    * By default, this type is struct basetrack_t
    * itself. However, if for some reason this choice is not practical for your
    * system (e.g. if sizeof(struct basetrack_t)
    * is very large), you may redefine this typedef in terms of another type of
    * your choosing. HOWEVER, if you define the KeyHolder type to be something
    * other than struct AnotherSimple, the
    * following restriction applies: the key of struct
    * basetrack_t must consist of a
    * single field of your redefined KeyHolder type and that field must be the
    * first field in struct basetrack_t.
    */
    typedef  struct vtypes_test_base_basetrack_t vtypes_test_base_basetrack_tKeyHolder;

    #define vtypes_test_base_basetrack_tPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define vtypes_test_base_basetrack_tPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define vtypes_test_base_basetrack_tPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define vtypes_test_base_basetrack_tPlugin_get_key PRESTypePluginDefaultEndpointData_getKey 
    #define vtypes_test_base_basetrack_tPlugin_return_key PRESTypePluginDefaultEndpointData_returnKey

    #define vtypes_test_base_basetrack_tPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define vtypes_test_base_basetrack_tPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern vtypes_test_base_basetrack_t*
    vtypes_test_base_basetrack_tPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern vtypes_test_base_basetrack_t*
    vtypes_test_base_basetrack_tPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern vtypes_test_base_basetrack_t*
    vtypes_test_base_basetrack_tPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPluginSupport_copy_data(
        vtypes_test_base_basetrack_t *out,
        const vtypes_test_base_basetrack_t *in);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_destroy_data_w_params(
        vtypes_test_base_basetrack_t *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_destroy_data_ex(
        vtypes_test_base_basetrack_t *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_destroy_data(
        vtypes_test_base_basetrack_t *sample);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_print_data(
        const vtypes_test_base_basetrack_t *sample,
        const char *desc,
        unsigned int indent);

    NDDSUSERDllExport extern vtypes_test_base_basetrack_t*
    vtypes_test_base_basetrack_tPluginSupport_create_key_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern vtypes_test_base_basetrack_t*
    vtypes_test_base_basetrack_tPluginSupport_create_key(void);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_destroy_key_ex(
        vtypes_test_base_basetrack_tKeyHolder *key,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPluginSupport_destroy_key(
        vtypes_test_base_basetrack_tKeyHolder *key);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    vtypes_test_base_basetrack_tPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    vtypes_test_base_basetrack_tPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    vtypes_test_base_basetrack_tPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    vtypes_test_base_basetrack_tPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_basetrack_t *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_basetrack_t *out,
        const vtypes_test_base_basetrack_t *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_basetrack_tPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const vtypes_test_base_basetrack_t *sample); 

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_basetrack_tPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const vtypes_test_base_basetrack_t *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    vtypes_test_base_basetrack_tPlugin_deserialize_from_cdr_buffer(
        vtypes_test_base_basetrack_t *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    vtypes_test_base_basetrack_tPlugin_data_to_string(
        const vtypes_test_base_basetrack_t *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_basetrack_tPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    vtypes_test_base_basetrack_tPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_basetrack_tPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    vtypes_test_base_basetrack_tPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_basetrack_t ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPlugin_instance_to_key(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_basetrack_tKeyHolder *key, 
        const vtypes_test_base_basetrack_t *instance);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPlugin_key_to_instance(
        PRESTypePluginEndpointData endpoint_data,
        vtypes_test_base_basetrack_t *instance, 
        const vtypes_test_base_basetrack_tKeyHolder *key);

    NDDSUSERDllExport extern RTIBool 
    vtypes_test_base_basetrack_tPlugin_serialized_sample_to_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        struct RTICdrStream *cdrStream, 
        DDS_KeyHash_t *keyhash,
        RTIBool deserialize_encapsulation,
        void *endpoint_plugin_qos); 

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * vtypes_test_base_basetrack_tPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    vtypes_test_base_basetrack_tPlugin_new(void);

    NDDSUSERDllExport extern void
    vtypes_test_base_basetrack_tPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* basePlugin_1722633201_h */
