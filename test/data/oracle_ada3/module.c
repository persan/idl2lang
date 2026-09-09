

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from module.idl 
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

#include "module.h"

#ifndef NDDS_STANDALONE_TYPE
#include "modulePlugin.h"
#endif

/* ========================================================================= */
const char *a_b_c_fooTYPENAME = "a::b::c::foo";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * a_b_c_foo_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member a_b_c_foo_g_tc_members[1]=
    {

        {
            (char *)"data",/* Member name */
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

    static DDS_TypeCode a_b_c_foo_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"a::b::c::foo", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            1, /* Number of members */
            a_b_c_foo_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for a_b_c_foo*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &a_b_c_foo_g_tc;
    }

    a_b_c_foo_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    a_b_c_foo_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;

    /* Initialize the values for member annotations. */
    a_b_c_foo_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    a_b_c_foo_g_tc_members[0]._annotations._defaultValue._u.long_value = 0;
    a_b_c_foo_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    a_b_c_foo_g_tc_members[0]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    a_b_c_foo_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    a_b_c_foo_g_tc_members[0]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    a_b_c_foo_g_tc._data._sampleAccessInfo =
    a_b_c_foo_get_sample_access_info();
    a_b_c_foo_g_tc._data._typePlugin =
    a_b_c_foo_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &a_b_c_foo_g_tc;
}

RTIXCdrSampleAccessInfo *a_b_c_foo_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo a_b_c_foo_g_memberAccessInfos[1] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo a_b_c_foo_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &a_b_c_foo_g_sampleAccessInfo;
    }

    a_b_c_foo_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct a_b_c_foo, data);

    a_b_c_foo_g_sampleAccessInfo.memberAccessInfos =
    a_b_c_foo_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(a_b_c_foo);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            a_b_c_foo_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            a_b_c_foo_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    a_b_c_foo_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &a_b_c_foo_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *a_b_c_foo_get_type_plugin_info()
{
    static RTIXCdrTypePlugin a_b_c_foo_g_typePlugin =
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
        a_b_c_foo_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        a_b_c_foo_finalize_w_return,
        NULL,
        NULL
    };

    return &a_b_c_foo_g_typePlugin;
}
#endif

RTIBool a_b_c_foo_initialize(
    a_b_c_foo* sample)
{
    return a_b_c_foo_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool a_b_c_foo_initialize_w_params(
    a_b_c_foo *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->data = 0;

    return RTI_TRUE;
}
RTIBool a_b_c_foo_initialize_ex(
    a_b_c_foo *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return a_b_c_foo_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool a_b_c_foo_finalize_w_return(
    a_b_c_foo* sample)
{
    a_b_c_foo_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void a_b_c_foo_finalize(
    a_b_c_foo* sample)
{  
    a_b_c_foo_finalize_ex(
        sample, 
        RTI_TRUE);
}

void a_b_c_foo_finalize_ex(
    a_b_c_foo *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    a_b_c_foo_finalize_w_params(
        sample,
        &deallocParams);
}

void a_b_c_foo_finalize_w_params(
    a_b_c_foo *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void a_b_c_foo_finalize_optional_members(
    a_b_c_foo* sample, RTIBool deletePointers)
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

RTIBool a_b_c_foo_copy(
    a_b_c_foo* dst,
    const a_b_c_foo* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->data, 
        &src->data)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'a_b_c_foo' sequence class.
*/
#define T a_b_c_foo
#define TSeq a_b_c_fooSeq

#define T_initialize_w_params a_b_c_foo_initialize_w_params

#define T_finalize_w_params   a_b_c_foo_finalize_w_params
#define T_copy       a_b_c_foo_copy

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

