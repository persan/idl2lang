

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl 
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

#include "Demo.h"

#ifndef NDDS_STANDALONE_TYPE
#include "DemoPlugin.h"
#endif

/* ========================================================================= */
const char *com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME = "com::saabgroup::enterprisebus::idldemo::MyStruct";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[3]=
    {

        {
            (char *)"X",/* Member name */
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
            (char *)"Y",/* Member name */
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
            (char *)"Z",/* Member name */
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

    static DDS_TypeCode com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"com::saabgroup::enterprisebus::idldemo::MyStruct", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            3, /* Number of members */
            com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for com_saabgroup_enterprisebus_idldemo_MyStruct*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc;
    }

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;

    /* Initialize the values for member annotations. */
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._defaultValue._u.long_value = 0;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[0]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._defaultValue._u.long_value = 0;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[1]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._defaultValue._u.long_value = 0;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc_members[2]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc._data._sampleAccessInfo =
    com_saabgroup_enterprisebus_idldemo_MyStruct_get_sample_access_info();
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc._data._typePlugin =
    com_saabgroup_enterprisebus_idldemo_MyStruct_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &com_saabgroup_enterprisebus_idldemo_MyStruct_g_tc;
}

RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_MyStruct_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo com_saabgroup_enterprisebus_idldemo_MyStruct_g_memberAccessInfos[3] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo;
    }

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_MyStruct, X);

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_MyStruct, Y);

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_MyStruct, Z);

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo.memberAccessInfos =
    com_saabgroup_enterprisebus_idldemo_MyStruct_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(com_saabgroup_enterprisebus_idldemo_MyStruct);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_MyStruct_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_MyStruct_get_type_plugin_info()
{
    static RTIXCdrTypePlugin com_saabgroup_enterprisebus_idldemo_MyStruct_g_typePlugin =
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
        com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_return,
        NULL,
        NULL
    };

    return &com_saabgroup_enterprisebus_idldemo_MyStruct_g_typePlugin;
}
#endif

RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize(
    com_saabgroup_enterprisebus_idldemo_MyStruct* sample)
{
    return com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->X = 0;

    sample->Y = 0;

    sample->Z = 0;

    return RTI_TRUE;
}
RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_ex(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_return(
    com_saabgroup_enterprisebus_idldemo_MyStruct* sample)
{
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize(
    com_saabgroup_enterprisebus_idldemo_MyStruct* sample)
{  
    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(
        sample, 
        RTI_TRUE);
}

void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_ex(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(
        sample,
        &deallocParams);
}

void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(
    com_saabgroup_enterprisebus_idldemo_MyStruct *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_optional_members(
    com_saabgroup_enterprisebus_idldemo_MyStruct* sample, RTIBool deletePointers)
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

RTIBool com_saabgroup_enterprisebus_idldemo_MyStruct_copy(
    com_saabgroup_enterprisebus_idldemo_MyStruct* dst,
    const com_saabgroup_enterprisebus_idldemo_MyStruct* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->X, 
        &src->X)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyLong (
        &dst->Y, 
        &src->Y)) { 
        return RTI_FALSE;
    }
    if (!RTICdrType_copyLong (
        &dst->Z, 
        &src->Z)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'com_saabgroup_enterprisebus_idldemo_MyStruct' sequence class.
*/
#define T com_saabgroup_enterprisebus_idldemo_MyStruct
#define TSeq com_saabgroup_enterprisebus_idldemo_MyStructSeq

#define T_initialize_w_params com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params

#define T_finalize_w_params   com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params
#define T_copy       com_saabgroup_enterprisebus_idldemo_MyStruct_copy

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
const char *com_saabgroup_enterprisebus_idldemo_VariantsTYPENAME = "com::saabgroup::enterprisebus::idldemo::Variants";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_Variants_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member com_saabgroup_enterprisebus_idldemo_Variants_g_tc_members[3]=
    {

        {
            (char *)"Var1",/* Member name */
            {
                0, /* Ignored */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            Var1,
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PRIVATE_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"Var2",/* Member name */
            {
                0, /* Ignored */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            Var2,
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PRIVATE_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"Var3",/* Member name */
            {
                0, /* Ignored */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            Var3,
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PRIVATE_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode com_saabgroup_enterprisebus_idldemo_Variants_g_tc =
    {{
            DDS_TK_ENUM, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"com::saabgroup::enterprisebus::idldemo::Variants", /* Name */
            NULL,     /* Base class type code is assigned later */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            3, /* Number of members */
            com_saabgroup_enterprisebus_idldemo_Variants_g_tc_members, /* Members */
            DDS_VM_NONE, /* Type Modifier */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for com_saabgroup_enterprisebus_idldemo_Variants*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &com_saabgroup_enterprisebus_idldemo_Variants_g_tc;
    }

    com_saabgroup_enterprisebus_idldemo_Variants_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    /* Initialize the values for annotations. */
    com_saabgroup_enterprisebus_idldemo_Variants_g_tc._data._annotations._defaultValue._d = RTI_XCDR_TK_ENUM;
    com_saabgroup_enterprisebus_idldemo_Variants_g_tc._data._annotations._defaultValue._u.long_value = 0;

    com_saabgroup_enterprisebus_idldemo_Variants_g_tc._data._sampleAccessInfo =
    com_saabgroup_enterprisebus_idldemo_Variants_get_sample_access_info();
    com_saabgroup_enterprisebus_idldemo_Variants_g_tc._data._typePlugin =
    com_saabgroup_enterprisebus_idldemo_Variants_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &com_saabgroup_enterprisebus_idldemo_Variants_g_tc;
}

RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_Variants_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo com_saabgroup_enterprisebus_idldemo_Variants_g_memberAccessInfos[1] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo;
    }

    com_saabgroup_enterprisebus_idldemo_Variants_g_memberAccessInfos[0].bindingMemberValueOffset[0] = 0;

    com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo.memberAccessInfos =
    com_saabgroup_enterprisebus_idldemo_Variants_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(com_saabgroup_enterprisebus_idldemo_Variants);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_Variants_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_Variants_get_type_plugin_info()
{
    static RTIXCdrTypePlugin com_saabgroup_enterprisebus_idldemo_Variants_g_typePlugin =
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
        com_saabgroup_enterprisebus_idldemo_Variants_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_return,
        NULL,
        NULL
    };

    return &com_saabgroup_enterprisebus_idldemo_Variants_g_typePlugin;
}
#endif

RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize(
    com_saabgroup_enterprisebus_idldemo_Variants* sample)
{

    *sample = Var1;
    return RTI_TRUE;
}
RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize_w_params(
    com_saabgroup_enterprisebus_idldemo_Variants *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }
    *sample = Var1;
    return RTI_TRUE;
}
RTIBool com_saabgroup_enterprisebus_idldemo_Variants_initialize_ex(
    com_saabgroup_enterprisebus_idldemo_Variants *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return com_saabgroup_enterprisebus_idldemo_Variants_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_return(
    com_saabgroup_enterprisebus_idldemo_Variants* sample)
{
    RTIOsapiUtility_unusedParameter(sample);

    return RTI_TRUE;
}

void com_saabgroup_enterprisebus_idldemo_Variants_finalize(
    com_saabgroup_enterprisebus_idldemo_Variants* sample)
{  
    if (sample==NULL) {
        return;
    }
}

void com_saabgroup_enterprisebus_idldemo_Variants_finalize_ex(
    com_saabgroup_enterprisebus_idldemo_Variants *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_params(
        sample,
        &deallocParams);
}

void com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_params(
    com_saabgroup_enterprisebus_idldemo_Variants *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void com_saabgroup_enterprisebus_idldemo_Variants_finalize_optional_members(
    com_saabgroup_enterprisebus_idldemo_Variants* sample, RTIBool deletePointers)
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

RTIBool com_saabgroup_enterprisebus_idldemo_Variants_copy(
    com_saabgroup_enterprisebus_idldemo_Variants* dst,
    const com_saabgroup_enterprisebus_idldemo_Variants* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    return RTICdrType_copyEnum((RTICdrEnum *)dst, (RTICdrEnum *)src);

}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'com_saabgroup_enterprisebus_idldemo_Variants' sequence class.
*/
#define T com_saabgroup_enterprisebus_idldemo_Variants
#define TSeq com_saabgroup_enterprisebus_idldemo_VariantsSeq

#define T_initialize_w_params com_saabgroup_enterprisebus_idldemo_Variants_initialize_w_params

#define T_finalize_w_params   com_saabgroup_enterprisebus_idldemo_Variants_finalize_w_params
#define T_copy       com_saabgroup_enterprisebus_idldemo_Variants_copy

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
const char *com_saabgroup_enterprisebus_idldemo_DemoTYPENAME = "com::saabgroup::enterprisebus::idldemo::Demo";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * com_saabgroup_enterprisebus_idldemo_Demo_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[4]=
    {

        {
            (char *)"aStruct",/* Member name */
            {
                1,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            1, /* Number of labels */
            (0),
            NULL, /* Labels (it is NULL when there is only one label)*/
            RTI_CDR_NONKEY_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"aBoolean",/* Member name */
            {
                2,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            1, /* Number of labels */
            (1),
            NULL, /* Labels (it is NULL when there is only one label)*/
            RTI_CDR_NONKEY_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"aLong",/* Member name */
            {
                3,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            1, /* Number of labels */
            (2),
            NULL, /* Labels (it is NULL when there is only one label)*/
            RTI_CDR_NONKEY_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"aDouble",/* Member name */
            {
                4,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            1, /* Number of labels */
            RTI_CDR_TYPE_CODE_UNION_DEFAULT_LABEL, /* First label */
            NULL, /* Labels (it is NULL when there is only one label)*/
            RTI_CDR_NONKEY_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode com_saabgroup_enterprisebus_idldemo_Demo_g_tc =
    {{
            DDS_TK_UNION, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            3, /*Ignored*/
            (char *)"com::saabgroup::enterprisebus::idldemo::Demo", /* Name */
            NULL,     /* Base class type code is assigned later */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            4, /* Number of members */
            com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members, /* Members */
            DDS_VM_NONE, /* Type Modifier */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for com_saabgroup_enterprisebus_idldemo_Demo*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &com_saabgroup_enterprisebus_idldemo_Demo_g_tc;
    }

    com_saabgroup_enterprisebus_idldemo_Demo_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)com_saabgroup_enterprisebus_idldemo_MyStruct_get_typecode();
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_boolean;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;

    /* Initialize the values for member annotations. */
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[1]._annotations._defaultValue._d = RTI_XCDR_TK_BOOLEAN;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[1]._annotations._defaultValue._u.boolean_value = 0;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._defaultValue._u.long_value = 0;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[2]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._defaultValue._u.double_value = 0.0;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc_members[3]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;

    /* Discriminator type code */
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc._data._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;

    com_saabgroup_enterprisebus_idldemo_Demo_g_tc._data._sampleAccessInfo =
    com_saabgroup_enterprisebus_idldemo_Demo_get_sample_access_info();
    com_saabgroup_enterprisebus_idldemo_Demo_g_tc._data._typePlugin =
    com_saabgroup_enterprisebus_idldemo_Demo_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &com_saabgroup_enterprisebus_idldemo_Demo_g_tc;
}

RTIXCdrSampleAccessInfo *com_saabgroup_enterprisebus_idldemo_Demo_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[5] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo;
    }

    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_Demo, _d);

    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_Demo, _u.aStruct);

    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_Demo, _u.aBoolean);

    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[3].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_Demo, _u.aLong);

    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos[4].bindingMemberValueOffset[0] =
    offsetof(struct com_saabgroup_enterprisebus_idldemo_Demo, _u.aDouble);

    com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo.memberAccessInfos =
    com_saabgroup_enterprisebus_idldemo_Demo_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(com_saabgroup_enterprisebus_idldemo_Demo);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &com_saabgroup_enterprisebus_idldemo_Demo_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *com_saabgroup_enterprisebus_idldemo_Demo_get_type_plugin_info()
{
    static RTIXCdrTypePlugin com_saabgroup_enterprisebus_idldemo_Demo_g_typePlugin =
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
        com_saabgroup_enterprisebus_idldemo_Demo_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_return,
        NULL,
        NULL
    };

    return &com_saabgroup_enterprisebus_idldemo_Demo_g_typePlugin;
}
#endif

DDS_LongLong com_saabgroup_enterprisebus_idldemo_Demo_getDefaultDiscriminator(void)
{
    return 0;
}

RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize(
    com_saabgroup_enterprisebus_idldemo_Demo* sample)
{
    return com_saabgroup_enterprisebus_idldemo_Demo_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize_w_params(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->_d = (DDS_Long)com_saabgroup_enterprisebus_idldemo_Demo_getDefaultDiscriminator();
    if (!com_saabgroup_enterprisebus_idldemo_MyStruct_initialize_w_params(
        &sample->_u.aStruct,
        allocParams)) {
        return RTI_FALSE;
    }
    sample->_u.aBoolean = 0;

    sample->_u.aLong = 0;

    sample->_u.aDouble = 0.0;

    return RTI_TRUE;
}
RTIBool com_saabgroup_enterprisebus_idldemo_Demo_initialize_ex(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return com_saabgroup_enterprisebus_idldemo_Demo_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_return(
    com_saabgroup_enterprisebus_idldemo_Demo* sample)
{
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void com_saabgroup_enterprisebus_idldemo_Demo_finalize(
    com_saabgroup_enterprisebus_idldemo_Demo* sample)
{  
    com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(
        sample, 
        RTI_TRUE);
}

void com_saabgroup_enterprisebus_idldemo_Demo_finalize_ex(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params(
        sample,
        &deallocParams);
}

void com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params(
    com_saabgroup_enterprisebus_idldemo_Demo *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

    com_saabgroup_enterprisebus_idldemo_MyStruct_finalize_w_params(
        &sample->_u.aStruct,
        deallocParams);

}

void com_saabgroup_enterprisebus_idldemo_Demo_finalize_optional_members(
    com_saabgroup_enterprisebus_idldemo_Demo* sample, RTIBool deletePointers)
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

    switch(sample->_d) {
        case 0:
        {
        } break ;
        case 1:
        {
        } break ;
        case 2:
        {
        } break ;
        default:
        {
        } ;
    }
}

RTIBool com_saabgroup_enterprisebus_idldemo_Demo_copy(
    com_saabgroup_enterprisebus_idldemo_Demo* dst,
    const com_saabgroup_enterprisebus_idldemo_Demo* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->_d, 
        &src->_d)) { 
        return RTI_FALSE;
    }
    switch(src->_d) {

        case 0:
        {
            if (!com_saabgroup_enterprisebus_idldemo_MyStruct_copy(
                &dst->_u.aStruct,
                (const com_saabgroup_enterprisebus_idldemo_MyStruct*)&src->_u.aStruct)) {
                return RTI_FALSE;
            } 
        } break ;
        case 1:
        {
            if (!RTICdrType_copyBoolean (
                &dst->_u.aBoolean, 
                &src->_u.aBoolean)) { 
                return RTI_FALSE;
            }
        } break ;
        case 2:
        {
            if (!RTICdrType_copyLong (
                &dst->_u.aLong, 
                &src->_u.aLong)) { 
                return RTI_FALSE;
            }
        } break ;
        default:
        {
            if (!RTICdrType_copyDouble (
                &dst->_u.aDouble, 
                &src->_u.aDouble)) { 
                return RTI_FALSE;
            }
        } ;

    }
    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'com_saabgroup_enterprisebus_idldemo_Demo' sequence class.
*/
#define T com_saabgroup_enterprisebus_idldemo_Demo
#define TSeq com_saabgroup_enterprisebus_idldemo_DemoSeq

#define T_initialize_w_params com_saabgroup_enterprisebus_idldemo_Demo_initialize_w_params

#define T_finalize_w_params   com_saabgroup_enterprisebus_idldemo_Demo_finalize_w_params
#define T_copy       com_saabgroup_enterprisebus_idldemo_Demo_copy

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

