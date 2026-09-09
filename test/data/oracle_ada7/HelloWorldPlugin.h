

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from HelloWorld.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef HelloWorldPlugin_1436886533_h
#define HelloWorldPlugin_1436886533_h

#include "HelloWorld.h"

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

    /* The type used to store keys for instances of type struct
    * AnotherSimple.
    *
    * By default, this type is struct HelloWorld
    * itself. However, if for some reason this choice is not practical for your
    * system (e.g. if sizeof(struct HelloWorld)
    * is very large), you may redefine this typedef in terms of another type of
    * your choosing. HOWEVER, if you define the KeyHolder type to be something
    * other than struct AnotherSimple, the
    * following restriction applies: the key of struct
    * HelloWorld must consist of a
    * single field of your redefined KeyHolder type and that field must be the
    * first field in struct HelloWorld.
    */
    typedef  struct testCodeGen_HelloWorld testCodeGen_HelloWorldKeyHolder;

    #define testCodeGen_HelloWorldPlugin_get_sample PRESTypePluginDefaultEndpointData_getSample 

    #define testCodeGen_HelloWorldPlugin_get_buffer PRESTypePluginDefaultEndpointData_getBuffer 
    #define testCodeGen_HelloWorldPlugin_return_buffer PRESTypePluginDefaultEndpointData_returnBuffer

    #define testCodeGen_HelloWorldPlugin_get_key PRESTypePluginDefaultEndpointData_getKey 
    #define testCodeGen_HelloWorldPlugin_return_key PRESTypePluginDefaultEndpointData_returnKey

    #define testCodeGen_HelloWorldPlugin_create_sample PRESTypePluginDefaultEndpointData_createSample 
    #define testCodeGen_HelloWorldPlugin_destroy_sample PRESTypePluginDefaultEndpointData_deleteSample 

    /* --------------------------------------------------------------------------------------
    Support functions:
    * -------------------------------------------------------------------------------------- */

    NDDSUSERDllExport extern testCodeGen_HelloWorld*
    testCodeGen_HelloWorldPluginSupport_create_data_w_params(
        const struct DDS_TypeAllocationParams_t * alloc_params);

    NDDSUSERDllExport extern testCodeGen_HelloWorld*
    testCodeGen_HelloWorldPluginSupport_create_data_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern testCodeGen_HelloWorld*
    testCodeGen_HelloWorldPluginSupport_create_data(void);

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPluginSupport_copy_data(
        testCodeGen_HelloWorld *out,
        const testCodeGen_HelloWorld *in);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_destroy_data_w_params(
        testCodeGen_HelloWorld *sample,
        const struct DDS_TypeDeallocationParams_t * dealloc_params);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_destroy_data_ex(
        testCodeGen_HelloWorld *sample,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_destroy_data(
        testCodeGen_HelloWorld *sample);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_print_data(
        const testCodeGen_HelloWorld *sample,
        const char *desc,
        unsigned int indent);

    NDDSUSERDllExport extern testCodeGen_HelloWorld*
    testCodeGen_HelloWorldPluginSupport_create_key_ex(RTIBool allocate_pointers);

    NDDSUSERDllExport extern testCodeGen_HelloWorld*
    testCodeGen_HelloWorldPluginSupport_create_key(void);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_destroy_key_ex(
        testCodeGen_HelloWorldKeyHolder *key,RTIBool deallocate_pointers);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPluginSupport_destroy_key(
        testCodeGen_HelloWorldKeyHolder *key);

    /* ----------------------------------------------------------------------------
    Callback functions:
    * ---------------------------------------------------------------------------- */

    NDDSUSERDllExport extern PRESTypePluginParticipantData 
    testCodeGen_HelloWorldPlugin_on_participant_attached(
        void *registration_data, 
        const struct PRESTypePluginParticipantInfo *participant_info,
        RTIBool top_level_registration, 
        void *container_plugin_context,
        RTICdrTypeCode *typeCode);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPlugin_on_participant_detached(
        PRESTypePluginParticipantData participant_data);

    NDDSUSERDllExport extern PRESTypePluginEndpointData 
    testCodeGen_HelloWorldPlugin_on_endpoint_attached(
        PRESTypePluginParticipantData participant_data,
        const struct PRESTypePluginEndpointInfo *endpoint_info,
        RTIBool top_level_registration, 
        void *container_plugin_context);

    NDDSUSERDllExport extern void 
    testCodeGen_HelloWorldPlugin_on_endpoint_detached(
        PRESTypePluginEndpointData endpoint_data);

    NDDSUSERDllExport extern void    
    testCodeGen_HelloWorldPlugin_return_sample(
        PRESTypePluginEndpointData endpoint_data,
        testCodeGen_HelloWorld *sample,
        void *handle);    

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPlugin_copy_sample(
        PRESTypePluginEndpointData endpoint_data,
        testCodeGen_HelloWorld *out,
        const testCodeGen_HelloWorld *in);

    /* ----------------------------------------------------------------------------
    (De)Serialize functions:
    * ------------------------------------------------------------------------- */

    NDDSUSERDllExport extern RTIBool
    testCodeGen_HelloWorldPlugin_serialize_to_cdr_buffer(
        char * buffer,
        unsigned int * length,
        const testCodeGen_HelloWorld *sample); 

    NDDSUSERDllExport extern RTIBool
    testCodeGen_HelloWorldPlugin_serialize_to_cdr_buffer_ex(
        char *buffer,
        unsigned int *length,
        const testCodeGen_HelloWorld *sample,
        DDS_DataRepresentationId_t representation);

    NDDSUSERDllExport extern RTIBool
    testCodeGen_HelloWorldPlugin_deserialize_from_cdr_buffer(
        testCodeGen_HelloWorld *sample,
        const char * buffer,
        unsigned int length);    
    #if !defined (NDDS_STANDALONE_TYPE)
    NDDSUSERDllExport extern DDS_ReturnCode_t
    testCodeGen_HelloWorldPlugin_data_to_string(
        const testCodeGen_HelloWorld *sample,
        char *str,
        DDS_UnsignedLong *str_size, 
        const struct DDS_PrintFormatProperty *property);    
    #endif

    NDDSUSERDllExport extern unsigned int 
    testCodeGen_HelloWorldPlugin_get_serialized_sample_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    /* --------------------------------------------------------------------------------------
    Key Management functions:
    * -------------------------------------------------------------------------------------- */
    NDDSUSERDllExport extern PRESTypePluginKeyKind 
    testCodeGen_HelloWorldPlugin_get_key_kind(void);

    NDDSUSERDllExport extern unsigned int 
    testCodeGen_HelloWorldPlugin_get_serialized_key_max_size(
        PRESTypePluginEndpointData endpoint_data,
        RTIBool include_encapsulation,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern unsigned int 
    testCodeGen_HelloWorldPlugin_get_serialized_key_max_size_for_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        RTIEncapsulationId encapsulation_id,
        unsigned int current_alignment);

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPlugin_deserialize_key(
        PRESTypePluginEndpointData endpoint_data,
        testCodeGen_HelloWorld ** sample,
        RTIBool * drop_sample,
        struct RTICdrStream *cdrStream,
        RTIBool deserialize_encapsulation,
        RTIBool deserialize_key,
        void *endpoint_plugin_qos);

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPlugin_instance_to_key(
        PRESTypePluginEndpointData endpoint_data,
        testCodeGen_HelloWorldKeyHolder *key, 
        const testCodeGen_HelloWorld *instance);

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPlugin_key_to_instance(
        PRESTypePluginEndpointData endpoint_data,
        testCodeGen_HelloWorld *instance, 
        const testCodeGen_HelloWorldKeyHolder *key);

    NDDSUSERDllExport extern RTIBool 
    testCodeGen_HelloWorldPlugin_serialized_sample_to_keyhash(
        PRESTypePluginEndpointData endpoint_data,
        struct RTICdrStream *cdrStream, 
        DDS_KeyHash_t *keyhash,
        RTIBool deserialize_encapsulation,
        void *endpoint_plugin_qos); 

    NDDSUSERDllExport extern
    struct RTIXCdrInterpreterPrograms * testCodeGen_HelloWorldPlugin_get_programs(void);

    /* Plugin Functions */
    NDDSUSERDllExport extern struct PRESTypePlugin*
    testCodeGen_HelloWorldPlugin_new(void);

    NDDSUSERDllExport extern void
    testCodeGen_HelloWorldPlugin_delete(struct PRESTypePlugin *);

    #ifdef __cplusplus
}
#endif

#if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
#undef NDDSUSERDllExport
#define NDDSUSERDllExport
#endif

#endif /* HelloWorldPlugin_1436886533_h */
