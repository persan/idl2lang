

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from HelloWorld.idl 
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

#include "HelloWorld.h"

#ifndef NDDS_STANDALONE_TYPE
#include "HelloWorldPlugin.h"
#endif

/* ========================================================================= */
const char *testCodeGen_HelloWorldTYPENAME = "testCodeGen::HelloWorld";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * testCodeGen_HelloWorld_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode testCodeGen_HelloWorld_g_tc_message_string = DDS_INITIALIZE_STRING_TYPECODE(((HELLO_MAX_STRING_SIZE)));

    static DDS_TypeCode_Member testCodeGen_HelloWorld_g_tc_members[2]=
    {

        {
            (char *)"message",/* Member name */
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
            (char *)"value",/* Member name */
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
            RTI_CDR_KEY_MEMBER , /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode testCodeGen_HelloWorld_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"testCodeGen::HelloWorld", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            2, /* Number of members */
            testCodeGen_HelloWorld_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for testCodeGen_HelloWorld*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &testCodeGen_HelloWorld_g_tc;
    }

    testCodeGen_HelloWorld_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    testCodeGen_HelloWorld_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&testCodeGen_HelloWorld_g_tc_message_string;
    testCodeGen_HelloWorld_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_double;

    /* Initialize the values for member annotations. */
    testCodeGen_HelloWorld_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_STRING;
    testCodeGen_HelloWorld_g_tc_members[0]._annotations._defaultValue._u.string_value = (DDS_Char *) "";
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._defaultValue._d = RTI_XCDR_TK_DOUBLE;
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._defaultValue._u.double_value = 0.0;
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._minValue._d = RTI_XCDR_TK_DOUBLE;
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._minValue._u.double_value = RTIXCdrDouble_MIN;
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._maxValue._d = RTI_XCDR_TK_DOUBLE;
    testCodeGen_HelloWorld_g_tc_members[1]._annotations._maxValue._u.double_value = RTIXCdrDouble_MAX;

    testCodeGen_HelloWorld_g_tc._data._sampleAccessInfo =
    testCodeGen_HelloWorld_get_sample_access_info();
    testCodeGen_HelloWorld_g_tc._data._typePlugin =
    testCodeGen_HelloWorld_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &testCodeGen_HelloWorld_g_tc;
}

RTIXCdrSampleAccessInfo *testCodeGen_HelloWorld_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo testCodeGen_HelloWorld_g_memberAccessInfos[2] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo testCodeGen_HelloWorld_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &testCodeGen_HelloWorld_g_sampleAccessInfo;
    }

    testCodeGen_HelloWorld_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct testCodeGen_HelloWorld, message);

    testCodeGen_HelloWorld_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct testCodeGen_HelloWorld, value);

    testCodeGen_HelloWorld_g_sampleAccessInfo.memberAccessInfos =
    testCodeGen_HelloWorld_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(testCodeGen_HelloWorld);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            testCodeGen_HelloWorld_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            testCodeGen_HelloWorld_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    testCodeGen_HelloWorld_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &testCodeGen_HelloWorld_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *testCodeGen_HelloWorld_get_type_plugin_info()
{
    static RTIXCdrTypePlugin testCodeGen_HelloWorld_g_typePlugin =
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
        testCodeGen_HelloWorld_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        testCodeGen_HelloWorld_finalize_w_return,
        NULL,
        NULL
    };

    return &testCodeGen_HelloWorld_g_typePlugin;
}
#endif

RTIBool testCodeGen_HelloWorld_initialize(
    testCodeGen_HelloWorld* sample)
{
    return testCodeGen_HelloWorld_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool testCodeGen_HelloWorld_initialize_w_params(
    testCodeGen_HelloWorld *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    if (allocParams->allocate_memory) {
        sample->message = DDS_String_alloc(((HELLO_MAX_STRING_SIZE)));
        if (sample->message != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->message,
                    "",
                    ((HELLO_MAX_STRING_SIZE)),
                    RTI_FALSE),
                    RTIBool);
        }
        if (sample->message == NULL) {
            return RTI_FALSE;
        }
    } else {
        if (sample->message != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->message,
                    "",
                    ((HELLO_MAX_STRING_SIZE)),
                    RTI_FALSE),
                    RTIBool);
            if (sample->message == NULL) {
                return RTI_FALSE;
            }
        }
    }

    sample->value = 0.0;

    return RTI_TRUE;
}
RTIBool testCodeGen_HelloWorld_initialize_ex(
    testCodeGen_HelloWorld *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return testCodeGen_HelloWorld_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool testCodeGen_HelloWorld_finalize_w_return(
    testCodeGen_HelloWorld* sample)
{
    testCodeGen_HelloWorld_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void testCodeGen_HelloWorld_finalize(
    testCodeGen_HelloWorld* sample)
{  
    testCodeGen_HelloWorld_finalize_ex(
        sample, 
        RTI_TRUE);
}

void testCodeGen_HelloWorld_finalize_ex(
    testCodeGen_HelloWorld *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    testCodeGen_HelloWorld_finalize_w_params(
        sample,
        &deallocParams);
}

void testCodeGen_HelloWorld_finalize_w_params(
    testCodeGen_HelloWorld *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

    if (sample->message != NULL) {
        DDS_String_free(sample->message);
        sample->message=NULL;

    }

}

void testCodeGen_HelloWorld_finalize_optional_members(
    testCodeGen_HelloWorld* sample, RTIBool deletePointers)
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

RTIBool testCodeGen_HelloWorld_copy(
    testCodeGen_HelloWorld* dst,
    const testCodeGen_HelloWorld* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyStringEx (
        &dst->message
        ,
        src->message, 
        ((HELLO_MAX_STRING_SIZE)) + 1,
        RTI_FALSE)){
        return RTI_FALSE;
    }
    if (!RTICdrType_copyDouble (
        &dst->value, 
        &src->value)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'testCodeGen_HelloWorld' sequence class.
*/
#define T testCodeGen_HelloWorld
#define TSeq testCodeGen_HelloWorldSeq

#define T_initialize_w_params testCodeGen_HelloWorld_initialize_w_params

#define T_finalize_w_params   testCodeGen_HelloWorld_finalize_w_params
#define T_copy       testCodeGen_HelloWorld_copy

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

