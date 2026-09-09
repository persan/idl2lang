
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#include <string.h>

#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif

#ifndef cdr_type_h
#include "cdr/cdr_type.h"
#endif

#ifndef cdr_type_object_h
#include "cdr/cdr_typeObject.h"
#endif

#ifndef cdr_encapsulation_h
#include "cdr/cdr_encapsulation.h"
#endif

#ifndef cdr_stream_h
#include "cdr/cdr_stream.h"
#endif

#include "xcdr/xcdr_interpreter.h"
#include "xcdr/xcdr_stream.h"

#ifndef cdr_log_h
#include "cdr/cdr_log.h"
#endif

#ifndef pres_typePlugin_h
#include "pres/pres_typePlugin.h"
#endif

#include "dds_c/dds_c_typecode_impl.h"

#define RTI_CDR_CURRENT_SUBMODULE RTI_CDR_SUBMODULE_MASK_STREAM

#include "DemoPlugin.h"

/* ----------------------------------------------------------------------------
*  Type com_saabgroup_enterprisebus_idldemo_MyStruct
* -------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
Support functions:
* -------------------------------------------------------------------------- */

com_saabgroup_enterprisebus_idldemo_MyStruct*
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data_w_params(
    const struct DDS_TypeAllocationParams_t * alloc_params)
{
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample = NULL;

    if (alloc_params == NULL) {
        return NULL;
    } else if(!alloc_params->allocate_memory) {
        RTICdrLog_exception(&RTI_CDR_LOG_TYPE_OBJECT_NOT_ASSIGNABLE_ss,
        "alloc_params->allocate_memory","false");
        return NULL;
    }

    RTIOsapiHeap_allocateStructure(&(sample),com_saabgroup_enterprisebus_idldemo_MyStruct);
    if (sample == NULL) {
        return NULL;
    }

    if (!com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params(sample,alloc_params)) {
        struct DDS_TypeDeallocationParams_t deallocParams =
        DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
        deallocParams.delete_pointers = alloc_params->allocate_pointers;
        deallocParams.delete_optional_members = alloc_params->allocate_pointers;
        /* Coverity reports a possible uninit_use_in_call that will happen if the
        allocation fails. But if the allocation fails then sample == null and
        the method will return before reach this point.*/
        /* Coverity reports a possible overwrite_var on the members of the sample.
        It is a false positive since all the pointers are freed before assigning
        null to them. */
        /* coverity[uninit_use_in_call : FALSE] */
        /* coverity[overwrite_var : FALSE] */
        com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(sample, &deallocParams);
        /* Coverity reports a possible leaked_storage on the sample members when
        freeing sample. It is a false positive since all the members' memory
        is freed in the call "com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex" */
        /* coverity[leaked_storage : FALSE] */
        RTIOsapiHeap_freeStructure(sample);
        sample=NULL;
    }
    return sample;
}

com_saabgroup_enterprisebus_idldemo_MyStruct *
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data_ex(RTIBool allocate_pointers)
{
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample = NULL;

    RTIOsapiHeap_allocateStructure(&(sample),com_saabgroup_enterprisebus_idldemo_MyStruct);

    if(sample == NULL) {
        return NULL;
    }

    /* coverity[example_checked : FALSE] */
    if (!com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_ex(sample,allocate_pointers, RTI_TRUE)) {
        /* Coverity reports a possible uninit_use_in_call that will happen if the
        new fails. But if new fails then sample == null and the method will
        return before reach this point. */
        /* Coverity reports a possible overwrite_var on the members of the sample.
        It is a false positive since all the pointers are freed before assigning
        null to them. */
        /* coverity[uninit_use_in_call : FALSE] */
        /* coverity[overwrite_var : FALSE] */
        com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(sample, RTI_TRUE);
        /* Coverity reports a possible leaked_storage on the sample members when
        freeing sample. It is a false positive since all the members' memory
        is freed in the call "com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex" */
        /* coverity[leaked_storage : FALSE] */
        RTIOsapiHeap_freeStructure(sample);
        sample=NULL;
    }

    return sample;
}

void *
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_dataI(void)
{
    return com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data_ex(RTI_TRUE);
}

com_saabgroup_enterprisebus_idldemo_MyStruct *
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_data(void)
{
    return (com_saabgroup_enterprisebus_idldemo_MyStruct *) com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_dataI();
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data_w_params(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    const struct DDS_TypeDeallocationParams_t * dealloc_params) {
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(sample,dealloc_params);

    RTIOsapiHeap_freeStructure(sample);
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data_ex(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,RTIBool deallocate_pointers) {
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(sample,deallocate_pointers);

    RTIOsapiHeap_freeStructure(sample);
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample) {

    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data_ex(sample,RTI_TRUE);

}

void
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_dataI(
    void *sample)
{
    com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_data((com_saabgroup_enterprisebus_idldemo_MyStruct *) sample);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_copy_data(
    com_saabgroup_enterprisebus_idldemo_MyStruct *dst,
    const com_saabgroup_enterprisebus_idldemo_MyStruct *src)
{
    return com_saabgroup_enterprisebus_idldemo_MyStruct_copy(dst,(const com_saabgroup_enterprisebus_idldemo_MyStruct*) src);
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_print_data(
    const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    const char *desc,
    unsigned int indent_level)
{

    RTICdrType_printIndent(indent_level);

    if (desc != NULL) {
        RTILogParamString_printPlain("%s:\n", desc);
    } else {
        RTILogParamString_printPlain("\n");
    }

    if (sample == NULL) {
        RTILogParamString_printPlain("NULL\n");
        return;
    }

    RTICdrType_printLong(
        &sample->X,
        "X",
        RTIOsapiUtility_uInt32Plus1(indent_level));

    RTICdrType_printLong(
        &sample->Y,
        "Y",
        RTIOsapiUtility_uInt32Plus1(indent_level));

    RTICdrType_printLong(
        &sample->Z,
        "Z",
        RTIOsapiUtility_uInt32Plus1(indent_level));

}

/* ----------------------------------------------------------------------------
Callback functions:
* ---------------------------------------------------------------------------- */

PRESTypePluginParticipantData
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_attached(
    void *registration_data,
    const struct PRESTypePluginParticipantInfo *participant_info,
    RTIBool top_level_registration,
    void *container_plugin_context,
    RTICdrTypeCode *type_code)
{
    struct RTIXCdrInterpreterPrograms *programs = NULL;
    struct RTIXCdrInterpreterProgramsGenProperty programProperty =
    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;
    struct PRESTypePluginDefaultParticipantData *pd = NULL;

    RTIOsapiUtility_unusedParameter(registration_data);
    RTIOsapiUtility_unusedParameter(participant_info);
    RTIOsapiUtility_unusedParameter(top_level_registration);
    RTIOsapiUtility_unusedParameter(container_plugin_context);
    RTIOsapiUtility_unusedParameter(type_code);

    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {
        return NULL;
    }

    pd = (struct PRESTypePluginDefaultParticipantData *)
    PRESTypePluginDefaultParticipantData_new(participant_info);

    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;
    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;

    programProperty.resolveAlias = RTI_XCDR_TRUE;
    programProperty.inlineStruct = RTI_XCDR_TRUE;
    programProperty.optimizeEnum = RTI_XCDR_TRUE;
    programProperty.unboundedSize = RTIXCdrLong_MAX;

    programs = DDS_TypeCodeFactory_assert_programs_in_global_list(
        DDS_TypeCodeFactory_get_instance(),
        com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode(),
        &programProperty,
        RTI_XCDR_PROGRAM_MASK_TYPEPLUGIN);
    if (programs == NULL) {
        PRESTypePluginDefaultParticipantData_delete(
            (PRESTypePluginParticipantData) pd);
        return NULL;
    }

    pd->programs = programs;
    return (PRESTypePluginParticipantData)pd;
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_detached(
    PRESTypePluginParticipantData participant_data)
{
    if (participant_data != NULL) {
        struct PRESTypePluginDefaultParticipantData *pd =
        (struct PRESTypePluginDefaultParticipantData *)participant_data;

        if (pd->programs != NULL) {
            DDS_TypeCodeFactory_remove_programs_from_global_list(
                DDS_TypeCodeFactory_get_instance(),
                pd->programs);
            pd->programs = NULL;
        }
        PRESTypePluginDefaultParticipantData_delete(participant_data);
    }
}

PRESTypePluginEndpointData
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_attached(
    PRESTypePluginParticipantData participant_data,
    const struct PRESTypePluginEndpointInfo *endpoint_info,
    RTIBool top_level_registration,
    void *containerPluginContext)
{
    PRESTypePluginEndpointData epd = NULL;
    unsigned int serializedSampleMaxSize = 0;

    RTIOsapiUtility_unusedParameter(top_level_registration);
    RTIOsapiUtility_unusedParameter(containerPluginContext);

    if (participant_data == NULL) {
        return NULL;
    }

    epd = PRESTypePluginDefaultEndpointData_new(
        participant_data,
        endpoint_info,
        com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_create_dataI,
        com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_destroy_dataI,
        NULL , NULL );

    if (epd == NULL) {
        return NULL;
    }

    if (endpoint_info->endpointKind == PRES_TYPEPLUGIN_ENDPOINT_WRITER) {
        serializedSampleMaxSize = com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size(
            epd,RTI_FALSE,RTI_CDR_ENCAPSULATION_ID_CDR_BE,0);
        PRESTypePluginDefaultEndpointData_setMaxSizeSerializedSample(epd, serializedSampleMaxSize);

        if (PRESTypePluginDefaultEndpointData_createWriterPool(
            epd,
            endpoint_info,
            (PRESTypePluginGetSerializedSampleMaxSizeFunction)
            com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size, epd,
            (PRESTypePluginGetSerializedSampleSizeFunction)
            PRESTypePlugin_interpretedGetSerializedSampleSize,
            epd) == RTI_FALSE) {
            PRESTypePluginDefaultEndpointData_delete(epd);
            return NULL;
        }
    }

    return epd;
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_detached(
    PRESTypePluginEndpointData endpoint_data)
{
    PRESTypePluginDefaultEndpointData_delete(endpoint_data);
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_return_sample(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    void *handle)
{
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_optional_members(sample, RTI_TRUE);

    PRESTypePluginDefaultEndpointData_returnSample(
        endpoint_data, sample, handle);
}

void com_saabgroup_enterprisebus_idldemo_MyStructPlugin_finalize_optional_members(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_MyStruct* sample,
    RTIBool deletePointers)
{
    RTIOsapiUtility_unusedParameter(endpoint_data);
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_optional_members(
        sample, deletePointers);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_copy_sample(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_MyStruct *dst,
    const com_saabgroup_enterprisebus_idldemo_MyStruct *src)
{
    RTIOsapiUtility_unusedParameter(endpoint_data);
    return com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_copy_data(dst,src);
}

/* ----------------------------------------------------------------------------
(De)Serialize functions:
* ------------------------------------------------------------------------- */
unsigned int
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment);

RTIBool
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer_ex(
    char *buffer,
    unsigned int *length,
    const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    DDS_DataRepresentationId_t representation)
{
    RTIEncapsulationId encapsulationId = RTI_CDR_ENCAPSULATION_ID_INVALID;
    struct RTICdrStream cdrStream;
    struct PRESTypePluginDefaultEndpointData epd;
    RTIBool result;
    struct PRESTypePluginDefaultParticipantData pd;
    struct RTIXCdrTypePluginProgramContext defaultProgramContext =
    RTIXCdrTypePluginProgramContext_INTIALIZER;
    struct PRESTypePlugin plugin;

    if (length == NULL) {
        return RTI_FALSE;
    }

    RTIOsapiMemory_zero(&epd, sizeof(struct PRESTypePluginDefaultEndpointData));
    epd.programContext = defaultProgramContext;
    epd._participantData = &pd;
    epd.typePlugin = &plugin;
    epd.programContext.endpointPluginData = &epd;
    plugin.typeCode = (struct RTICdrTypeCode *)
    com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode();
    pd.programs = com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_programs();
    if (pd.programs == NULL) {
        return RTI_FALSE;
    }

    encapsulationId = DDS_TypeCode_get_native_encapsulation(
        (DDS_TypeCode *) plugin.typeCode,
        representation);
    if (encapsulationId == RTI_CDR_ENCAPSULATION_ID_INVALID) {
        return RTI_FALSE;
    }

    epd._maxSizeSerializedSample =
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size(
        (PRESTypePluginEndpointData)&epd,
        RTI_TRUE,
        encapsulationId,
        0);

    if (buffer == NULL) {
        *length =
        PRESTypePlugin_interpretedGetSerializedSampleSize(
            (PRESTypePluginEndpointData)&epd,
            RTI_TRUE,
            encapsulationId,
            0,
            sample);

        if (*length == 0) {
            return RTI_FALSE;
        }

        return RTI_TRUE;
    }

    RTICdrStream_init(&cdrStream);
    RTICdrStream_set(&cdrStream, (char *)buffer, *length);

    result = PRESTypePlugin_interpretedSerialize(
        (PRESTypePluginEndpointData)&epd,
        sample,
        &cdrStream,
        RTI_TRUE,
        encapsulationId,
        RTI_TRUE,
        NULL);

    *length = (unsigned int) RTICdrStream_getCurrentPositionOffset(&cdrStream);
    return result;
}

RTIBool
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer(
    char *buffer,
    unsigned int *length,
    const com_saabgroup_enterprisebus_idldemo_MyStruct *sample)
{
    return com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer_ex(
        buffer,
        length,
        sample,
        DDS_AUTO_DATA_REPRESENTATION);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_deserialize_from_cdr_buffer(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    const char * buffer,
    unsigned int length)
{
    struct RTICdrStream cdrStream;
    struct PRESTypePluginDefaultEndpointData epd;
    struct RTIXCdrTypePluginProgramContext defaultProgramContext =
    RTIXCdrTypePluginProgramContext_INTIALIZER;
    struct PRESTypePluginDefaultParticipantData pd;
    struct PRESTypePlugin plugin;

    epd.programContext = defaultProgramContext;
    epd._participantData = &pd;
    epd.typePlugin = &plugin;
    epd.programContext.endpointPluginData = &epd;
    plugin.typeCode = (struct RTICdrTypeCode *)
    com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode();
    pd.programs = com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_programs();
    if (pd.programs == NULL) {
        return RTI_FALSE;
    }
    RTIXCdrSampleAssignabilityProperty_setFromGlobalComplianceMask(
        &epd._assignabilityProperty);

    RTICdrStream_init(&cdrStream);
    RTICdrStream_set(&cdrStream, (char *)buffer, length);

    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_optional_members(sample, RTI_TRUE);
    return PRESTypePlugin_interpretedDeserialize(
        (PRESTypePluginEndpointData)&epd, sample,
        &cdrStream, RTI_TRUE, RTI_TRUE,
        NULL);
}

#if !defined(NDDS_STANDALONE_TYPE)
DDS_ReturnCode_t
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_data_to_string(
    const com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    char *_str,
    DDS_UnsignedLong *str_size,
    const struct DDS_PrintFormatProperty *property)
{
    DDS_DynamicData *data = NULL;
    char *buffer = NULL;
    unsigned int length = 0;
    struct DDS_PrintFormat printFormat;
    DDS_ReturnCode_t retCode = DDS_RETCODE_ERROR;

    if (sample == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }

    if (str_size == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }

    if (property == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }
    if (!com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer(
        NULL,
        &length,
        sample)) {
        return DDS_RETCODE_ERROR;
    }

    RTIOsapiHeap_allocateBuffer(&buffer, length, RTI_OSAPI_ALIGNMENT_DEFAULT);
    if (buffer == NULL) {
        return DDS_RETCODE_ERROR;
    }

    if (!com_saabgroup_enterprisebus_idldemo_MyStructPlugin_serialize_to_cdr_buffer(
        buffer,
        &length,
        sample)) {
        RTIOsapiHeap_freeBuffer(buffer);
        return DDS_RETCODE_ERROR;
    }
    data = DDS_DynamicData_new(
        com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode(),
        &DDS_DYNAMIC_DATA_PROPERTY_DEFAULT);
    if (data == NULL) {
        RTIOsapiHeap_freeBuffer(buffer);
        return DDS_RETCODE_ERROR;
    }

    retCode = DDS_DynamicData_from_cdr_buffer(data, buffer, length);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    retCode = DDS_PrintFormatProperty_to_print_format(
        property,
        &printFormat);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    retCode = DDS_DynamicDataFormatter_to_string_w_format(
        data,
        _str,
        str_size,
        &printFormat);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    RTIOsapiHeap_freeBuffer(buffer);
    DDS_DynamicData_delete(data);
    return DDS_RETCODE_OK;
}
#endif

unsigned int
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;

    size = PRESTypePlugin_interpretedGetSerializedSampleMaxSize(
        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);

    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

/* --------------------------------------------------------------------------------------
Key Management functions:
* -------------------------------------------------------------------------------------- */

PRESTypePluginKeyKind
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_key_kind(void)
{
    return PRES_TYPEPLUGIN_NO_KEY;
}

RTIBool com_saabgroup_enterprisebus_idldemo_MyStructPlugin_deserialize_key(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_MyStruct **sample,
    RTIBool * drop_sample,
    struct RTICdrStream *cdrStream,
    RTIBool deserialize_encapsulation,
    RTIBool deserialize_key,
    void *endpoint_plugin_qos)
{
    RTIBool result;
    RTIOsapiUtility_unusedParameter(drop_sample);
    /*  Depending on the type and the flags used in rtiddsgen, coverity may detect
    that sample is always null. Since the case is very dependant on
    the IDL/XML and the configuration we keep the check for safety.
    */
    result= PRESTypePlugin_interpretedDeserializeKey(
        endpoint_data,
        /* coverity[check_after_deref] */
        (sample != NULL) ? *sample : NULL,
        cdrStream,
        deserialize_encapsulation,
        deserialize_key,
        endpoint_plugin_qos);
    return result;

}

unsigned int
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_key_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;
    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSize(
        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);
    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

unsigned int
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_key_max_size_for_keyhash(
    PRESTypePluginEndpointData endpoint_data,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;
    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSizeForKeyhash(
        endpoint_data,
        &overflow,
        encapsulation_id,
        current_alignment);
    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

struct RTIXCdrInterpreterPrograms * com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_programs(void)
{
    struct RTIXCdrInterpreterProgramsGenProperty programProperty =
    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;
    struct RTIXCdrInterpreterPrograms *retPrograms = NULL;

    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {
        return NULL;
    }

    programProperty.generateWithOnlyKeyFields = RTI_XCDR_FALSE;
    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;
    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;

    programProperty.resolveAlias = RTI_XCDR_TRUE;
    programProperty.inlineStruct = RTI_XCDR_TRUE;
    programProperty.optimizeEnum = RTI_XCDR_TRUE;
    programProperty.unboundedSize = RTIXCdrLong_MAX;

    retPrograms =
    DDS_TypeCodeFactory_assert_programs_in_global_list(
        DDS_TypeCodeFactory_get_instance(),
        com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode(),
        &programProperty,
        RTI_XCDR_SER_PROGRAM
        | RTI_XCDR_DESER_PROGRAM
        | RTI_XCDR_GET_MAX_SER_SIZE_PROGRAM
        | RTI_XCDR_GET_SER_SIZE_PROGRAM);

    return retPrograms;
}

/* ------------------------------------------------------------------------
* Plug-in Installation Methods
* ------------------------------------------------------------------------ */
struct PRESTypePlugin *com_saabgroup_enterprisebus_idldemo_MyStructPlugin_new(void)
{
    struct PRESTypePlugin *plugin = NULL;
    const struct PRESTypePluginVersion PLUGIN_VERSION =
    PRES_TYPE_PLUGIN_VERSION_2_0;

    RTIOsapiHeap_allocateStructure(
        &plugin, struct PRESTypePlugin);

    if (plugin == NULL) {
        return NULL;
    }

    plugin->version = PLUGIN_VERSION;

    /* set up parent's function pointers */
    plugin->onParticipantAttached =
    (PRESTypePluginOnParticipantAttachedCallback)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_attached;
    plugin->onParticipantDetached =
    (PRESTypePluginOnParticipantDetachedCallback)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_participant_detached;
    plugin->onEndpointAttached =
    (PRESTypePluginOnEndpointAttachedCallback)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_attached;
    plugin->onEndpointDetached =
    (PRESTypePluginOnEndpointDetachedCallback)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_on_endpoint_detached;

    plugin->copySampleFnc =
    (PRESTypePluginCopySampleFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_copy_sample;
    plugin->createSampleFnc =
    (PRESTypePluginCreateSampleFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_create_sample;
    plugin->destroySampleFnc =
    (PRESTypePluginDestroySampleFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_destroy_sample;
    plugin->finalizeOptionalMembersFnc =
    (PRESTypePluginFinalizeOptionalMembersFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_finalize_optional_members;

    plugin->serializeFnc =
    (PRESTypePluginSerializeFunction) PRESTypePlugin_interpretedSerialize;
    plugin->deserializeFnc =
    (PRESTypePluginDeserializeFunction) PRESTypePlugin_interpretedDeserializeWithAlloc;
    plugin->getSerializedSampleMaxSizeFnc =
    (PRESTypePluginGetSerializedSampleMaxSizeFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_serialized_sample_max_size;
    plugin->getSerializedSampleMinSizeFnc =
    (PRESTypePluginGetSerializedSampleMinSizeFunction)
    PRESTypePlugin_interpretedGetSerializedSampleMinSize;
    plugin->getDeserializedSampleMaxSizeFnc = NULL;
    plugin->getSampleFnc =
    (PRESTypePluginGetSampleFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_sample;
    plugin->returnSampleFnc =
    (PRESTypePluginReturnSampleFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_return_sample;
    plugin->getKeyKindFnc =
    (PRESTypePluginGetKeyKindFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_key_kind;

    /* These functions are only used for keyed types. As this is not a keyed
    type they are all set to NULL
    */
    plugin->serializeKeyFnc = NULL ;
    plugin->deserializeKeyFnc = NULL;
    plugin->getKeyFnc = NULL;
    plugin->returnKeyFnc = NULL;
    plugin->instanceToKeyFnc = NULL;
    plugin->keyToInstanceFnc = NULL;
    plugin->getSerializedKeyMaxSizeFnc = NULL;
    plugin->instanceToKeyHashFnc = NULL;
    plugin->serializedSampleToKeyHashFnc = NULL;
    plugin->serializedKeyToKeyHashFnc = NULL;
    #ifdef NDDS_STANDALONE_TYPE
    plugin->typeCode = NULL;
    #else
    plugin->typeCode =  (struct RTICdrTypeCode *)com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode();
    #endif
    plugin->languageKind = PRES_TYPEPLUGIN_DDS_TYPE;

    /* Serialized buffer */
    plugin->getBuffer =
    (PRESTypePluginGetBufferFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_get_buffer;
    plugin->returnBuffer =
    (PRESTypePluginReturnBufferFunction)
    com_saabgroup_enterprisebus_idldemo_MyStructPlugin_return_buffer;
    plugin->getBufferWithParams = NULL;
    plugin->returnBufferWithParams = NULL;
    plugin->getSerializedSampleSizeFnc =
    (PRESTypePluginGetSerializedSampleSizeFunction)
    PRESTypePlugin_interpretedGetSerializedSampleSize;

    plugin->getWriterLoanedSampleFnc = NULL;
    plugin->returnWriterLoanedSampleFnc = NULL;
    plugin->returnWriterLoanedSampleFromCookieFnc = NULL;
    plugin->validateWriterLoanedSampleFnc = NULL;
    plugin->setWriterLoanedSampleSerializedStateFnc = NULL;

    plugin->endpointTypeName = com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME;
    plugin->isMetpType = RTI_FALSE;
    plugin->isRecursiveType = RTI_FALSE;
    return plugin;
}

void
com_saabgroup_enterprisebus_idldemo_MyStructPlugin_delete(struct PRESTypePlugin *plugin)
{
    RTIOsapiHeap_freeStructure(plugin);
}

/* ----------------------------------------------------------------------------
Support functions:
* ---------------------------------------------------------------------------- */

void com_saabgroup_enterprisebus_idldemo_VariantsPluginSupport_print_data(
    const com_saabgroup_enterprisebus_idldemo_Variants *sample,
    const char *description,
    unsigned int indent_level)
{
    if (description != NULL) {
        RTICdrType_printIndent(indent_level);
        RTILogParamString_printPlain("%s:\n", description);
    }

    if (sample == NULL) {
        RTICdrType_printIndent(indent_level+1);
        RTILogParamString_printPlain("NULL\n");
        return;
    }

    RTICdrType_printEnum(
        (RTICdrEnum *)sample,
        "com_saabgroup_enterprisebus_idldemo_Variants",
        RTIOsapiUtility_uInt32Plus1(indent_level));
}

/* ----------------------------------------------------------------------------
(De)Serialize functions:
* ------------------------------------------------------------------------- */

unsigned int
com_saabgroup_enterprisebus_idldemo_VariantsPlugin_get_serialized_sample_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int initial_alignment = current_alignment;

    current_alignment += PRESTypePlugin_interpretedGetSerializedSampleMaxSize(
        endpoint_data,
        NULL,
        include_encapsulation,
        encapsulation_id, current_alignment);

    return current_alignment - initial_alignment;
}

/* --------------------------------------------------------------------------------------
Key Management functions:
* -------------------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------
* Plug-in Installation Methods
* ------------------------------------------------------------------------ */

/* ----------------------------------------------------------------------------
*  Type com_saabgroup_enterprisebus_idldemo_Demo
* -------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
Support functions:
* -------------------------------------------------------------------------- */

com_saabgroup_enterprisebus_idldemo_Demo*
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data_w_params(
    const struct DDS_TypeAllocationParams_t * alloc_params)
{
    com_saabgroup_enterprisebus_idldemo_Demo *sample = NULL;

    if (alloc_params == NULL) {
        return NULL;
    } else if(!alloc_params->allocate_memory) {
        RTICdrLog_exception(&RTI_CDR_LOG_TYPE_OBJECT_NOT_ASSIGNABLE_ss,
        "alloc_params->allocate_memory","false");
        return NULL;
    }

    RTIOsapiHeap_allocateStructure(&(sample),com_saabgroup_enterprisebus_idldemo_Demo);
    if (sample == NULL) {
        return NULL;
    }

    if (!com_saabgroup_enterprisebus_idldemo_Demo_initialize_w_params(sample,alloc_params)) {
        struct DDS_TypeDeallocationParams_t deallocParams =
        DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
        deallocParams.delete_pointers = alloc_params->allocate_pointers;
        deallocParams.delete_optional_members = alloc_params->allocate_pointers;
        /* Coverity reports a possible uninit_use_in_call that will happen if the
        allocation fails. But if the allocation fails then sample == null and
        the method will return before reach this point.*/
        /* Coverity reports a possible overwrite_var on the members of the sample.
        It is a false positive since all the pointers are freed before assigning
        null to them. */
        /* coverity[uninit_use_in_call : FALSE] */
        /* coverity[overwrite_var : FALSE] */
        com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params(sample, &deallocParams);
        /* Coverity reports a possible leaked_storage on the sample members when
        freeing sample. It is a false positive since all the members' memory
        is freed in the call "com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex" */
        /* coverity[leaked_storage : FALSE] */
        RTIOsapiHeap_freeStructure(sample);
        sample=NULL;
    }
    return sample;
}

com_saabgroup_enterprisebus_idldemo_Demo *
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data_ex(RTIBool allocate_pointers)
{
    com_saabgroup_enterprisebus_idldemo_Demo *sample = NULL;

    RTIOsapiHeap_allocateStructure(&(sample),com_saabgroup_enterprisebus_idldemo_Demo);

    if(sample == NULL) {
        return NULL;
    }

    /* coverity[example_checked : FALSE] */
    if (!com_saabgroup_enterprisebus_idldemo_Demo_initialize_ex(sample,allocate_pointers, RTI_TRUE)) {
        /* Coverity reports a possible uninit_use_in_call that will happen if the
        new fails. But if new fails then sample == null and the method will
        return before reach this point. */
        /* Coverity reports a possible overwrite_var on the members of the sample.
        It is a false positive since all the pointers are freed before assigning
        null to them. */
        /* coverity[uninit_use_in_call : FALSE] */
        /* coverity[overwrite_var : FALSE] */
        com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(sample, RTI_TRUE);
        /* Coverity reports a possible leaked_storage on the sample members when
        freeing sample. It is a false positive since all the members' memory
        is freed in the call "com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex" */
        /* coverity[leaked_storage : FALSE] */
        RTIOsapiHeap_freeStructure(sample);
        sample=NULL;
    }

    return sample;
}

void *
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_dataI(void)
{
    return com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data_ex(RTI_TRUE);
}

com_saabgroup_enterprisebus_idldemo_Demo *
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_data(void)
{
    return (com_saabgroup_enterprisebus_idldemo_Demo *) com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_dataI();
}

void
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data_w_params(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    const struct DDS_TypeDeallocationParams_t * dealloc_params) {
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params(sample,dealloc_params);

    RTIOsapiHeap_freeStructure(sample);
}

void
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data_ex(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,RTIBool deallocate_pointers) {
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(sample,deallocate_pointers);

    RTIOsapiHeap_freeStructure(sample);
}

void
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data(
    com_saabgroup_enterprisebus_idldemo_Demo *sample) {

    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data_ex(sample,RTI_TRUE);

}

void
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_dataI(
    void *sample)
{
    com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_data((com_saabgroup_enterprisebus_idldemo_Demo *) sample);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_copy_data(
    com_saabgroup_enterprisebus_idldemo_Demo *dst,
    const com_saabgroup_enterprisebus_idldemo_Demo *src)
{
    return com_saabgroup_enterprisebus_idldemo_Demo_copy(dst,(const com_saabgroup_enterprisebus_idldemo_Demo*) src);
}

void
com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_print_data(
    const com_saabgroup_enterprisebus_idldemo_Demo *sample,
    const char *desc,
    unsigned int indent_level)
{

    RTICdrType_printIndent(indent_level);

    if (desc != NULL) {
        RTILogParamString_printPlain("%s:\n", desc);
    } else {
        RTILogParamString_printPlain("\n");
    }

    if (sample == NULL) {
        RTILogParamString_printPlain("NULL\n");
        return;
    }

    RTICdrType_printLong(
        &sample->_d,
        "_d",
        RTIOsapiUtility_uInt32Plus1(indent_level));

    switch(sample->_d) {

        case 0:
        {
            com_saabgroup_enterprisebus_idldemo_MyStructPluginSupport_print_data(
                (const com_saabgroup_enterprisebus_idldemo_MyStruct*) &sample->_u.aStruct,
                "_u.aStruct",
                RTIOsapiUtility_uInt32Plus1(indent_level));

        } break ;
        case 1:
        {

            RTICdrType_printBoolean(
                &sample->_u.aBoolean,
                "_u.aBoolean",
                RTIOsapiUtility_uInt32Plus1(indent_level));

        } break ;
        case 2:
        {

            RTICdrType_printLong(
                &sample->_u.aLong,
                "_u.aLong",
                RTIOsapiUtility_uInt32Plus1(indent_level));

        } break ;
        default:
        {

            RTICdrType_printDouble(
                &sample->_u.aDouble,
                "_u.aDouble",
                RTIOsapiUtility_uInt32Plus1(indent_level));

        } ;

    }
}

/* ----------------------------------------------------------------------------
Callback functions:
* ---------------------------------------------------------------------------- */

PRESTypePluginParticipantData
com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_attached(
    void *registration_data,
    const struct PRESTypePluginParticipantInfo *participant_info,
    RTIBool top_level_registration,
    void *container_plugin_context,
    RTICdrTypeCode *type_code)
{
    struct RTIXCdrInterpreterPrograms *programs = NULL;
    struct RTIXCdrInterpreterProgramsGenProperty programProperty =
    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;
    struct PRESTypePluginDefaultParticipantData *pd = NULL;

    RTIOsapiUtility_unusedParameter(registration_data);
    RTIOsapiUtility_unusedParameter(participant_info);
    RTIOsapiUtility_unusedParameter(top_level_registration);
    RTIOsapiUtility_unusedParameter(container_plugin_context);
    RTIOsapiUtility_unusedParameter(type_code);

    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {
        return NULL;
    }

    pd = (struct PRESTypePluginDefaultParticipantData *)
    PRESTypePluginDefaultParticipantData_new(participant_info);

    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;
    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;

    programProperty.resolveAlias = RTI_XCDR_TRUE;
    programProperty.inlineStruct = RTI_XCDR_TRUE;
    programProperty.optimizeEnum = RTI_XCDR_TRUE;
    programProperty.unboundedSize = RTIXCdrLong_MAX;

    programs = DDS_TypeCodeFactory_assert_programs_in_global_list(
        DDS_TypeCodeFactory_get_instance(),
        com_saabgroup_enterprisebus_idldemo_Demo_get_typecode(),
        &programProperty,
        RTI_XCDR_PROGRAM_MASK_TYPEPLUGIN);
    if (programs == NULL) {
        PRESTypePluginDefaultParticipantData_delete(
            (PRESTypePluginParticipantData) pd);
        return NULL;
    }

    pd->programs = programs;
    return (PRESTypePluginParticipantData)pd;
}

void
com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_detached(
    PRESTypePluginParticipantData participant_data)
{
    if (participant_data != NULL) {
        struct PRESTypePluginDefaultParticipantData *pd =
        (struct PRESTypePluginDefaultParticipantData *)participant_data;

        if (pd->programs != NULL) {
            DDS_TypeCodeFactory_remove_programs_from_global_list(
                DDS_TypeCodeFactory_get_instance(),
                pd->programs);
            pd->programs = NULL;
        }
        PRESTypePluginDefaultParticipantData_delete(participant_data);
    }
}

PRESTypePluginEndpointData
com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_attached(
    PRESTypePluginParticipantData participant_data,
    const struct PRESTypePluginEndpointInfo *endpoint_info,
    RTIBool top_level_registration,
    void *containerPluginContext)
{
    PRESTypePluginEndpointData epd = NULL;
    unsigned int serializedSampleMaxSize = 0;

    RTIOsapiUtility_unusedParameter(top_level_registration);
    RTIOsapiUtility_unusedParameter(containerPluginContext);

    if (participant_data == NULL) {
        return NULL;
    }

    epd = PRESTypePluginDefaultEndpointData_new(
        participant_data,
        endpoint_info,
        com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_create_dataI,
        com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_destroy_dataI,
        NULL , NULL );

    if (epd == NULL) {
        return NULL;
    }

    if (endpoint_info->endpointKind == PRES_TYPEPLUGIN_ENDPOINT_WRITER) {
        serializedSampleMaxSize = com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size(
            epd,RTI_FALSE,RTI_CDR_ENCAPSULATION_ID_CDR_BE,0);
        PRESTypePluginDefaultEndpointData_setMaxSizeSerializedSample(epd, serializedSampleMaxSize);

        if (PRESTypePluginDefaultEndpointData_createWriterPool(
            epd,
            endpoint_info,
            (PRESTypePluginGetSerializedSampleMaxSizeFunction)
            com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size, epd,
            (PRESTypePluginGetSerializedSampleSizeFunction)
            PRESTypePlugin_interpretedGetSerializedSampleSize,
            epd) == RTI_FALSE) {
            PRESTypePluginDefaultEndpointData_delete(epd);
            return NULL;
        }
    }

    return epd;
}

void
com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_detached(
    PRESTypePluginEndpointData endpoint_data)
{
    PRESTypePluginDefaultEndpointData_delete(endpoint_data);
}

void
com_saabgroup_enterprisebus_idldemo_DemoPlugin_return_sample(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    void *handle)
{
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_optional_members(sample, RTI_TRUE);

    PRESTypePluginDefaultEndpointData_returnSample(
        endpoint_data, sample, handle);
}

void com_saabgroup_enterprisebus_idldemo_DemoPlugin_finalize_optional_members(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_Demo* sample,
    RTIBool deletePointers)
{
    RTIOsapiUtility_unusedParameter(endpoint_data);
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_optional_members(
        sample, deletePointers);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_DemoPlugin_copy_sample(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_Demo *dst,
    const com_saabgroup_enterprisebus_idldemo_Demo *src)
{
    RTIOsapiUtility_unusedParameter(endpoint_data);
    return com_saabgroup_enterprisebus_idldemo_DemoPluginSupport_copy_data(dst,src);
}

/* ----------------------------------------------------------------------------
(De)Serialize functions:
* ------------------------------------------------------------------------- */
unsigned int
com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment);

RTIBool
com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer_ex(
    char *buffer,
    unsigned int *length,
    const com_saabgroup_enterprisebus_idldemo_Demo *sample,
    DDS_DataRepresentationId_t representation)
{
    RTIEncapsulationId encapsulationId = RTI_CDR_ENCAPSULATION_ID_INVALID;
    struct RTICdrStream cdrStream;
    struct PRESTypePluginDefaultEndpointData epd;
    RTIBool result;
    struct PRESTypePluginDefaultParticipantData pd;
    struct RTIXCdrTypePluginProgramContext defaultProgramContext =
    RTIXCdrTypePluginProgramContext_INTIALIZER;
    struct PRESTypePlugin plugin;

    if (length == NULL) {
        return RTI_FALSE;
    }

    RTIOsapiMemory_zero(&epd, sizeof(struct PRESTypePluginDefaultEndpointData));
    epd.programContext = defaultProgramContext;
    epd._participantData = &pd;
    epd.typePlugin = &plugin;
    epd.programContext.endpointPluginData = &epd;
    plugin.typeCode = (struct RTICdrTypeCode *)
    com_saabgroup_enterprisebus_idldemo_Demo_get_typecode();
    pd.programs = com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_programs();
    if (pd.programs == NULL) {
        return RTI_FALSE;
    }

    encapsulationId = DDS_TypeCode_get_native_encapsulation(
        (DDS_TypeCode *) plugin.typeCode,
        representation);
    if (encapsulationId == RTI_CDR_ENCAPSULATION_ID_INVALID) {
        return RTI_FALSE;
    }

    epd._maxSizeSerializedSample =
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size(
        (PRESTypePluginEndpointData)&epd,
        RTI_TRUE,
        encapsulationId,
        0);

    if (buffer == NULL) {
        *length =
        PRESTypePlugin_interpretedGetSerializedSampleSize(
            (PRESTypePluginEndpointData)&epd,
            RTI_TRUE,
            encapsulationId,
            0,
            sample);

        if (*length == 0) {
            return RTI_FALSE;
        }

        return RTI_TRUE;
    }

    RTICdrStream_init(&cdrStream);
    RTICdrStream_set(&cdrStream, (char *)buffer, *length);

    result = PRESTypePlugin_interpretedSerialize(
        (PRESTypePluginEndpointData)&epd,
        sample,
        &cdrStream,
        RTI_TRUE,
        encapsulationId,
        RTI_TRUE,
        NULL);

    *length = (unsigned int) RTICdrStream_getCurrentPositionOffset(&cdrStream);
    return result;
}

RTIBool
com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer(
    char *buffer,
    unsigned int *length,
    const com_saabgroup_enterprisebus_idldemo_Demo *sample)
{
    return com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer_ex(
        buffer,
        length,
        sample,
        DDS_AUTO_DATA_REPRESENTATION);
}

RTIBool
com_saabgroup_enterprisebus_idldemo_DemoPlugin_deserialize_from_cdr_buffer(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    const char * buffer,
    unsigned int length)
{
    struct RTICdrStream cdrStream;
    struct PRESTypePluginDefaultEndpointData epd;
    struct RTIXCdrTypePluginProgramContext defaultProgramContext =
    RTIXCdrTypePluginProgramContext_INTIALIZER;
    struct PRESTypePluginDefaultParticipantData pd;
    struct PRESTypePlugin plugin;

    epd.programContext = defaultProgramContext;
    epd._participantData = &pd;
    epd.typePlugin = &plugin;
    epd.programContext.endpointPluginData = &epd;
    plugin.typeCode = (struct RTICdrTypeCode *)
    com_saabgroup_enterprisebus_idldemo_Demo_get_typecode();
    pd.programs = com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_programs();
    if (pd.programs == NULL) {
        return RTI_FALSE;
    }
    RTIXCdrSampleAssignabilityProperty_setFromGlobalComplianceMask(
        &epd._assignabilityProperty);

    RTICdrStream_init(&cdrStream);
    RTICdrStream_set(&cdrStream, (char *)buffer, length);

    com_saabgroup_enterprisebus_idldemo_Demo_finalize_optional_members(sample, RTI_TRUE);
    return PRESTypePlugin_interpretedDeserialize(
        (PRESTypePluginEndpointData)&epd, sample,
        &cdrStream, RTI_TRUE, RTI_TRUE,
        NULL);
}

#if !defined(NDDS_STANDALONE_TYPE)
DDS_ReturnCode_t
com_saabgroup_enterprisebus_idldemo_DemoPlugin_data_to_string(
    const com_saabgroup_enterprisebus_idldemo_Demo *sample,
    char *_str,
    DDS_UnsignedLong *str_size,
    const struct DDS_PrintFormatProperty *property)
{
    DDS_DynamicData *data = NULL;
    char *buffer = NULL;
    unsigned int length = 0;
    struct DDS_PrintFormat printFormat;
    DDS_ReturnCode_t retCode = DDS_RETCODE_ERROR;

    if (sample == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }

    if (str_size == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }

    if (property == NULL) {
        return DDS_RETCODE_BAD_PARAMETER;
    }
    if (!com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer(
        NULL,
        &length,
        sample)) {
        return DDS_RETCODE_ERROR;
    }

    RTIOsapiHeap_allocateBuffer(&buffer, length, RTI_OSAPI_ALIGNMENT_DEFAULT);
    if (buffer == NULL) {
        return DDS_RETCODE_ERROR;
    }

    if (!com_saabgroup_enterprisebus_idldemo_DemoPlugin_serialize_to_cdr_buffer(
        buffer,
        &length,
        sample)) {
        RTIOsapiHeap_freeBuffer(buffer);
        return DDS_RETCODE_ERROR;
    }
    data = DDS_DynamicData_new(
        com_saabgroup_enterprisebus_idldemo_Demo_get_typecode(),
        &DDS_DYNAMIC_DATA_PROPERTY_DEFAULT);
    if (data == NULL) {
        RTIOsapiHeap_freeBuffer(buffer);
        return DDS_RETCODE_ERROR;
    }

    retCode = DDS_DynamicData_from_cdr_buffer(data, buffer, length);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    retCode = DDS_PrintFormatProperty_to_print_format(
        property,
        &printFormat);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    retCode = DDS_DynamicDataFormatter_to_string_w_format(
        data,
        _str,
        str_size,
        &printFormat);
    if (retCode != DDS_RETCODE_OK) {
        RTIOsapiHeap_freeBuffer(buffer);
        DDS_DynamicData_delete(data);
        return retCode;
    }

    RTIOsapiHeap_freeBuffer(buffer);
    DDS_DynamicData_delete(data);
    return DDS_RETCODE_OK;
}
#endif

unsigned int
com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;

    size = PRESTypePlugin_interpretedGetSerializedSampleMaxSize(
        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);

    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

/* --------------------------------------------------------------------------------------
Key Management functions:
* -------------------------------------------------------------------------------------- */

PRESTypePluginKeyKind
com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_key_kind(void)
{
    return PRES_TYPEPLUGIN_NO_KEY;
}

RTIBool com_saabgroup_enterprisebus_idldemo_DemoPlugin_deserialize_key(
    PRESTypePluginEndpointData endpoint_data,
    com_saabgroup_enterprisebus_idldemo_Demo **sample,
    RTIBool * drop_sample,
    struct RTICdrStream *cdrStream,
    RTIBool deserialize_encapsulation,
    RTIBool deserialize_key,
    void *endpoint_plugin_qos)
{
    RTIBool result;
    RTIOsapiUtility_unusedParameter(drop_sample);
    /*  Depending on the type and the flags used in rtiddsgen, coverity may detect
    that sample is always null. Since the case is very dependant on
    the IDL/XML and the configuration we keep the check for safety.
    */
    result= PRESTypePlugin_interpretedDeserializeKey(
        endpoint_data,
        /* coverity[check_after_deref] */
        (sample != NULL) ? *sample : NULL,
        cdrStream,
        deserialize_encapsulation,
        deserialize_key,
        endpoint_plugin_qos);
    return result;

}

unsigned int
com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_key_max_size(
    PRESTypePluginEndpointData endpoint_data,
    RTIBool include_encapsulation,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;
    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSize(
        endpoint_data,&overflow,include_encapsulation,encapsulation_id,current_alignment);
    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

unsigned int
com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_key_max_size_for_keyhash(
    PRESTypePluginEndpointData endpoint_data,
    RTIEncapsulationId encapsulation_id,
    unsigned int current_alignment)
{
    unsigned int size;
    RTIBool overflow = RTI_FALSE;
    size = PRESTypePlugin_interpretedGetSerializedKeyMaxSizeForKeyhash(
        endpoint_data,
        &overflow,
        encapsulation_id,
        current_alignment);
    if (overflow) {
        size = RTI_CDR_MAX_SERIALIZED_SIZE;
    }

    return size;
}

struct RTIXCdrInterpreterPrograms * com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_programs(void)
{
    struct RTIXCdrInterpreterProgramsGenProperty programProperty =
    RTIXCdrInterpreterProgramsGenProperty_INITIALIZER;
    struct RTIXCdrInterpreterPrograms *retPrograms = NULL;

    if (!RTIXCdrXTypesComplianceMask_verifyGeneratedXTypesMask(0x0000018C)) {
        return NULL;
    }

    programProperty.generateWithOnlyKeyFields = RTI_XCDR_FALSE;
    programProperty.generateV1Encapsulation = RTI_XCDR_TRUE;
    programProperty.generateV2Encapsulation = RTI_XCDR_TRUE;

    programProperty.resolveAlias = RTI_XCDR_TRUE;
    programProperty.inlineStruct = RTI_XCDR_TRUE;
    programProperty.optimizeEnum = RTI_XCDR_TRUE;
    programProperty.unboundedSize = RTIXCdrLong_MAX;

    retPrograms =
    DDS_TypeCodeFactory_assert_programs_in_global_list(
        DDS_TypeCodeFactory_get_instance(),
        com_saabgroup_enterprisebus_idldemo_Demo_get_typecode(),
        &programProperty,
        RTI_XCDR_SER_PROGRAM
        | RTI_XCDR_DESER_PROGRAM
        | RTI_XCDR_GET_MAX_SER_SIZE_PROGRAM
        | RTI_XCDR_GET_SER_SIZE_PROGRAM);

    return retPrograms;
}

/* ------------------------------------------------------------------------
* Plug-in Installation Methods
* ------------------------------------------------------------------------ */
struct PRESTypePlugin *com_saabgroup_enterprisebus_idldemo_DemoPlugin_new(void)
{
    struct PRESTypePlugin *plugin = NULL;
    const struct PRESTypePluginVersion PLUGIN_VERSION =
    PRES_TYPE_PLUGIN_VERSION_2_0;

    RTIOsapiHeap_allocateStructure(
        &plugin, struct PRESTypePlugin);

    if (plugin == NULL) {
        return NULL;
    }

    plugin->version = PLUGIN_VERSION;

    /* set up parent's function pointers */
    plugin->onParticipantAttached =
    (PRESTypePluginOnParticipantAttachedCallback)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_attached;
    plugin->onParticipantDetached =
    (PRESTypePluginOnParticipantDetachedCallback)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_participant_detached;
    plugin->onEndpointAttached =
    (PRESTypePluginOnEndpointAttachedCallback)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_attached;
    plugin->onEndpointDetached =
    (PRESTypePluginOnEndpointDetachedCallback)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_on_endpoint_detached;

    plugin->copySampleFnc =
    (PRESTypePluginCopySampleFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_copy_sample;
    plugin->createSampleFnc =
    (PRESTypePluginCreateSampleFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_create_sample;
    plugin->destroySampleFnc =
    (PRESTypePluginDestroySampleFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_destroy_sample;
    plugin->finalizeOptionalMembersFnc =
    (PRESTypePluginFinalizeOptionalMembersFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_finalize_optional_members;

    plugin->serializeFnc =
    (PRESTypePluginSerializeFunction) PRESTypePlugin_interpretedSerialize;
    plugin->deserializeFnc =
    (PRESTypePluginDeserializeFunction) PRESTypePlugin_interpretedDeserializeWithAlloc;
    plugin->getSerializedSampleMaxSizeFnc =
    (PRESTypePluginGetSerializedSampleMaxSizeFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_serialized_sample_max_size;
    plugin->getSerializedSampleMinSizeFnc =
    (PRESTypePluginGetSerializedSampleMinSizeFunction)
    PRESTypePlugin_interpretedGetSerializedSampleMinSize;
    plugin->getDeserializedSampleMaxSizeFnc = NULL;
    plugin->getSampleFnc =
    (PRESTypePluginGetSampleFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_sample;
    plugin->returnSampleFnc =
    (PRESTypePluginReturnSampleFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_return_sample;
    plugin->getKeyKindFnc =
    (PRESTypePluginGetKeyKindFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_key_kind;

    /* These functions are only used for keyed types. As this is not a keyed
    type they are all set to NULL
    */
    plugin->serializeKeyFnc = NULL ;
    plugin->deserializeKeyFnc = NULL;
    plugin->getKeyFnc = NULL;
    plugin->returnKeyFnc = NULL;
    plugin->instanceToKeyFnc = NULL;
    plugin->keyToInstanceFnc = NULL;
    plugin->getSerializedKeyMaxSizeFnc = NULL;
    plugin->instanceToKeyHashFnc = NULL;
    plugin->serializedSampleToKeyHashFnc = NULL;
    plugin->serializedKeyToKeyHashFnc = NULL;
    #ifdef NDDS_STANDALONE_TYPE
    plugin->typeCode = NULL;
    #else
    plugin->typeCode =  (struct RTICdrTypeCode *)com_saabgroup_enterprisebus_idldemo_Demo_get_typecode();
    #endif
    plugin->languageKind = PRES_TYPEPLUGIN_DDS_TYPE;

    /* Serialized buffer */
    plugin->getBuffer =
    (PRESTypePluginGetBufferFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_get_buffer;
    plugin->returnBuffer =
    (PRESTypePluginReturnBufferFunction)
    com_saabgroup_enterprisebus_idldemo_DemoPlugin_return_buffer;
    plugin->getBufferWithParams = NULL;
    plugin->returnBufferWithParams = NULL;
    plugin->getSerializedSampleSizeFnc =
    (PRESTypePluginGetSerializedSampleSizeFunction)
    PRESTypePlugin_interpretedGetSerializedSampleSize;

    plugin->getWriterLoanedSampleFnc = NULL;
    plugin->returnWriterLoanedSampleFnc = NULL;
    plugin->returnWriterLoanedSampleFromCookieFnc = NULL;
    plugin->validateWriterLoanedSampleFnc = NULL;
    plugin->setWriterLoanedSampleSerializedStateFnc = NULL;

    plugin->endpointTypeName = com_saabgroup_enterprisebus_idldemo_DemoTYPENAME;
    plugin->isMetpType = RTI_FALSE;
    plugin->isRecursiveType = RTI_FALSE;
    return plugin;
}

void
com_saabgroup_enterprisebus_idldemo_DemoPlugin_delete(struct PRESTypePlugin *plugin)
{
    RTIOsapiHeap_freeStructure(plugin);
}
#undef RTI_CDR_CURRENT_SUBMODULE
