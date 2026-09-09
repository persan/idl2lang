

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from sequences.idl 
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef NDDS_STANDALONE_TYPE
#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif

#ifndef dds_c_log_infrastructure_h
#include "dds_c/dds_c_infrastructure_impl.h"       
#endif 

#ifndef cdr_type_h
#include "cdr/cdr_type.h"
#endif    

#include "osapi/osapi_atomic.h"
#else
#include "ndds_standalone_type.h"
#endif

#include "sequences.h"

#ifndef NDDS_STANDALONE_TYPE
#include "sequencesPlugin.h"
#endif

/* ========================================================================= */
const char *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTYPENAME = "com::rti::tests::DdsTopics::EngagementControl::ZonedThreatList::Key";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[1]=
    {

        {
            (char *)"numberOfThreats",/* Member name */
            {
                0,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"com::rti::tests::DdsTopics::EngagementControl::ZonedThreatList::Key", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            1, /* Number of members */
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc;
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;

    /* Initialize the values for member annotations. */
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._defaultValue._u.long_value = 0;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc_members[0]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc._data._sampleAccessInfo =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_sample_access_info();
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc._data._typePlugin =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_tc;
}

RTIXCdrSampleAccessInfo *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_memberAccessInfos[1] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo;
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key, numberOfThreats);

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo.memberAccessInfos =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_type_plugin_info()
{
    static RTIXCdrTypePlugin com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_typePlugin =
    {
        NULL, /* serialize */
        NULL, /* serialize_key */
        NULL, /* deserialize_sample */
        NULL, /* deserialize_key_sample */
        NULL, /* skip */
        NULL, /* get_serialized_sample_size */
        NULL, /* get_serialized_sample_max_size_ex */
        NULL, /* get_serialized_key_max_size_ex */
        NULL, /* get_serialized_sample_min_size */
        NULL, /* serialized_sample_to_key */
        (RTIXCdrTypePluginInitializeSampleFunction)
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_return,
        NULL,
        NULL
    };

    return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_g_typePlugin;
}
#endif

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* sample)
{
    return com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_w_params(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->numberOfThreats = 0;

    return RTI_TRUE;
}
RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_ex(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_return(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* sample)
{
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* sample)
{  
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_ex(
        sample, 
        RTI_TRUE);
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_ex(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_params(
        sample,
        &deallocParams);
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_params(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_optional_members(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* sample, RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParamsTmp =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
    struct DDS_TypeDeallocationParams_t * deallocParams =
    &deallocParamsTmp;

    if (sample==NULL) {
        return;
    } 
    RTIOsapiUtility_unusedParameter(deallocParams);

    deallocParamsTmp.delete_pointers = (DDS_Boolean)deletePointers;
    deallocParamsTmp.delete_optional_members = DDS_BOOLEAN_TRUE;

}

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_copy(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* dst,
    const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->numberOfThreats, 
        &src->numberOfThreats)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key' sequence class.
*/
#define T com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key
#define TSeq com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq

#define T_initialize_w_params com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_initialize_w_params

#define T_finalize_w_params   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_finalize_w_params
#define T_copy       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_copy

#ifndef NDDS_STANDALONE_TYPE
#include "dds_c/generic/dds_c_sequence_TSeq.gen"
#else
#include "dds_c_sequence_TSeq.gen"
#endif

#undef T_copy
#undef T_finalize_w_params

#undef T_initialize_w_params

#undef TSeq
#undef T

/* ========================================================================= */
const char *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTYPENAME = "com::rti::tests::DdsTopics::EngagementControl::ZonedThreatList::ZonedThreatList";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_zonedThreats_sequence = DDS_INITIALIZE_SEQUENCE_TYPECODE(((com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZONED_THREAT_LIST_MAXSIZE)),NULL);

    static DDS_TypeCode_Member com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[2]=
    {

        {
            (char *)"numberOfThreats",/* Member name */
            {
                0,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"zonedThreats",/* Member name */
            {
                1,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"com::rti::tests::DdsTopics::EngagementControl::ZonedThreatList::ZonedThreatList", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            2, /* Number of members */
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc;
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_zonedThreats_sequence._data._typeCode = (RTICdrTypeCode *)com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key_get_typecode();
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_zonedThreats_sequence._data._sampleAccessInfo = &DDS_g_sai_seq;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)& com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_zonedThreats_sequence;

    /* Initialize the values for member annotations. */
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._defaultValue._u.long_value = 0;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc_members[0]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc._data._sampleAccessInfo =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_sample_access_info();
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc._data._typePlugin =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_tc;
}

RTIXCdrSampleAccessInfo *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_memberAccessInfos[2] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo;
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList, numberOfThreats);

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList, zonedThreats);

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo.memberAccessInfos =
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_get_type_plugin_info()
{
    static RTIXCdrTypePlugin com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_typePlugin =
    {
        NULL, /* serialize */
        NULL, /* serialize_key */
        NULL, /* deserialize_sample */
        NULL, /* deserialize_key_sample */
        NULL, /* skip */
        NULL, /* get_serialized_sample_size */
        NULL, /* get_serialized_sample_max_size_ex */
        NULL, /* get_serialized_key_max_size_ex */
        NULL, /* get_serialized_sample_min_size */
        NULL, /* serialized_sample_to_key */
        (RTIXCdrTypePluginInitializeSampleFunction)
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_return,
        NULL,
        NULL
    };

    return &com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_g_typePlugin;
}
#endif

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* sample)
{
    return com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_w_params(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{
    void* buffer = NULL;
    RTIOsapiUtility_unusedParameter(buffer);

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->numberOfThreats = 0;

    if (allocParams->allocate_memory) {
        if(!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_initialize(&sample->zonedThreats)){
            return RTI_FALSE;
        }
        if(!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_set_element_allocation_params(
            &sample->zonedThreats,
            allocParams)){
            return RTI_FALSE;
        }
        if(!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_set_absolute_maximum(
            &sample->zonedThreats,
            ((com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZONED_THREAT_LIST_MAXSIZE)))){
            return RTI_FALSE;
        }
        if (!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_set_maximum(
            &sample->zonedThreats
            ,
            ((com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZONED_THREAT_LIST_MAXSIZE)))) {
            return RTI_FALSE;
        }
    } else {
        if(!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_set_length(&sample->zonedThreats, 0)){
            return RTI_FALSE;
        }
    }
    return RTI_TRUE;
}
RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_ex(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_return(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* sample)
{
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* sample)
{  
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_ex(
        sample, 
        RTI_TRUE);
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_ex(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_params(
        sample,
        &deallocParams);
}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_params(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

    RTIOsapiUtility_unusedReturnValue(com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_set_element_deallocation_params(
        &sample->zonedThreats,deallocParams),
        DDS_Boolean);
    RTIOsapiUtility_unusedReturnValue(
        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_finalize(
            &sample->zonedThreats),
            DDS_Boolean);

}

void com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_optional_members(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* sample, RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParamsTmp =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
    struct DDS_TypeDeallocationParams_t * deallocParams =
    &deallocParamsTmp;

    if (sample==NULL) {
        return;
    } 
    RTIOsapiUtility_unusedParameter(deallocParams);

    deallocParamsTmp.delete_pointers = (DDS_Boolean)deletePointers;
    deallocParamsTmp.delete_optional_members = DDS_BOOLEAN_TRUE;

}

RTIBool com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_copy(
    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* dst,
    const com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->numberOfThreats, 
        &src->numberOfThreats)) { 
        return RTI_FALSE;
    }
    if (!com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq_copy(
        &dst->zonedThreats,
        &src->zonedThreats)) {
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList' sequence class.
*/
#define T com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList
#define TSeq com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListSeq

#define T_initialize_w_params com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_initialize_w_params

#define T_finalize_w_params   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_finalize_w_params
#define T_copy       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList_copy

#ifndef NDDS_STANDALONE_TYPE
#include "dds_c/generic/dds_c_sequence_TSeq.gen"
#else
#include "dds_c_sequence_TSeq.gen"
#endif

#undef T_copy
#undef T_finalize_w_params

#undef T_initialize_w_params

#undef TSeq
#undef T

