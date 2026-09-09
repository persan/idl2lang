

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from base.idl 
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

#include "base.h"

#ifndef NDDS_STANDALONE_TYPE
#include "basePlugin.h"
#endif

/* ========================================================================= */
const char *vtypes_test_base_position_tTYPENAME = "vtypes_test::base::position_t";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * vtypes_test_base_position_t_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member vtypes_test_base_position_t_g_tc_members[3]=
    {

        {
            (char *)"latitude",/* Member name */
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
            (char *)"longitude",/* Member name */
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
        }, 
        {
            (char *)"altitude",/* Member name */
            {
                2,/* Representation ID */
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

    static DDS_TypeCode vtypes_test_base_position_t_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"vtypes_test::base::position_t", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            3, /* Number of members */
            vtypes_test_base_position_t_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for vtypes_test_base_position_t*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &vtypes_test_base_position_t_g_tc;
    }

    vtypes_test_base_position_t_g_tc._data._annotations._allowedDataRepresentationMask = 5;
    vtypes_test_base_position_t_g_tc._data._annotations._isNested = RTI_XCDR_TRUE;

    vtypes_test_base_position_t_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;
    vtypes_test_base_position_t_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;
    vtypes_test_base_position_t_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;

    /* Initialize the values for member annotations. */
    vtypes_test_base_position_t_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[0]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_position_t_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[0]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_position_t_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[0]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[1]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_position_t_g_tc_members[2]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;

    vtypes_test_base_position_t_g_tc._data._sampleAccessInfo =
    vtypes_test_base_position_t_get_sample_access_info();
    vtypes_test_base_position_t_g_tc._data._typePlugin =
    vtypes_test_base_position_t_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &vtypes_test_base_position_t_g_tc;
}

RTIXCdrSampleAccessInfo *vtypes_test_base_position_t_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo vtypes_test_base_position_t_g_memberAccessInfos[3] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo vtypes_test_base_position_t_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_position_t_g_sampleAccessInfo;
    }

    vtypes_test_base_position_t_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_position_t, latitude);

    vtypes_test_base_position_t_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_position_t, longitude);

    vtypes_test_base_position_t_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_position_t, altitude);

    vtypes_test_base_position_t_g_sampleAccessInfo.memberAccessInfos =
    vtypes_test_base_position_t_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(vtypes_test_base_position_t);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            vtypes_test_base_position_t_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            vtypes_test_base_position_t_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    vtypes_test_base_position_t_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_position_t_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *vtypes_test_base_position_t_get_type_plugin_info()
{
    static RTIXCdrTypePlugin vtypes_test_base_position_t_g_typePlugin =
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
        vtypes_test_base_position_t_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        vtypes_test_base_position_t_finalize_w_return,
        NULL,
        NULL
    };

    return &vtypes_test_base_position_t_g_typePlugin;
}
#endif

RTIBool vtypes_test_base_position_t_initialize(
    vtypes_test_base_position_t* sample)
{
    return vtypes_test_base_position_t_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool vtypes_test_base_position_t_initialize_w_params(
    vtypes_test_base_position_t *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->latitude = 0.0;

    sample->longitude = 0.0;

    sample->altitude = 0.0;

    return RTI_TRUE;
}
RTIBool vtypes_test_base_position_t_initialize_ex(
    vtypes_test_base_position_t *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return vtypes_test_base_position_t_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool vtypes_test_base_position_t_finalize_w_return(
    vtypes_test_base_position_t* sample)
{
    vtypes_test_base_position_t_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void vtypes_test_base_position_t_finalize(
    vtypes_test_base_position_t* sample)
{  
    vtypes_test_base_position_t_finalize_ex(
        sample, 
        RTI_TRUE);
}

void vtypes_test_base_position_t_finalize_ex(
    vtypes_test_base_position_t *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    vtypes_test_base_position_t_finalize_w_params(
        sample,
        &deallocParams);
}

void vtypes_test_base_position_t_finalize_w_params(
    vtypes_test_base_position_t *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void vtypes_test_base_position_t_finalize_optional_members(
    vtypes_test_base_position_t* sample, RTIBool deletePointers)
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

RTIBool vtypes_test_base_position_t_copy(
    vtypes_test_base_position_t* dst,
    const vtypes_test_base_position_t* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyDouble (
        &dst->latitude, 
        &src->latitude)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyDouble (
        &dst->longitude, 
        &src->longitude)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyDouble (
        &dst->altitude, 
        &src->altitude)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'vtypes_test_base_position_t' sequence class.
*/
#define T vtypes_test_base_position_t
#define TSeq vtypes_test_base_position_tSeq

#define T_initialize_w_params vtypes_test_base_position_t_initialize_w_params

#define T_finalize_w_params   vtypes_test_base_position_t_finalize_w_params
#define T_copy       vtypes_test_base_position_t_copy

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
const char *vtypes_test_base_speed_tTYPENAME = "vtypes_test::base::speed_t";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * vtypes_test_base_speed_t_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member vtypes_test_base_speed_t_g_tc_members[3]=
    {

        {
            (char *)"x",/* Member name */
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
            (char *)"y",/* Member name */
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
        }, 
        {
            (char *)"z",/* Member name */
            {
                2,/* Representation ID */
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

    static DDS_TypeCode vtypes_test_base_speed_t_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"vtypes_test::base::speed_t", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            3, /* Number of members */
            vtypes_test_base_speed_t_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for vtypes_test_base_speed_t*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &vtypes_test_base_speed_t_g_tc;
    }

    vtypes_test_base_speed_t_g_tc._data._annotations._allowedDataRepresentationMask = 5;
    vtypes_test_base_speed_t_g_tc._data._annotations._isNested = RTI_XCDR_TRUE;

    vtypes_test_base_speed_t_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;
    vtypes_test_base_speed_t_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;
    vtypes_test_base_speed_t_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;

    /* Initialize the values for member annotations. */
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[0]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[1]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._defaultValue._u.double_value = 0.0;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    vtypes_test_base_speed_t_g_tc_members[2]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;

    vtypes_test_base_speed_t_g_tc._data._sampleAccessInfo =
    vtypes_test_base_speed_t_get_sample_access_info();
    vtypes_test_base_speed_t_g_tc._data._typePlugin =
    vtypes_test_base_speed_t_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &vtypes_test_base_speed_t_g_tc;
}

RTIXCdrSampleAccessInfo *vtypes_test_base_speed_t_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo vtypes_test_base_speed_t_g_memberAccessInfos[3] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo vtypes_test_base_speed_t_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_speed_t_g_sampleAccessInfo;
    }

    vtypes_test_base_speed_t_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_speed_t, x);

    vtypes_test_base_speed_t_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_speed_t, y);

    vtypes_test_base_speed_t_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_speed_t, z);

    vtypes_test_base_speed_t_g_sampleAccessInfo.memberAccessInfos =
    vtypes_test_base_speed_t_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(vtypes_test_base_speed_t);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            vtypes_test_base_speed_t_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            vtypes_test_base_speed_t_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    vtypes_test_base_speed_t_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_speed_t_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *vtypes_test_base_speed_t_get_type_plugin_info()
{
    static RTIXCdrTypePlugin vtypes_test_base_speed_t_g_typePlugin =
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
        vtypes_test_base_speed_t_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        vtypes_test_base_speed_t_finalize_w_return,
        NULL,
        NULL
    };

    return &vtypes_test_base_speed_t_g_typePlugin;
}
#endif

RTIBool vtypes_test_base_speed_t_initialize(
    vtypes_test_base_speed_t* sample)
{
    return vtypes_test_base_speed_t_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool vtypes_test_base_speed_t_initialize_w_params(
    vtypes_test_base_speed_t *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->x = 0.0;

    sample->y = 0.0;

    sample->z = 0.0;

    return RTI_TRUE;
}
RTIBool vtypes_test_base_speed_t_initialize_ex(
    vtypes_test_base_speed_t *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return vtypes_test_base_speed_t_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool vtypes_test_base_speed_t_finalize_w_return(
    vtypes_test_base_speed_t* sample)
{
    vtypes_test_base_speed_t_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void vtypes_test_base_speed_t_finalize(
    vtypes_test_base_speed_t* sample)
{  
    vtypes_test_base_speed_t_finalize_ex(
        sample, 
        RTI_TRUE);
}

void vtypes_test_base_speed_t_finalize_ex(
    vtypes_test_base_speed_t *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    vtypes_test_base_speed_t_finalize_w_params(
        sample,
        &deallocParams);
}

void vtypes_test_base_speed_t_finalize_w_params(
    vtypes_test_base_speed_t *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void vtypes_test_base_speed_t_finalize_optional_members(
    vtypes_test_base_speed_t* sample, RTIBool deletePointers)
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

RTIBool vtypes_test_base_speed_t_copy(
    vtypes_test_base_speed_t* dst,
    const vtypes_test_base_speed_t* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyDouble (
        &dst->x, 
        &src->x)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyDouble (
        &dst->y, 
        &src->y)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyDouble (
        &dst->z, 
        &src->z)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'vtypes_test_base_speed_t' sequence class.
*/
#define T vtypes_test_base_speed_t
#define TSeq vtypes_test_base_speed_tSeq

#define T_initialize_w_params vtypes_test_base_speed_t_initialize_w_params

#define T_finalize_w_params   vtypes_test_base_speed_t_finalize_w_params
#define T_copy       vtypes_test_base_speed_t_copy

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
const char *vtypes_test_base_basetrack_tTYPENAME = "vtypes_test::base::basetrack_t";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * vtypes_test_base_basetrack_t_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode vtypes_test_base_basetrack_t_g_tc_trackno_string = DDS_INITIALIZE_STRING_TYPECODE((10L));
    static DDS_TypeCode vtypes_test_base_basetrack_t_g_tc_callsign_string = DDS_INITIALIZE_STRING_TYPECODE((32L));

    static DDS_TypeCode_Member vtypes_test_base_basetrack_t_g_tc_members[4]=
    {

        {
            (char *)"trackno",/* Member name */
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
            RTI_CDR_KEY_MEMBER , /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"position",/* Member name */
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
        }, 
        {
            (char *)"speed",/* Member name */
            {
                2,/* Representation ID */
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
            (char *)"callsign",/* Member name */
            {
                3,/* Representation ID */
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

    static DDS_TypeCode vtypes_test_base_basetrack_t_g_tc =
    {{
            DDS_TK_VALUE, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"vtypes_test::base::basetrack_t", /* Name */
            NULL,     /* Base class type code is assigned later */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            4, /* Number of members */
            vtypes_test_base_basetrack_t_g_tc_members, /* Members */
            DDS_VM_NONE, /* Type Modifier */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for vtypes_test_base_basetrack_t*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &vtypes_test_base_basetrack_t_g_tc;
    }

    vtypes_test_base_basetrack_t_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    vtypes_test_base_basetrack_t_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&vtypes_test_base_basetrack_t_g_tc_trackno_string;
    vtypes_test_base_basetrack_t_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)vtypes_test_base_position_t_get_typecode();
    vtypes_test_base_basetrack_t_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)vtypes_test_base_speed_t_get_typecode();
    vtypes_test_base_basetrack_t_g_tc_members[3]._representation._typeCode =  (RTICdrTypeCode *)&vtypes_test_base_basetrack_t_g_tc_callsign_string;

    /* Initialize the values for member annotations. */
    vtypes_test_base_basetrack_t_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_STRING;
    vtypes_test_base_basetrack_t_g_tc_members[0]._annotations._defaultValue._u.string_value = (DDS_Char *) "";
    vtypes_test_base_basetrack_t_g_tc_members[3]._annotations._defaultValue._d = RTI_XCDR_TK_STRING;
    vtypes_test_base_basetrack_t_g_tc_members[3]._annotations._defaultValue._u.string_value = (DDS_Char *) "";

    vtypes_test_base_basetrack_t_g_tc._data._typeCode = (RTICdrTypeCode *) &DDS_g_tc_null;  /* Base class */

    vtypes_test_base_basetrack_t_g_tc._data._sampleAccessInfo =
    vtypes_test_base_basetrack_t_get_sample_access_info();
    vtypes_test_base_basetrack_t_g_tc._data._typePlugin =
    vtypes_test_base_basetrack_t_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &vtypes_test_base_basetrack_t_g_tc;
}

RTIXCdrSampleAccessInfo *vtypes_test_base_basetrack_t_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo vtypes_test_base_basetrack_t_g_memberAccessInfos[4] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo vtypes_test_base_basetrack_t_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_basetrack_t_g_sampleAccessInfo;
    }

    vtypes_test_base_basetrack_t_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_basetrack_t, trackno);

    vtypes_test_base_basetrack_t_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_basetrack_t, position);

    vtypes_test_base_basetrack_t_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_basetrack_t, speed);

    vtypes_test_base_basetrack_t_g_memberAccessInfos[3].bindingMemberValueOffset[0] =
    offsetof(struct vtypes_test_base_basetrack_t, callsign);

    vtypes_test_base_basetrack_t_g_sampleAccessInfo.memberAccessInfos =
    vtypes_test_base_basetrack_t_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(vtypes_test_base_basetrack_t);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            vtypes_test_base_basetrack_t_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            vtypes_test_base_basetrack_t_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    vtypes_test_base_basetrack_t_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &vtypes_test_base_basetrack_t_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *vtypes_test_base_basetrack_t_get_type_plugin_info()
{
    static RTIXCdrTypePlugin vtypes_test_base_basetrack_t_g_typePlugin =
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
        vtypes_test_base_basetrack_t_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        vtypes_test_base_basetrack_t_finalize_w_return,
        NULL,
        NULL
    };

    return &vtypes_test_base_basetrack_t_g_typePlugin;
}
#endif

RTIBool vtypes_test_base_basetrack_t_initialize(
    vtypes_test_base_basetrack_t* sample)
{
    return vtypes_test_base_basetrack_t_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool vtypes_test_base_basetrack_t_initialize_w_params(
    vtypes_test_base_basetrack_t *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    if (allocParams->allocate_memory) {
        sample->trackno = DDS_String_alloc((10L));
        if (sample->trackno != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->trackno,
                    "",
                    (10L),
                    RTI_FALSE),
                    RTIBool);
        }
        if (sample->trackno == NULL) {
            return RTI_FALSE;
        }
    } else {
        if (sample->trackno != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->trackno,
                    "",
                    (10L),
                    RTI_FALSE),
                    RTIBool);
            if (sample->trackno == NULL) {
                return RTI_FALSE;
            }
        }
    }

    if (!vtypes_test_base_position_t_initialize_w_params(
        &sample->position,
        allocParams)) {
        return RTI_FALSE;
    }
    if (!vtypes_test_base_speed_t_initialize_w_params(
        &sample->speed,
        allocParams)) {
        return RTI_FALSE;
    }

    if (allocParams->allocate_memory) {
        sample->callsign = DDS_String_alloc((32L));
        if (sample->callsign != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->callsign,
                    "",
                    (32L),
                    RTI_FALSE),
                    RTIBool);
        }
        if (sample->callsign == NULL) {
            return RTI_FALSE;
        }
    } else {
        if (sample->callsign != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->callsign,
                    "",
                    (32L),
                    RTI_FALSE),
                    RTIBool);
            if (sample->callsign == NULL) {
                return RTI_FALSE;
            }
        }
    }

    return RTI_TRUE;
}
RTIBool vtypes_test_base_basetrack_t_initialize_ex(
    vtypes_test_base_basetrack_t *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return vtypes_test_base_basetrack_t_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool vtypes_test_base_basetrack_t_finalize_w_return(
    vtypes_test_base_basetrack_t* sample)
{
    vtypes_test_base_basetrack_t_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void vtypes_test_base_basetrack_t_finalize(
    vtypes_test_base_basetrack_t* sample)
{  
    vtypes_test_base_basetrack_t_finalize_ex(
        sample, 
        RTI_TRUE);
}

void vtypes_test_base_basetrack_t_finalize_ex(
    vtypes_test_base_basetrack_t *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    vtypes_test_base_basetrack_t_finalize_w_params(
        sample,
        &deallocParams);
}

void vtypes_test_base_basetrack_t_finalize_w_params(
    vtypes_test_base_basetrack_t *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

    if (sample->trackno != NULL) {
        DDS_String_free(sample->trackno);
        sample->trackno=NULL;

    }
    vtypes_test_base_position_t_finalize_w_params(
        &sample->position,
        deallocParams);

    vtypes_test_base_speed_t_finalize_w_params(
        &sample->speed,
        deallocParams);

    if (sample->callsign != NULL) {
        DDS_String_free(sample->callsign);
        sample->callsign=NULL;

    }
}

void vtypes_test_base_basetrack_t_finalize_optional_members(
    vtypes_test_base_basetrack_t* sample, RTIBool deletePointers)
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

RTIBool vtypes_test_base_basetrack_t_copy(
    vtypes_test_base_basetrack_t* dst,
    const vtypes_test_base_basetrack_t* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyStringEx (
        &dst->trackno
        ,
        src->trackno, 
        (10L) + 1,
        RTI_FALSE)){
        return RTI_FALSE;
    }
    if (!vtypes_test_base_position_t_copy(
        &dst->position,
        (const vtypes_test_base_position_t*)&src->position)) {
        return RTI_FALSE;
    } 
    if (!vtypes_test_base_speed_t_copy(
        &dst->speed,
        (const vtypes_test_base_speed_t*)&src->speed)) {
        return RTI_FALSE;
    } 
    if (!RTICdrType_copyStringEx (
        &dst->callsign
        ,
        src->callsign, 
        (32L) + 1,
        RTI_FALSE)){
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'vtypes_test_base_basetrack_t' sequence class.
*/
#define T vtypes_test_base_basetrack_t
#define TSeq vtypes_test_base_basetrack_tSeq

#define T_initialize_w_params vtypes_test_base_basetrack_t_initialize_w_params

#define T_finalize_w_params   vtypes_test_base_basetrack_t_finalize_w_params
#define T_copy       vtypes_test_base_basetrack_t_copy

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

