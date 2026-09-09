

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Constants.idl 
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

#include "Constants.h"

#ifndef NDDS_STANDALONE_TYPE
#include "ConstantsPlugin.h"
#endif

/* ========================================================================= */

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * MYLONG_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode MYLONG_g_tc =
    {{
            DDS_TK_ALIAS, /* Kind*/
            DDS_BOOLEAN_FALSE,/* Is a pointer? */
            -1, /* Ignored */
            (char *)"MYLONG", /* Name */
            NULL, /* Content type code is assigned later */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for  MYLONG */

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &MYLONG_g_tc;
    }

    MYLONG_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    MYLONG_g_tc._data._typeCode =   (RTICdrTypeCode *)&DDS_g_tc_long;

    /* Initialize the values for member annotations. */
    MYLONG_g_tc._data._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    MYLONG_g_tc._data._annotations._defaultValue._u.long_value = 0;
    MYLONG_g_tc._data._annotations._minValue._d = RTI_XCDR_TK_LONG;
    MYLONG_g_tc._data._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    MYLONG_g_tc._data._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    MYLONG_g_tc._data._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    MYLONG_g_tc._data._sampleAccessInfo =
    MYLONG_get_sample_access_info();
    MYLONG_g_tc._data._typePlugin =
    MYLONG_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &MYLONG_g_tc;
}

RTIXCdrSampleAccessInfo *MYLONG_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo MYLONG_g_memberAccessInfos[1] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo MYLONG_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &MYLONG_g_sampleAccessInfo;
    }

    MYLONG_g_memberAccessInfos[0].bindingMemberValueOffset[0] = 0;

    MYLONG_g_sampleAccessInfo.memberAccessInfos =
    MYLONG_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(MYLONG);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            MYLONG_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            MYLONG_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    MYLONG_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &MYLONG_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *MYLONG_get_type_plugin_info()
{
    static RTIXCdrTypePlugin MYLONG_g_typePlugin =
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
        MYLONG_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        MYLONG_finalize_w_return,
        NULL,
        NULL
    };

    return &MYLONG_g_typePlugin;
}
#endif

RTIBool MYLONG_initialize(
    MYLONG* sample)
{
    return MYLONG_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool MYLONG_initialize_w_params(
    MYLONG *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    (*sample) = 0;

    return RTI_TRUE;
}
RTIBool MYLONG_initialize_ex(
    MYLONG *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return MYLONG_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool MYLONG_finalize_w_return(
    MYLONG* sample)
{
    MYLONG_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void MYLONG_finalize(
    MYLONG* sample)
{  
    MYLONG_finalize_ex(
        sample, 
        RTI_TRUE);
}

void MYLONG_finalize_ex(
    MYLONG *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    MYLONG_finalize_w_params(
        sample,
        &deallocParams);
}

void MYLONG_finalize_w_params(
    MYLONG *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void MYLONG_finalize_optional_members(
    MYLONG* sample, RTIBool deletePointers)
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

RTIBool MYLONG_copy(
    MYLONG* dst,
    const MYLONG* src)
{

    if (!RTICdrType_copyLong (
        dst, 
        src)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'MYLONG' sequence class.
*/
#define T MYLONG
#define TSeq MYLONGSeq

#define T_initialize_w_params MYLONG_initialize_w_params

#define T_finalize_w_params   MYLONG_finalize_w_params
#define T_copy       MYLONG_copy

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

